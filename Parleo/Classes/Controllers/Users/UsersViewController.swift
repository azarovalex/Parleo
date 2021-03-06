//
//  UsersViewController.swift
//  Parleo
//
//  Created by Alex Azarov on 3/18/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import RxSwift
import RxCocoa
import SegueManager

struct UsersFilter {
    var isMale = true
    var isFemale = true
    var minAge = 16
    var maxAge = 65
    var languages = [Language]()
}

class UsersViewController: SegueManagerViewController {

    enum ScreenConfiguration {
        case allUsers, friends
    }

    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var filterButton: UIBarButtonItem!

    private let isSpinnerVisibleRelay = BehaviorRelay<Bool>(value: false)
    private var refreshControl = UIRefreshControl()
    private let viewModel = UsersViewModel()
    private let bag = DisposeBag()

    private var filterRelay = BehaviorRelay<UsersFilter>(value: UsersFilter())

    var screenConfiguration = ScreenConfiguration.allUsers

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
}

// MARK: - Setup
private extension UsersViewController {

    func setup() {
        tableView.register(R.nib.userCell)
        tableView.refreshControl = refreshControl
        bindViewModel()
        bindFilterButton()
        navigationItem.title = (screenConfiguration == .allUsers) ? "Users" : "Friends"
    }

    func bindViewModel() {
        let input = UsersViewModel.Input(fetchNextPage: getNextPageSignal(),
                                         screenConfiguration: screenConfiguration,
                                         filter: filterRelay,
                                         filterUpdated: filterRelay.asSignal { _ in .never() }.map { _ in })
        let output = viewModel.transform(input: input)

        refreshControl.rx.action = output.refreshAction
        output.error.emit(to: rx.error).disposed(by: bag)
        output.error
            .emit(onNext: { [unowned self] _ in self.tableView.contentOffset = .zero })
            .disposed(by: bag)
        output.cells.drive(tableView.rx.items) { tableView, index, model in
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.userCell, for: IndexPath(row: index, section: 0))!
            cell.configure(with: model)
            return cell
        }.disposed(by: bag)
        output.isPaginationLoading
            .filter { [unowned self] _ in !self.refreshControl.isRefreshing }
            .drive(commentsSpinner).disposed(by: bag)
        tableView.rx.modelSelected(User.self)
            .bind(to: rx.navigate(with: R.segue.usersViewController.fromUserListToUserInfo,
                                  segueHandler: { segue, user in
                                    var user = user
                                    if self.screenConfiguration == .friends { user.isFriend = true }
                                    segue.destination.user = user
            }))
            .disposed(by: bag)
    }

    func bindFilterButton() {
        guard screenConfiguration == .allUsers else { filterButton.isEnabled = false; filterButton.tintColor = .clear; return }
        filterButton.rx.tap.bind(to: rx.navigate(with: R.segue.usersViewController.fromUsersListToFilter, segueHandler: { segue, _ in
            segue.destination.screenConfiguration = .filterUsers
            segue.destination.filter = self.filterRelay.value
            segue.destination.delegate = self
        })).disposed(by: bag)
    }
}

// MARK: - Private
private extension UsersViewController {

    func getNextPageSignal() -> Signal<Void> {
        return tableView.rx.willEndDragging
            .map { [unowned self] _, target -> CGFloat in
                return self.tableView.contentSize.height - (target.pointee.y + self.tableView.bounds.height) }
            .withLatestFrom(isSpinnerVisibleRelay) { (distance: $0, isSpinnerVisible: $1) }
            .filter { !$0.isSpinnerVisible && $0.distance < 200 }.map { _ in }
            .asSignal(onErrorSignalWith: .never())
    }

    var commentsSpinner: Binder<Bool> {
        let spinner = UIActivityIndicatorView(style: .gray)
        spinner.startAnimating()
        spinner.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 50)
        return Binder(tableView, binding: { $0.tableFooterView = $1 ? spinner : nil })
    }
}

extension UsersViewController: FilterViewControllerDelegate {

    func updateFilter(filter: UsersFilter) {
        filterRelay.accept(filter)
    }
}
