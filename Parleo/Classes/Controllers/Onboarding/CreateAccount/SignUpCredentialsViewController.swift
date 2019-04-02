//
//  SignUpCredentialsViewController.swift
//  Parleo
//
//  Created by Alex Azarov on 4/2/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import RxSwift
import RxCocoa
import SegueManager

class SignUpCredentialsViewController: SegueManagerViewController {

    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet private var repeatPasswordTextField: UITextField!
    @IBOutlet private var nextButton: UIButton!

    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
}

// MARK: - Setup
private extension SignUpCredentialsViewController {

    func setup() {
        let credentials = Driver.combineLatest(emailTextField.rx.text.orEmpty.asDriver().distinctUntilChanged(),
                                               passwordTextField.rx.text.orEmpty.asDriver().distinctUntilChanged(),
                                               repeatPasswordTextField.rx.text.orEmpty.asDriver().distinctUntilChanged())

        credentials.map { !$0.isEmpty && !$1.isEmpty && !$2.isEmpty}
            .drive(nextButton.rx.isEnabled)
            .disposed(by: bag)

        nextButton.rx.tap.asSignal()
            .withLatestFrom(credentials)
            .filter { $1 != $2 }
            .map { _ in SimpleError(message: "Passwords are not equal!") }
            .emit(to: rx.error)
            .disposed(by: bag)


        nextButton.rx.tap.asSignal()
            .withLatestFrom(credentials)
            .filter { $0.1 == $0.2 }
            .map { (email: $0.0, password: $0.1) }
            .emit(to: rx.navigate(with: R.segue.signUpCredentialsViewController.fromCredentialsToInfo,
                                  segueHandler: { (segue, credentials) in segue.destination.setCredentials(credentials: credentials) }))
            .disposed(by: bag)
    }
}
