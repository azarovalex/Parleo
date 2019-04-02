//
//  CreateEventViewController.swift
//  Parleo
//
//  Created by Alex Azarov on 4/2/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import UIKit

class CreateEventViewController: UIViewController {

    @IBOutlet private var eventNameTextField: RoundedTextField!
    @IBOutlet private var eventDescriptionTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
}


// MARK: - Setup
private extension CreateEventViewController {

    func setup() {
        eventDescriptionTextView.textContainerInset = UIEdgeInsets(top: 13, left: 20, bottom: 13, right: 20)
    }
}
