//
//  Storage.swift
//  Parleo
//
//  Created by Alex Azarov on 3/10/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import Foundation
import Moya

protocol StorageType { }

class Storage {

    static var shared = Storage()

    private init() { }

    var accessToken: String?
}
