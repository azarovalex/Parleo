//
//  SliderCell.swift
//  Parleo
//
//  Created by Alex Azarov on 3/24/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import UIKit

struct SliderCellModel {
    let title: String
    let minValue: Double
    let maxValue: Double
    let step: Double
}

class SliderCell: UITableViewCell {

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var rangeSlider: RangeSlider!

    func configure(with model: SliderCellModel) {
        titleLabel.text = model.title
        rangeSlider.minValue = CGFloat(model.minValue)
        rangeSlider.maxValue = CGFloat(model.maxValue)
        rangeSlider.step = CGFloat(model.step)
    }
}
