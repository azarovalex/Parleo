//
//  NotificationsViewController.swift
//  Parleo
//
//  Created by Alex Azarov on 3/31/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import RxSwift
import RxCocoa

class NotificationsViewController: UIViewController {

    @IBOutlet private var tableView: UITableView!

    private lazy var cellsConfigurator = NotificationCellsConfigurator(tableView: tableView)
    private var refreshControl = UIRefreshControl()
    private let viewModel = NotificationsViewModel()
    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
}


// MARK: - Setup
private extension NotificationsViewController {

    func setup() {
        setupTableView()
        bindViewModel()
    }

    func setupTableView() {
        tableView.register(R.nib.friendAddedCell)
        tableView.register(R.nib.friendRequestCell)
        tableView.refreshControl = refreshControl
        tableView.tableFooterView = UIView()
        bindCellActions()
    }

    func bindViewModel() {
        let output = viewModel.transform(input: NotificationsViewModel.Input())
        output.errors.emit(to: rx.error).disposed(by: bag)
        output.category.drive(tableView.rx.items) { [unowned self] _, index, model in
            return self.cellsConfigurator.getCell(for: model, for: index)
        }.disposed(by: bag)
        refreshControl.rx.action = output.reloadAction
        output.errors.emit(onNext: { [unowned self] _ in self.tableView.contentOffset = .zero }).disposed(by: bag)
    }

    func bindCellActions() {
        cellsConfigurator.acceptRelay.bind { notification in
            let alert = UIAlertController(title: "Test", message: "Adding \(notification.username) as friend!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(alert, animated: true)
        }.disposed(by: bag)

        cellsConfigurator.declineRelay.bind { notification in
            let alert = UIAlertController(title: "Test", message: "\(notification.username) is not your friend. 😞", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(alert, animated: true)
        }.disposed(by: bag)
    }


}
