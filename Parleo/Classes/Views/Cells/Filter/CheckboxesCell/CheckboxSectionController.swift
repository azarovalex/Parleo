//
//  CheckboxSectionController.swift
//  Parleo
//
//  Created by Alex Azarov on 3/30/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import IGListKit

class CheckboxSectionController: ListSectionController {

    private var model: CheckboxCellModel!
    var updateClosure: ((_ isMale: Bool, _ isFemale: Bool) -> Void)!
    var filter: UsersFilter!

    override func sizeForItem(at index: Int) -> CGSize {
        let height = 70 + model.items.count * 34
        return CGSize(width: collectionContext!.containerSize.width, height: CGFloat(height))
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeueReusableCell(withNibName: R.nib.checkboxesCell.name,
                                                          bundle: R.nib.checkboxesCell.bundle, for: self, at: index) as! CheckboxesCell
        cell.configure(with: model, updateClosure: updateClosure, filter: filter)
        return cell
    }

    override func didUpdate(to object: Any) {
        self.model = (object as! CheckboxCellModel)
    }
}
