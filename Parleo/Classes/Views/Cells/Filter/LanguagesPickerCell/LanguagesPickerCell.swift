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
    @IBOutlet private var languagesLabel: UILabel!

    private var updateClosure: ([Language]) -> Void = { _ in }
    private var languages = [Language]()

    override func awakeFromNib() {
        super.awakeFromNib()

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectLanguages))
        addMoreView.addGestureRecognizer(tapRecognizer)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }

    func configure(with model: LanguagePickerModel, updateClosure: @escaping ([Language]) -> Void) {
        languages = model.languages.map { Language(code: $0, level: .beginner) }
        self.updateClosure = updateClosure
        setLabelText(for: languages)
    }

    @objc private func selectLanguages() {
        let languagesPickerViewController = R.storyboard.languagePicker.instantiateInitialViewController()!
        languagesPickerViewController.setInitial(languages)
        languagesPickerViewController.delegate = self
        UIApplication.shared.keyWindow?.rootViewController?.present(languagesPickerViewController, animated: true)
    }

    private func setLabelText(for languages: [Language]) {
        languagesLabel.text = languages.count > 0 ? "Selected: " + languages.map { $0.name }.joined(separator: ", ") : "Choose your languages"
    }
}

extension LanguagesPickerCell: LanguagePickerDelegate {

    func updateSelectedLanguages(with languages: [Language]) {
        self.languages = languages
        updateClosure(languages)
        setLabelText(for: languages)
    }
}
