//
//  ParleoEvent.swift
//  Parleo
//
//  Created by Artyom Shaiter on 4/21/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import ObjectMapper

struct ParleoEvent {
    var id: String = ""
    var title: String = ""
    var description: String = ""
    var eventImageURL: URL?
    var maxParticipants = Int()
    var participants = [UUID]()
    var latitude = Double()
    var longitude = Double()
    var startTime = Date()
    var endTime = Date()
    var creatorId: String = ""
    var languageId: String = ""
}

extension ParleoEvent: Mappable {
    
    init?(map: Map) {
        if map.JSON["id"] == nil { return nil }
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        title <- map["name"]
        description <- map["description"]
        maxParticipants <- map["maxParticipants"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        startTime <- map["startTime"]
        endTime <- map["endDate"]
        
        var imageName: String = ""
        imageName <- map["image"]
        eventImageURL = URL(string: imageName)
    }
}
