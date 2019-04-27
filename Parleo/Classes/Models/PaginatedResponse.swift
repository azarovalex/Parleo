//
//  PaginatedResponse.swift
//  Parleo
//
//  Created by Alex Azarov on 4/27/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import ObjectMapper

struct PagedResponse<T: BaseMappable> {
    var items = [T]()
    var pageNumber: Int = 0
    var pageSize: Int = 0
    var totalAmount: Int = 0
}

extension PagedResponse: Mappable {

    init?(map: Map) {
        if map.JSON["totalAmount"] == nil { return nil }
    }

    mutating func mapping(map: Map) {
        items <- map["entities"]
        pageNumber <- map["pageNumber"]
        pageSize <- map["pageSize"]
        totalAmount <- map["totalAmount"]
    }
}

