//
//  CheckboxesCell.swift
//  Parleo
//
//  Created by Alex Azarov on 3/30/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import UIKit
import IGListKit

class CheckboxCellModel: ListDiffable {

    let title: String
    let items: [String]

    init(title: String, items: [String]) {
        self.title = title
        self.items = items
    }

    // MARK: ListDiffable

    func diffIdentifier() -> NSObjectProtocol {
        return title as NSObjectProtocol
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard self !== object else { return true }
        guard let object = object as? CheckboxCellModel else { return false }
        return title == object.title
    }
}

class CheckboxesCell: UICollectionViewCell {

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var itemsStackView: UIStackView!

    override func prepareForReuse() {
        super.prepareForReuse()
        itemsStackView.subviews.forEach { $0.removeFromSuperview() }
    }

    func configure(with model: CheckboxCellModel) {
        titleLabel.text = model.title
        for item in model.items {
            itemsStackView.addArrangedSubview(CheckboxView(title: item))
        }
    }
}
