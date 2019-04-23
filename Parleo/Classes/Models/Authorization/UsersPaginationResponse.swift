//
//  UsersPaginationResponse.swift
//  Parleo
//
//  Created by Alex Azarov on 4/22/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import ObjectMapper

struct UsersPaginationResponse {
    var entities: [User] = []
    var pageNumber: Int = 0
    var pageSize: Int = 0
    var totalAmount: Int = 0
}

extension UsersPaginationResponse: Mappable {

    init?(map: Map) {
        if map.JSON["totalAmount"] == nil { return nil }
    }

    mutating func mapping(map: Map) {
        entities <- map["entities"]
        pageNumber <- map["pageNumber"]
        pageSize <- map["pageSize"]
        totalAmount <- map["totalAmount"]
    }
}
