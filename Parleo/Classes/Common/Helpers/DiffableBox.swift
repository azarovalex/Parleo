//
//  DiffableBox.swift
//  Parleo
//
//  Created by Alex Azarov on 3/30/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import IGListKit

class DiffableBox<T: Diffable>: ListDiffable {

    let value: T

    init(value: T) {
        self.value = value
    }

    func diffIdentifier() -> NSObjectProtocol {
        return value.diffIdentifier as NSObjectProtocol
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let other = object as? DiffableBox<T> else { return false }
        return value == other.value
    }
}

protocol Diffable: Equatable {

    var diffIdentifier: String { get }
}
