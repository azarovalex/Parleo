//
//  Hobbie.swift
//  Parleo
//
//  Created by Alex Azarov on 4/27/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import ObjectMapper

struct Hobbie {
    var name: String = ""
    var category: String?
}

extension Hobbie: Mappable {

    init?(map: Map) {
        if map.JSON["name"] == nil { return nil }
    }

    mutating func mapping(map: Map) {
        name <- map["name"]
        category <- map["category"]
    }
}
