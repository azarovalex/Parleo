//
//  LanguageNameManager.swift
//  Parleo
//
//  Created by Alex Azarov on 5/9/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import Foundation

class LanguageNameManager {

    private let languagesMap: Dictionary<String, Dictionary<String, String>>

    static let shared = LanguageNameManager()

    init() {
        guard let path = Bundle.main.path(forResource: "languages", ofType: "json") else { fatalError() }
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        languagesMap = try! JSONSerialization.jsonObject(with: data) as! Dictionary<String, Dictionary<String, String>>
    }

    func getLanguageName(for isoCode: String) -> String? {
        return languagesMap[isoCode]?["name"]
    }

}
