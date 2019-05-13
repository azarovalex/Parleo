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
    }
}

// MARK: - Setup
private extension MyProfileViewController {

    func setup() {
        bindViewModel()
        settingsButton.rx.tap.bind(to: settings).disposed(by: bag)
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
            let firstFiveLanguages = user.languages.prefix(5)
            for language in firstFiveLanguages {
                let flagImageView = UIImageView(image: language.flagImage)
                flagImageView.frame = CGRect(x: 0, y: 0, width: 19, height: 19)
                flagImageView.cornerRadius = 10
                NSLayoutConstraint.activate([
                    NSLayoutConstraint(item: flagImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 19),
                    NSLayoutConstraint(item: flagImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 19)
                ])
                viewController.languagesStackView.addArrangedSubview(flagImageView)
            }
        })
    }

    var settings: Binder<Void> {
        return Binder<Void>(self, binding: { viewController, _ in
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let logOutAction = UIAlertAction(title: "Log Out", style: .destructive, handler: { _ in
                UIApplication.shared.keyWindow?.rootViewController = R.storyboard.onboarding.instantiateInitialViewController()!
                Storage.shared.logout()
            })
            alert.addAction(logOutAction)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            viewController.present(alert, animated: true)
        })
    }
}
