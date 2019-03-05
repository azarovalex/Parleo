//
//  User.swift
//  Parleo
//
//  Created by Alex Azarov on 3/5/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import ObjectMapper

struct User {
    var id = 0
    var email: String = ""
}

extension User: Mappable {
    init?(map: Map) {
        if map.JSON["id"] == nil { return nil }
    }

    mutating func mapping(map: Map) {
        id <- map["id"]
        email <- map["email"]
    }
}
