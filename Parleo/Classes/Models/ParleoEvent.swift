//
//  ParleoEvent.swift
//  Parleo
//
//  Created by Artyom Shaiter on 4/21/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import ObjectMapper

struct ParleoEvent {
    struct Participants {
        var id: String = ""
        var imageURL: URL?
        var name: String = ""
    }
    
    var id: String = ""
    var title: String = ""
    var description: String = ""
    var eventImageURL: URL?
    var maxParticipants = Int()
    var latitude = Double()
    var longitude = Double()
    var startTime = Date()
    var endTime = Date()
    var creatorId: String = ""
    var language: LanguageId?
    var participants = [Participants]()
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
        language <- map["language"]
        eventImageURL <- (map["image"], URLTransform())
        participants <- map["participants"]
    }
}

extension ParleoEvent.Participants: Mappable {
    init?(map: Map) {
        if map.JSON["id"] == nil { return nil }
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        imageURL <- (map["image"], URLTransform())
        name <- map["name"]
    }
}
