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

        navigationController?.navigationBar.barStyle = .black
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.navigationBar.barStyle = .default
    }
}
