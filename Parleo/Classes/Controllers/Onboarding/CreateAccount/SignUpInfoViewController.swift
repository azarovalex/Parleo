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
    @IBOutlet private var chooseLanguagesButton: UIButton!

    private var credentials: (email: String, password: String)!
    private var currentSelectedLanguages = [Language]()

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
                self?.birthDateButton.setTitle("Your birth date: " +
                    date.asString(format: "MMM d, yyyy"), for: .normal)
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

    @IBAction func languageButtonTapped(_ sender: Any) {
        let languagePickerViewController = R.storyboard.languagePicker.instantiateInitialViewController()!
        languagePickerViewController.delegate = self
        languagePickerViewController.setInitial(currentSelectedLanguages)
        navigationController?.present(languagePickerViewController, animated: true)

    }
}

extension SignUpInfoViewController: LanguagePickerDelegate {

    func updateSelectedLanguages(with languages: [Language]) {
        currentSelectedLanguages = languages
        let buttonTitle = languages.count == 0 ? "Choose languages" :
            ("Your languages: " + languages.map { $0.name }.joined(separator: ", "))
        chooseLanguagesButton.setTitle(buttonTitle, for: .normal)
    }
}
