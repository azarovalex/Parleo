//
//  FilterCellConfigurator.swift
//  Parleo
//
//  Created by Alex Azarov on 3/24/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NotificationCellsConfigurator {

    private var tableView: UITableView
    let declineRelay = PublishRelay<AppNotification>()
    let acceptRelay = PublishRelay<AppNotification>()

    init(tableView: UITableView) {
        self.tableView = tableView
    }

    func getCell(for notification: AppNotification, for index: Int) -> UITableViewCell {
        switch notification.type! {
        case .friendAdded:
            return getFriendAddedCell(for: index, model: notification)
        case .friendRequest:
            return getFriendRequestCell(for: index, model: notification)
        }
    }
}

// MARK: Cell Configurator
private extension NotificationCellsConfigurator {

    func getFriendAddedCell(for index: Int, model: AppNotification) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.friendAddedCell,
                                                            for: IndexPath(item: index, section: 0)) else { return UITableViewCell() }
        cell.configure(with: model)
        return cell
    }

    func getFriendRequestCell(for index: Int, model: AppNotification) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.friendRequestCell,
                                                            for: IndexPath(item: index, section: 0)) else { return UITableViewCell() }
        cell.configure(with: model, acceptAction: { [unowned self] in self.acceptRelay.accept(model) },
                       declineAction: { [unowned self] in self.declineRelay.accept(model) })
        return cell
    }
}

