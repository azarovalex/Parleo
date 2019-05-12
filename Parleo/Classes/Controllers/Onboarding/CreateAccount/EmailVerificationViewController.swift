//
//  EmailVerificationViewController.swift
//  Parleo
//
//  Created by Alex Azarov on 5/7/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import RxSwift
import RxCocoa
import PKHUD

class EmailVerificationViewController: UIViewController {

    @IBOutlet private var verifyButton: RoundedButton!

    private let viewModel = EmailVerificationViewModel()
    private let bag = DisposeBag()

    var emailVerificationToken: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

// MARK: - Setup
private extension EmailVerificationViewController {

    func setup() {
        bindViewModel()
    }

    func bindViewModel() {
        let input = EmailVerificationViewModel.Input(token: emailVerificationToken)
        let output = viewModel.transform(input: input)

        verifyButton.rx.action = output.verifyEmailAction
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: { self.verifyButton.rx.action?.execute() })
        output.error.emit(to: rx.error).disposed(by: bag)
        output.error.map { _ in false }.emit(to: verifyButton.rx.isHidden).disposed(by: bag)
        output.isLoading
            .drive(onNext: { $0 ? HUD.show(.label("Verifying your email...")) : HUD.hide() })
            .disposed(by: bag)
        output.navigation.emit(onNext: { [weak self] in
            self?.performSegue(withIdentifier: R.segue.emailVerificationViewController
                .fromEmailVerificationToCreateAccount, sender: nil)
        }).disposed(by: bag)
    }
}
