//
//  ItemsListTableCell.swift
//  Parleo
//
//  Created by Artyom Shaiter on 3/4/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import UIKit

class ItemsListTableCell: UITableViewCell {
    // MARK: IBOutlets
    
    @IBOutlet private var itemImageView: UIImageView! {
        didSet {
            itemImageView.contentMode = .scaleAspectFill
            itemTitleLabel.roundAllCornersWithMaximumRadius()
        }
    }
    @IBOutlet private var itemTitleLabel: UILabel! {
        didSet {
            itemTitleLabel.font = Constants.font
            itemTitleLabel.textColor = R.color.black()
        }
    }
    @IBOutlet private var checkboxButton: UIButton! {
        didSet {
            checkboxButton.setImage(R.image.checkboxUnselected(), for: .normal)
            checkboxButton.setImage(R.image.checkboxSelected(), for: .selected)
        }
    }
    
    var viewModel: ItemsListTableCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            itemImageView.image = viewModel.image
            itemTitleLabel.text = viewModel.title
            checkboxButton.isSelected = viewModel.isSelected
        }
    }
    
    
    @IBAction func checkboxClicked(_ sender: UIButton) {
        checkboxButton.isSelected = checkboxButton.isSelected
        viewModel?.isSelected = checkboxButton.isSelected
    }
}

extension ItemsListTableCell {
    enum Constants {
        static let font = R.font.montserratRegular(size: 14)
    }
}
