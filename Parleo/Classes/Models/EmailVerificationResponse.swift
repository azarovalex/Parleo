//
//  EmailVerificationResponse.swift
//  Parleo
//
//  Created by Alex Azarov on 5/12/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import ObjectMapper

struct EmailVerificationResponse {
    var token: String = ""
    var id: String = ""
}

extension EmailVerificationResponse: Mappable {

    init?(map: Map) {
        if map.JSON["token"] == nil { return nil }
    }

    mutating func mapping(map: Map) {
        token <- map["token"]
        id <- map["id"]
    }
}
