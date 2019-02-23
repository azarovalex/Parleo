//
//  StartupViewController.swift
//  Parleo
//
//  Created by Alex Azarov on 2/23/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import UIKit

class StartupViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setNeedsStatusBarAppearanceUpdate()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
