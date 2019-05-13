//
//  LanguageInPickerCell.swift
//  Parleo
//
//  Created by Alex Azarov on 5/8/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import UIKit

class LanguageInPickerCell: UITableViewCell {

    @IBOutlet private var flagImageView: UIImageView!
    @IBOutlet private var languageNameLabel: UILabel!
    @IBOutlet private var languageLevelLabel: UILabel!
    @IBOutlet private var checkboxImageView: UIImageView!
    @IBOutlet private var languageLevelView: UIView!
    @IBOutlet private var levelSlider: RangeSlider!

    private var isChecked: Bool = false
    private var language: Language!
    private var currentLevel: LanguageLevel = .beginner

    private var stateChangedClosure: (Language, LanguageLevel?) -> Void = { _, _ in }

    override func prepareForReuse() {
        super.prepareForReuse()

        levelSlider.selectedMaxValue = 1.0
        levelSlider.updateHandlePositions()
        languageLevelView.isHidden = true
        isChecked = false
        updateUI()
    }

    @IBAction func selectionChanged(_ sender: Any) {
        isChecked.toggle()
        updateUI()
        let tableView = superview as! UITableView
        tableView.beginUpdates()
        tableView.endUpdates()

        stateChangedClosure(language, isChecked ? currentLevel : nil)
    }

    @IBAction func levelSliderDidChange(_ sender: Any) {
        currentLevel = LanguageLevel(rawValue: Int(levelSlider.selectedMaxValue))!
        languageLevelLabel.text = currentLevel.description
        stateChangedClosure(language, currentLevel)
    }

    func configure(with language: Language, isSelected: Bool,
                   stateChangedClosure: @escaping (Language, LanguageLevel?) -> Void) {
        self.language = language
        flagImageView.image = language.flagImage
        languageNameLabel.text = language.name

        self.stateChangedClosure = stateChangedClosure
        languageLevelLabel.text = (isSelected ? language.level : LanguageLevel.beginner).description

        guard isSelected else { return }
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        levelSlider.selectedMaxValue = CGFloat(language.level.rawValue)
        levelSlider.updateHandlePositions()
        CATransaction.commit()
        isChecked = isSelected
        updateUI()
    }

    private func updateUI() {
        languageLevelView.isHidden = !isChecked
        checkboxImageView.image = isChecked ? R.image.checkbox_on()! : R.image.checkbox_off()!
    }
}
