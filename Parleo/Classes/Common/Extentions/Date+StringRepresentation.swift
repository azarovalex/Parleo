//
//  Date+StringRepresentation.swift
//  Parleo
//
//  Created by Alex Azarov on 5/12/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import Foundation

extension Date {

    func asString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

