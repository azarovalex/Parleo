//
//  ItemsListTableCellViewModel.swift
//  Parleo
//
//  Created by Artyom Shaiter on 3/4/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import UIKit

class ItemsListTableCellViewModel {
    let title: String
    let image: UIImage
    var isSelected: Bool
    
    init(title: String, image: UIImage, isSelected: Bool) {
        self.title = title
        self.image = image
        self.isSelected = isSelected
    }
}
