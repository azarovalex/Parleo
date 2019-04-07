//
//  AppNotification.swift
//  Parleo
//
//  Created by Alex Azarov on 3/31/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import ObjectMapper

struct AppNotification {

    enum AppNotificationType: String {
        case friendAdded
        case friendRequest
    }

    var type: AppNotificationType!
    var username = ""
    var timeStamp = ""
}

extension AppNotification: Mappable {

    init?(map: Map) {
        if map.JSON["type"] == nil { return nil }
    }

    mutating func mapping(map: Map) {
        type <- (map["type"], EnumTransform())
        username <- map["username"]
        timeStamp <- map["timeStamp"]
    }
}
