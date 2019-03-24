//
//  BaseTabBarController.swift
//  Parleo
//
//  Created by Alex Azarov on 3/13/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
}

// MARK: - Setup
private extension BaseTabBarController {

    func setup() {
        tabBar.backgroundImage = UIImage()
        tabBar.tintColor = #colorLiteral(red: 0.3215686275, green: 0.3921568627, blue: 1, alpha: 1)
//        tabBar.shadowImage = UIImage()
        tabBar.backgroundColor = .white
    }
}
