//
//  AppError.swift
//  Parleo
//
//  Created by Alex Azarov on 3/5/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import Foundation

protocol AppError: Error {
    var message: String { get }
    init(message: String)
}

struct EmptyError: Error {}
