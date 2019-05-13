//
//  UserUpdate.swift
//  Parleo
//
//  Created by Alex Azarov on 5/12/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import ObjectMapper

struct UserUpdate {
    var name = ""
    var about = ""
    var birthdate: Date?
    var isMale: Bool?
    var languages = [Language]()
    var hobbies = [Hobbie]()
}

extension UserUpdate: Mappable {

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        name <- map["name"]
        about <- map["about"]
        birthdate <- (map["birthdate"], ISO8601DateTransform())
        isMale <- map["gender"]
        languages <- map["languages"]
        hobbies <- map["hobbies"]
    }
}
