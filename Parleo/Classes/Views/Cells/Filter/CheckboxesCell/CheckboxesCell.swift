//
//  CheckboxesCell.swift
//  Parleo
//
//  Created by Alex Azarov on 3/23/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import UIKit

struct CheckboxCellModel {
    let title: String
    let items: [String]
}

class CheckboxesCell: UITableViewCell {

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var itemsStackView: UIStackView!

    func configure(with model: CheckboxCellModel) {
        titleLabel.text = model.title
        for item in model.items {
            itemsStackView.addArrangedSubview(CheckboxView(title: item))
        }
    }
}
