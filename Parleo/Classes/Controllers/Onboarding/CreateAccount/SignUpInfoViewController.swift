//
//  SignUpInfoViewController.swift
//  Parleo
//
//  Created by Alex Azarov on 4/2/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import UIKit

class SignUpInfoViewController: UIViewController {

    @IBOutlet private var birthDateButton: UIButton!
    @IBOutlet private var genderButton: UIButton!

    private var credentials: (email: String, password: String)!

    func setCredentials(credentials: (email: String, password: String)) {
        self.credentials = credentials
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        guard let viewController = segue.destination as? SignUpAvatarViewController else { return }
        viewController.credentials = credentials
    }

    @IBAction func birthDateTapped(_ sender: Any) {
        DatePickerAlert(font: R.font.montserratRegular(size: 14)!)
            .show("Pick your birth date", datePickerMode: .date) { [weak self] date in
                guard let date = date else { return }
                self?.birthDateButton.setTitle("Birth date: \(date)", for: .normal)
            }
    }

    @IBAction func genderTapped(_ sender: Any) {
        let genderAlert = UIAlertController(title: "Pick your gender", message: nil, preferredStyle: .alert)
        let maleCase = UIAlertAction(title: "Male", style: .default, handler: { [weak self] _ in
            self?.genderButton.setTitle("Your gender: Male", for: .normal)
        })
        let femaleCase = UIAlertAction(title: "Female", style: .default, handler: { [weak self] _ in
            self?.genderButton.setTitle("Your gender: Female", for: .normal)
        })
        genderAlert.addAction(maleCase)
        genderAlert.addAction(femaleCase)
        present(genderAlert, animated: true)
    }
}
