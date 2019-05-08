//
//  MyProfileViewController.swift
//  Parleo
//
//  Created by Alex Azarov on 4/2/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import RxSwift
import RxCocoa

class MyProfileViewController: UIViewController {

    @IBOutlet private var settingsButton: UIBarButtonItem!
    @IBOutlet private var profileImageView: UIImageView!
    @IBOutlet private var usernameLabel: UILabel!
    @IBOutlet private var languagesStackView: UIStackView!
    @IBOutlet private var aboutLabel: UILabel!

    private let bag = DisposeBag()
    private let viewModel = MyProfileViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        settingsButton.rx.tap.bind {
            UIApplication.shared.keyWindow?.rootViewController = R.storyboard.onboarding.instantiateInitialViewController()!
        }.disposed(by: bag)
    }
}

// MARK: - Setup
private extension MyProfileViewController {

    func setup() {
        bindViewModel()
    }

    func bindViewModel() {
        let input = MyProfileViewModel.Input(viewWillAppear: rx.viewWillAppear.asSignal().map { _ in })
        let output = viewModel.transform(input: input)

        output.user.emit(to: user).disposed(by: bag)
        output.isLoading.drive(rx.isLoading).disposed(by: bag)
        output.error.emit(to: rx.error).disposed(by: bag)
    }
}

// MARK: - Private
private extension MyProfileViewController {

    var user: Binder<User> {
        return Binder(self, binding: { viewController, user in
            viewController.profileImageView.kf.setImage(with: user.accountImage, placeholder: R.image.avatarTemplate()!)
            viewController.usernameLabel.text = user.name
            viewController.aboutLabel.text = user.about
        })
    }
}
