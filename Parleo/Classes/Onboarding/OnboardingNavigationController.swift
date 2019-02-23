//
//  OnboardingNavigationController.swift
//  Parleo
//
//  Created by Alex Azarov on 2/23/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import UIKit

class OnboardingNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.setBackgroundImage(UIImage(), for: .default)
//        navigationBar.shadowImage = UIImage()
    }
}
