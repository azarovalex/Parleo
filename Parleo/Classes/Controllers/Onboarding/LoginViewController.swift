//
//  LoginViewController.swift
//  Parleo
//
//  Created by Alex Azarov on 2/24/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import RxSwift
import RxCocoa
import SegueManager

class LoginViewController: SegueManagerViewController {

    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet private var loginButton: RoundedButton!

    private let viewModel = LoginViewModel()
    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
}

// MARK: - Setup
private extension LoginViewController {

    func setup() {
        bindViewModel()
    }

    func bindViewModel() {
        let input = LoginViewModel.Input(email: emailTextField.rx.text.orEmpty.asDriver(),
                                         password: passwordTextField.rx.text.orEmpty.asDriver(),
                                         loginButtonTap: loginButton.rx.tap.asSignal())
        let output = viewModel.transform(input: input)

        loginButton.rx.action = output.loginAction
        output.error.emit(to: rx.error).disposed(by: bag)
        output.isLoading.drive(rx.isLoading).disposed(by: bag)
        output.loginAction.enabled
            .map { $0 ? 1 : 0.7 }
            .bind(to: loginButton.rx.alpha)
            .disposed(by: bag)
        output.loggedIn
            .emit(onNext: { UIApplication.shared.keyWindow?.rootViewController = R.storyboard.main.instantiateInitialViewController()!
            }).disposed(by: bag)
    }
}
