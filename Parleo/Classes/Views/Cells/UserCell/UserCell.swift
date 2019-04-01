//
//  UserCell.swift
//  Parleo
//
//  Created by Alex Azarov on 3/18/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet private var shadowView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        setup()
    }
}

// MARK: - Setup
private extension UserCell {

    func setup() {
        shadowView.layer.cornerRadius = 7
        shadowView.clipsToBounds = true

        self.shadowView.layer.shadowPath = UIBezierPath(roundedRect: shadowView.bounds,
                         cornerRadius: shadowView.layer.cornerRadius).cgPath
        self.shadowView.layer.shadowColor = UIColor.black.cgColor
        self.shadowView.layer.shadowOpacity = 0.15
        self.shadowView.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.shadowView.layer.shadowRadius = 5
        self.shadowView.layer.masksToBounds = false
    }
}

