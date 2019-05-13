//
//  Language.swift
//  Parleo
//
//  Created by Alex Azarov on 4/27/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import ObjectMapper

enum LanguageLevel: Int {
    case beginner = 1
    case elementary
    case intermediate
    case advanced
    case native

    var description: String {
        switch self {
        case .beginner:
            return "Beginner"
        case .elementary:
            return "Elementary"
        case .intermediate:
            return "Intermediate"
        case .advanced:
            return "Advanced"
        case .native:
            return "Native"
        }
    }
}


struct Language {
    var code: String!
    var level: LanguageLevel = .beginner

    var name: String {
        return LanguageNameManager.shared.getLanguageName(for: code) ?? code
    }
    var flagImage: UIImage {
        return UIImage(named: code) ?? R.image.flagTemplate()!
    }
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

struct LanguageId: Mappable {
    var id: String!

    init?(map: Map) {}
    mutating func mapping(map: Map) {
        id <- map["id"]
    }
}
