//
//  UserProfileViewController.swift
//  Parleo
//
//  Created by Alex Azarov on 3/25/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import RxSwift
import RxCocoa

class UserProfileViewController: UIViewController {

    @IBOutlet private var userImageView: UIImageView!
    @IBOutlet private var usernameLabel: UILabel!
    @IBOutlet private var languagesStackView: UIStackView!
    @IBOutlet private var aboutLabel: UILabel!
    @IBOutlet private var addFriendButton: UIButton!

    private let viewModel = UserProfileViewModel()
    private let bag = DisposeBag()

    var user: User!

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
}

// MARK: - Setup
private extension UserProfileViewController {

    func setup() {
        bindViewModel()
        userImageView.kf.setImage(with: user.accountImage, placeholder: R.image.avatarTemplate()!)
        usernameLabel.text = user.name
        aboutLabel.text = user.about
        title = (user.name != nil ? (user.name! + "'s ") : "") + "Profile"
        let firstFiveLanguages = user.languages.prefix(5)
        for language in firstFiveLanguages {
            let flagImageView = UIImageView(image: language.flagImage)
            flagImageView.cornerRadius = 10
            NSLayoutConstraint.activate([
                NSLayoutConstraint(item: flagImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 19),
                NSLayoutConstraint(item: flagImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 19)
            ])
            languagesStackView.addArrangedSubview(flagImageView)
        }
    }

    func bindViewModel() {
        let input = UserProfileViewModel.Input(
            addFriendButtonTap: addFriendButton.rx.tap.asSignal(),
            initialIsFriendState: user.isFriend ?? false,
            userId: user.id
        )
        let output = viewModel.transform(input: input)

        output.error.emit(to: rx.error).disposed(by: bag)
        output.isLoading.drive(rx.isLoading).disposed(by: bag)
        output.friendButtonTitle.drive(addFriendButton.rx.title()).disposed(by: bag)
    }
}
