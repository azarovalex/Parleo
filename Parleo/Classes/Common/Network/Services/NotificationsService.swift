//
//  NotificationsService.swift
//  Parleo
//
//  Created by Alex Azarov on 3/31/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import Moya
import RxSwift

struct NotificationsService: NetworkService {

    var provider = MoyaProvider<NotificationsAPI>()

    func getNotifications() -> Single<Result<[AppNotification]>> {
        return fetchArray(.getNotifications)
    }
}

