//
//  Validators.swift
//  Parleo
//
//  Created by Alex Azarov on 4/30/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import Foundation

class Validators {

    static func validate(password: String) -> (result: Bool, error: String?) {
        guard password.rangeOfCharacter(from: CharacterSet.lowercaseLetters) != nil else {
            return (false, "Password should contain at least one lowercase letter")
        }
        guard password.rangeOfCharacter(from: CharacterSet.uppercaseLetters) != nil else {
            return (false, "Password should contain at least one uppercase letter")
        }
        guard password.count >= 8 else {
            return (false, "Password length should be at least 8 characters")
        }
        return (true, nil)
    }

    static func validate(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
}
