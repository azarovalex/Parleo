//
//  User.swift
//  Parleo
//
//  Created by Alex Azarov on 3/5/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import ObjectMapper

struct User {
    var id: String!
    var accountImage: String?
    var name: String?
    var about: String?
    var birthdate: Date?
    var isMale: Bool = false
    var latitude: Double = 0
    var longitude: Double = 0
    var email: String = ""
}

extension User: Mappable {

    init?(map: Map) {
        if map.JSON["id"] == nil { return nil }
    }

    mutating func mapping(map: Map) {
        id <- map["id"]
        accountImage <- map["accountImage"]
        name <- map["name"]
        about <- map["about"]
        birthdate <- map["birthdate"]
        isMale <- map["gender"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        email <- map["email"]
    }
}


