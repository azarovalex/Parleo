//
//  Language.swift
//  Parleo
//
//  Created by Alex Azarov on 4/27/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import ObjectMapper

struct Language {
    var code: String!
    var level: Int = 0
}

extension Language: Mappable {

    init?(map: Map) {
        if map.JSON["code"] == nil { return nil }
    }

    mutating func mapping(map: Map) {
        code <- map["code"]
        level <- map["level"]
    }
}
