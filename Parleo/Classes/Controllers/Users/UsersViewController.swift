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

class UsersViewController: SegueManagerViewController {

    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var filterButton: UIBarButtonItem!

    private var refreshController = UIRefreshControl()
    private let viewModel = UsersViewModel()
    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
}

// MARK: - Setup
private extension UsersViewController {

    func setup() {
        tableView.register(R.nib.userCell)
        tableView.refreshControl = refreshController
        bindViewModel()
        bindFilterButton()
    }

    func bindViewModel() {
        let input = UsersViewModel.Input()
        let output = viewModel.transform(input: input)

        output.cells.drive(tableView.rx.items) { [unowned self] _, index, model in
            return self.tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.userCell, for: IndexPath(row: index, section: 0))!
        }.disposed(by: bag)
        refreshController.rx.action = output.refreshAction
        tableView.rx.modelSelected(Void.self)
            .bind(to: rx.navigate(with: R.segue.usersViewController.fromUserListToUserInfo))
            .disposed(by: bag)
    }

    func bindFilterButton() {
        filterButton.rx.tap.bind(to: rx.navigate(with: R.segue.usersViewController.fromUsersListToFilter, segueHandler: { segue, _ in
            segue.destination.screenConfiguration = .filterUsers
        })).disposed(by: bag)
    }
}
