//
//  LanguagesPickerCell.swift
//  Parleo
//
//  Created by Alex Azarov on 3/29/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import UIKit
import IGListKit

class LanguagePickerModel: ListDiffable {

    var languages: [String]

    init(languages: [String]) {
        self.languages = languages
    }

    func diffIdentifier() -> NSObjectProtocol {
        return languages as NSObjectProtocol
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard self !== object else { return true }
        guard let object = object as? LanguagePickerModel else { return false }
        return languages == object.languages
    }
}

class LanguagesPickerCell: UICollectionViewCell {

    @IBOutlet private var stackView: UIStackView!
    @IBOutlet private var addMoreView: UIView!

    private var updateLayoutAction: () -> Void = { }

    override func awakeFromNib() {
        super.awakeFromNib()

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(addMore))
        addMoreView.addGestureRecognizer(tapRecognizer)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }

    func configure(with model: LanguagePickerModel, updateLayoutAction: @escaping () -> Void) {
        model.languages.forEach { _ in
            stackView.insertArrangedSubview(LanguageInPicker(), at: stackView.arrangedSubviews.count - 1) }
        self.updateLayoutAction = updateLayoutAction
    }

    @objc private func addMore() {
        stackView.insertArrangedSubview(LanguageInPicker(), at: self.stackView.subviews.count - 1)
        updateLayoutAction()
    }
}
