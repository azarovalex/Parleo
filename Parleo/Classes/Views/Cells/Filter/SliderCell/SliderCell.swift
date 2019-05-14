//
//  SliderCell.swift
//  Parleo
//
//  Created by Alex Azarov on 3/24/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import IGListKit

class SliderCellModel: ListDiffable {

    let title: String
    let minValue: Double
    let maxValue: Double
    let step: Double

    init(title: String, minValue: Double, maxValue: Double, step: Double) {
        self.title = title
        self.minValue = minValue
        self.maxValue = maxValue
        self.step = step
    }

    // MARK: ListDiffable

    func diffIdentifier() -> NSObjectProtocol {
        return title as NSObjectProtocol
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard self !== object else { return true }
        guard let object = object as? SliderCellModel else { return false }
        return title == object.title
    }
}

class SliderCell: UICollectionViewCell {

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var rangeSlider: RangeSlider!

    var updateClosure: ((_ minAge: Int, _ maxAge: Int) -> Void)!

    func configure(with model: SliderCellModel, updateClosure: @escaping (_ minAge: Int, _ maxAge: Int) -> Void, filter: UsersFilter) {
        self.updateClosure = updateClosure
        titleLabel.text = model.title
        rangeSlider.minValue = CGFloat(model.minValue)
        rangeSlider.maxValue = CGFloat(model.maxValue)
        rangeSlider.selectedMinValue = CGFloat(filter.minAge)
        rangeSlider.selectedMaxValue = CGFloat(filter.maxAge)
        rangeSlider.step = CGFloat(model.step)
    }
    
    @IBAction func sliderChanged(_ sender: Any) {
        updateClosure(Int(rangeSlider.selectedMinValue), Int(rangeSlider.selectedMaxValue))
    }
}
