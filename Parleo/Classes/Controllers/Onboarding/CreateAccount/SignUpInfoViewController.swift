//
//  SignUpInfoViewController.swift
//  Parleo
//
//  Created by Alex Azarov on 4/2/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import RxSwift
import RxCocoa

class SignUpInfoViewController: UIViewController {

    @IBOutlet private var nameTextField: RoundedTextField!
    @IBOutlet private var birthDateButton: UIButton!
    @IBOutlet private var genderButton: UIButton!
    @IBOutlet private var chooseLanguagesButton: UIButton!

    private let viewModel = SignUpInfoViewModel()
    private let bag = DisposeBag()
    private var user = UserUpdate()

    @IBAction func birthDateTapped(_ sender: Any) {
        DatePickerAlert(font: R.font.montserratRegular(size: 14)!)
            .show("Pick your birth date", datePickerMode: .date) { [weak self] date in
                guard let date = date else { return }
                self?.user.birthdate = date
                self?.birthDateButton.setTitle("Your birth date: " +
                    date.asString(format: "MMM d, yyyy"), for: .normal)
            }
    }

    @IBAction func genderTapped(_ sender: Any) {
        let genderAlert = UIAlertController(title: "Pick your gender", message: nil, preferredStyle: .alert)
        let maleCase = UIAlertAction(title: "Male", style: .default, handler: { [weak self] _ in
            self?.genderButton.setTitle("Your gender: Male", for: .normal)
            self?.user.isMale = true
        })
        let femaleCase = UIAlertAction(title: "Female", style: .default, handler: { [weak self] _ in
            self?.genderButton.setTitle("Your gender: Female", for: .normal)
            self?.user.isMale = false
        })
        genderAlert.addAction(maleCase)
        genderAlert.addAction(femaleCase)
        present(genderAlert, animated: true)
    }

    @IBAction func languageButtonTapped(_ sender: Any) {
        let languagePickerViewController = R.storyboard.languagePicker.instantiateInitialViewController()!
        languagePickerViewController.delegate = self
        languagePickerViewController.setInitial(user.languages)
        navigationController?.present(languagePickerViewController, animated: true)

    }
    @IBAction func nextStep(_ sender: Any) {
        guard nameTextField.text != "" else {
            show(error: SimpleError(message: "Name cann't be empty"))
            return
        }
        user.name = nameTextField.text!
        guard user.isMale != nil else {
            show(error: SimpleError(message: "Pick your gender"))
            return
        }
        guard user.birthdate != nil else {
            show(error: SimpleError(message: "Pick your birthdate"))
            return
        }
        let ageComponents = Calendar.current.dateComponents([.year], from: user.birthdate!, to: Date())
        guard ageComponents.year! >= 16 else {
            show(error: SimpleError(message: "You must be from 16 to 100 years old"))
            return
        }
        guard user.languages.count > 0 else {
            show(error: SimpleError(message: "Pick at least one language"))
            return
        }
        let output = viewModel.updateUser(user: user)
        output.error.emit(to: rx.error).disposed(by: bag)
        output.isLoading.drive(rx.isLoading).disposed(by: bag)
        output.navigate.emit(onNext: {
            self.performSegue(withIdentifier: R.segue.signUpInfoViewController.fromResistrationInfoToAvatar, sender: nil)
        }).disposed(by: bag)
    }
}

extension SignUpInfoViewController: LanguagePickerDelegate {

    func updateSelectedLanguages(with languages: [Language]) {
        user.languages = languages
        let buttonTitle = languages.count == 0 ? "Choose languages" :
            ("Your languages: " + languages.map { $0.name }.joined(separator: ", "))
        chooseLanguagesButton.setTitle(buttonTitle, for: .normal)
    }
}
