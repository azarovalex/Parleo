//
//  EventsViewController.swift
//  Parleo
//
//  Created by Artyom Shaiter on 3/18/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import RxCocoa
import RxSwift
import SegueManager

class EventsViewController: SegueManagerViewController {

    @IBOutlet private var filterBarButton: UIBarButtonItem!
    @IBOutlet private var addEventBarButton: UIBarButtonItem!
    @IBOutlet private var eventsTableView: UITableView! {
        didSet {
            eventsTableView.register(R.nib.eventTableViewCell)
            eventsTableView.refreshControl = refreshControl
        }
    }
    @IBOutlet private var eventsSegmentedControl: UISegmentedControl!
    
    private var refreshControl = UIRefreshControl()
    private let viewModel = EventsViewModel()
    private let bag = DisposeBag()
    private let isSpinnerVisibleRelay = BehaviorRelay<Bool>(value: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindData()
    }
    
    private func bindData() {
        let input = EventsViewModel.Input(viewEvent: eventsTableView.rx.itemSelected.asSignal(),
                                          fetchNextPage: getNextPageSignal(),
                                          changeContent: eventsSegmentedControl.rx.selectedSegmentIndex
                                            .map{ EventsViewModel.Content(rawValue: $0) ?? .allEvents }
                                            .asSignal(onErrorSignalWith: .never()))
        
        let output = viewModel.transform(input: input)
        
        output.cells.drive(eventsTableView.rx.items) { [weak self] _, index, model in
            guard let cell = self?.eventsTableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.eventTableViewCell, for: IndexPath(row: index, section: 0)) else {
                return UITableViewCell()
            }
            cell.viewModel = model
            return cell
        }.disposed(by: bag)

        eventsTableView.rx.modelSelected(EventTableCellViewModel.self)
            .bind(to: rx.navigate(with: R.segue.eventsViewController.fromEventsToDetails))
            .disposed(by: bag)

        filterBarButton.rx.tap
            .bind(to: rx.navigate(with: R.segue.eventsViewController.fromEventsToFilter,
                                  segueHandler: { segue, _ in segue.destination.screenConfiguration = .filterEvents }))
            .disposed(by: bag)
        
        refreshControl.rx.action = output.refreshAction
    }
}


// MARK: - Private
private extension EventsViewController {
    func getNextPageSignal() -> Signal<Void> {
        return eventsTableView.rx.willEndDragging
            .map { [unowned self] _, target -> CGFloat in
                return self.eventsTableView.contentSize.height - (target.pointee.y + self.eventsTableView.bounds.height) }
            .withLatestFrom(isSpinnerVisibleRelay) { (distance: $0, isSpinnerVisible: $1) }
            .filter { !$0.isSpinnerVisible && $0.distance < 200 }.map { _ in }
            .asSignal(onErrorSignalWith: .never())
    }
    
    var commentsSpinner: Binder<Bool> {
        let spinner = UIActivityIndicatorView(style: .gray)
        spinner.startAnimating()
        spinner.frame = CGRect(x: 0, y: 0, width: eventsTableView.bounds.width, height: 50)
        return Binder(eventsTableView, binding: { $0.tableFooterView = $1 ? spinner : nil })
    }
}
