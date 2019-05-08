//
//  SignUpAvatarViewController.swift
//  Parleo
//
//  Created by Alex Azarov on 4/2/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import RxSwift
import RxCocoa

class SignUpAvatarViewController: UIViewController {

    @IBOutlet private var addImageButton: UIButton!
    @IBOutlet private var nextButton: RoundedButton!

    var credentials: (email: String, password: String)!

    private let viewModel = SignUpViewModel()
    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad() 

        setup()
    }
}

// MARK: - Setup
private extension SignUpAvatarViewController {

    func setup() {
        addImageButton.rx.tap
            .flatMap { [unowned self] in
                self.rx.pickImage(title: "Add avatar Image", allowsEditing: true) }
            .do(onNext: { [unowned self] _ in
                self.nextButton.isEnabled = true
                self.nextButton.alpha = 1 })
            .bind(to: addImageButton.rx.image())
            .disposed(by: bag)

        let output = viewModel.transform(input: SignUpViewModel.Input(credentials: credentials))
        nextButton.rx.action = output.registerAction
        output.navigate
            .emit(onNext: { [unowned self] _ in
                self.navigationController?.popToRootViewController(animated: true) })
            .disposed(by: bag)
        output.errors.emit(to: rx.error).disposed(by: bag)
        output.isLoading.drive(rx.isLoading(onView: view)).disposed(by: bag)
    }
}
