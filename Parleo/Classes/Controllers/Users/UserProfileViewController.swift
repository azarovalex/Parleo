//
//  UserProfileViewController.swift
//  Parleo
//
//  Created by Alex Azarov on 3/25/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {

    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var languagesStackView: UIStackView!
    @IBOutlet var aboutLabel: UILabel!

    var user: User!

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
}

// MARK: - Setup
private extension UserProfileViewController {

    func setup() {
        userImageView.kf.setImage(with: user.accountImage, placeholder: R.image.avatarTemplate()!)
        usernameLabel.text = user.name
        aboutLabel.text = user.about
        let firstFiveLanguages = user.languages.prefix(5)
        for language in firstFiveLanguages {
            let flagImageView = UIImageView(image: language.flagImage)
            flagImageView.cornerRadius = 10
            NSLayoutConstraint.activate([
                NSLayoutConstraint(item: flagImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 19),
                NSLayoutConstraint(item: flagImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 19)
            ])
            languagesStackView.addArrangedSubview(flagImageView)
        }
    }
}
