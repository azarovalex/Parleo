//
//  ParticipantCollectionViewCell.swift
//  Parleo
//
//  Created by Artyom Shaiter on 5/15/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import UIKit

class ParticipantCollectionViewCell: UICollectionViewCell {
    @IBOutlet private var imageView: UIImageView! {
        didSet {
            imageView.cornerRadius = 22
            imageView.contentMode = .scaleAspectFill
        }
    }
    
    var image: UIImage? {
        set {
            imageView.image = newValue
        }
        get {
            return imageView.image
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
