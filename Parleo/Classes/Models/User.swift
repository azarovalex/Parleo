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
    var accountImage: URL?
    var name: String?
    var about: String?
    var birthdate: Date?
    var isMale: Bool = false
    var distanceFromCurrentUser: Double = 0
    var email: String?
    var createdEvents = [Int]()
    var languages = [Int]()
    var friends = [Int]()
    var attendingEvents = [Int]()
    var hobbies = [Int]()
}

extension User: Mappable {

    init?(map: Map) {
        if map.JSON["id"] == nil { return nil }
    }

    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        about <- map["about"]
        birthdate <- map["birthdate"]
        isMale <- map["gender"]
        distanceFromCurrentUser <- map["distanceFromCurrentUser"]
        email <- map["email"]

        var imageName: String = ""
        imageName <- map["accountImage"]
        print(imageName)
        accountImage = URL(string: "https://awesomeparleobackend.azurewebsites.net/account-images/" + imageName)
    }
}


