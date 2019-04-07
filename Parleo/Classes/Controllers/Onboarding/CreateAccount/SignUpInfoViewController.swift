//
//  SignUpInfoViewController.swift
//  Parleo
//
//  Created by Alex Azarov on 4/2/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import UIKit

class SignUpInfoViewController: UIViewController {

    private var credentials: (email: String, password: String)!

    func setCredentials(credentials: (email: String, password: String)) {
        self.credentials = credentials
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        guard let viewController = segue.destination as? SignUpAvatarViewController else { return }
        viewController.credentials = credentials
    }
}
