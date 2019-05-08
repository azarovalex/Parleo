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

    private let viewModel = SignUpCredentialsViewModel()
    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
}

// MARK: - Setup
private extension SignUpCredentialsViewController {

    func setup() {
        let input = SignUpCredentialsViewModel.Input(email: emailTextField.textDriver,
                                                     password: passwordTextField.textDriver,
                                                     repeatedPassword: repeatPasswordTextField.textDriver)

        let output = viewModel.transform(input: input)

        nextButton.rx.action = output.registerAction
        output.registerAction.enabled.map { $0 ? 1 : 0.7 }
            .bind(to: nextButton.rx.alpha).disposed(by: bag)

        output.isLoading.drive(rx.isLoading).disposed(by: bag)
        output.error.emit(to: rx.error).disposed(by: bag)
        output.registered.emit(to: registered).disposed(by: bag)
    }
}

// MARK: - Private
private extension SignUpCredentialsViewController {

    var registered: Binder<Void> {
        return Binder(self, binding: { viewController, _ in
            let alert = UIAlertController(title: "Successful registration", message: "Check your email for a verification link", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
                viewController.navigationController?.popViewController(animated: true)
            })
            alert.addAction(okAction)
            viewController.present(alert, animated: true)
        })
    }
}
