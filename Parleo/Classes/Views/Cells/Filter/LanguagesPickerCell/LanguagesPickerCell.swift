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

    private var updateLayoutAction: (Int) -> Void = { _ in }

    override func awakeFromNib() {
        super.awakeFromNib()

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(addMore))
        addMoreView.addGestureRecognizer(tapRecognizer)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }

    func configure(with model: LanguagePickerModel, updateLayoutAction: @escaping (Int) -> Void) {
        self.updateLayoutAction = updateLayoutAction
        model.languages.forEach { _ in addMore() }
    }

    @objc private func addMore() {
        let view = LanguageInPicker(removeAction: { [weak self] in self?.updateLayoutAction(-1) })
        view.alpha = 0
        updateLayoutAction(+1)
        stackView.insertArrangedSubview(view, at: self.stackView.subviews.count - 1)
        UIView.animate(withDuration: 0.4, animations: { view.alpha = 1 })
    }
}
