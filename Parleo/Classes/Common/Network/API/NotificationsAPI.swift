//
//  NotificationsAPI.swift
//  Parleo
//
//  Created by Alex Azarov on 3/31/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import Moya

enum NotificationsAPI {
    case getNotifications
}

extension NotificationsAPI: TargetType {

    var baseURL: URL { return Credentials.Backend.stage }

    var path: String {
        switch self {
        case .getNotifications:
            return "/login"
        }
    }

    var method: Method {
        return .get
    }

    var sampleData: Data {
        switch self {
        case .getNotifications:
            return .mockedNotifications()
        }
    }

    var task: Task {
        return .requestPlain
    }

    var headers: [String : String]? {
        return [:]
    }
}

private extension Data {

    static func mockedNotifications() -> Data {
        let names = ["Tadeush Miksha", "Azarov Alex", "Barak Obama", "Margeret Kocherga"]
        let dates = ["today", "6 hours ago", "yesterday", "tomorrow"]

        var notifications = [AppNotification]()
        for _ in 0...10 {
            notifications.append(AppNotification(type: Bool.random() ? .friendRequest : .friendAdded,
                                                 username: names.randomElement()!, timeStamp: dates.randomElement()!))
        }

        return notifications.toJSONString()!.data(using: .utf8)!
    }
}

