//
//  LanguagePickerSectionController.swift
//  Parleo
//
//  Created by Alex Azarov on 3/30/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import IGListKit

class LanguagePickerSectionController: ListSectionController {

    private var model: LanguagePickerModel!

    var updateClosure: (([Language]) -> Void)!
    var filter: UsersFilter! {
        didSet {
            model = LanguagePickerModel(languages: filter!.languages.map { $0.code })
        }
    }

    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 140.0)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeueReusableCell(withNibName: R.nib.languagesPickerCell.name, bundle: R.nib.languagesPickerCell.bundle, for: self, at: index) as! LanguagesPickerCell
        cell.configure(with: model, updateClosure: updateClosure)
        return cell
    }

    override func didUpdate(to object: Any) {}
}
