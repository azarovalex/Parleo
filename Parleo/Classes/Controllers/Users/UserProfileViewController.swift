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
        userImageView.kf.setImage(with: user.accountImage)
        usernameLabel.text = user.name
        aboutLabel.text = user.about
    }
}
