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
    private var numberOfLanguages: Int!

    override func sizeForItem(at index: Int) -> CGSize {
        let height = numberOfLanguages * 50 + 140
        return CGSize(width: collectionContext!.containerSize.width, height: CGFloat(height))
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeueReusableCell(withNibName: R.nib.languagesPickerCell.name, bundle: R.nib.languagesPickerCell.bundle, for: self, at: index) as! LanguagesPickerCell
        cell.configure(with: model, updateLayoutAction: { [unowned self] change in
            self.numberOfLanguages += change
            UIView.performWithoutAnimation { self.collectionContext!.invalidateLayout(for: self) }
        })
        return cell
    }

    override func didUpdate(to object: Any) {
        self.model = (object as! LanguagePickerModel)
        numberOfLanguages = model.languages.count
    }
}

