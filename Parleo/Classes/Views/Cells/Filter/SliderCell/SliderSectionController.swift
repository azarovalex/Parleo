//
//  SliderSectionController.swift
//  Parleo
//
//  Created by Alex Azarov on 3/30/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import IGListKit

class SliderSectionController: ListSectionController {

    private var model: SliderCellModel!

    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 124)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeueReusableCell(withNibName: R.nib.sliderCell.name, bundle: R.nib.sliderCell.bundle, for: self, at: index) as! SliderCell
        cell.configure(with: model)
        return cell
    }

    override func didUpdate(to object: Any) {
        self.model = (object as! SliderCellModel)
    }
}
