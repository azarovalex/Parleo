//
//  ListOfChatsSectionController.swift
//  Parleo
//
//  Created by Alex Azarov on 3/30/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import IGListKit

class ListOfChatsSectionController: ListSectionController {

    private var model: ListOfChatsCellModel!

    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 110)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeueReusableCell(withNibName: R.nib.listOfChatsCell.name, bundle: R.nib.listOfChatsCell.bundle, for: self, at: index) as! ListOfChatsCell
        cell.configure(with: model)
        return cell
    }

    override func didUpdate(to object: Any) {
        self.model = (object as! ListOfChatsCellModel)
    }
}
