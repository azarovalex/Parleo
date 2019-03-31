//
//  EventTableViewCell.swift
//  Parleo
//
//  Created by Artyom Shaiter on 3/30/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import UIKit
import Kingfisher

class EventTableViewCell: UITableViewCell {
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var languageFlagImageView: UIImageView! {
        didSet {
            languageFlagImageView.layer.cornerRadius = 22
            languageFlagImageView.clipsToBounds = true
        }
    }
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.font = Constants.Font.titleLabel
            titleLabel.textColor = .white
        }
    }
    @IBOutlet var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.font = Constants.Font.descriptionLabel
            descriptionLabel.textColor = .white
        }
    }
    
    var viewModel: EventTableCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            titleLabel.text = viewModel.title
            descriptionLabel.text = viewModel.description
            backgroundImageView.kf.setImage(with: viewModel.backgroungImageUrl)
            languageFlagImageView.image = viewModel.flagImage
        }
    }
}

private extension EventTableViewCell {
    enum Constants {
        enum Font {
            static let titleLabel = R.font.montserratRegular(size: 28)
            static let descriptionLabel = R.font.montserratRegular(size: 11)
        }
    }
}
