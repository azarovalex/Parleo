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

    private init() { }

    static var shared = Storage()

    var currentUser: User?
}
