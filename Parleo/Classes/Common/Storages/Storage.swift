//
//  Storage.swift
//  Parleo
//
//  Created by Alex Azarov on 3/10/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import Foundation
import Moya
import KeychainSwift

class Storage {

    static var shared = Storage()

    private let keychain = KeychainSwift()
    private let keychainTokenKey = "accessToken"

    private init() { }

    var isLoggedIn: Bool {
        return accessToken != nil
    }

    var accessToken: String? {
        set {
            if let token = newValue {
                keychain.set(token, forKey: keychainTokenKey)
            } else {
                keychain.delete(keychainTokenKey)
            }
        }
        get { return keychain.get(keychainTokenKey) }
    }

    func logout() {
        accessToken = nil
    }
}
