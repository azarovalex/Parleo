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
    private let userService = UserService()

    var userID: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
}

// MARK: - Setup
private extension UserProfileViewController {

    func setup() {
        unwrapResult(userService.getUser(with: userID))
            .bind { user in
                self.userImageView.kf.setImage(with: user.accountImage, placeholder: R.image.avatarTemplate()!)
                self.usernameLabel.text = user.name
                self.aboutLabel.text = user.about ?? "" + "\nHobbies: " + user.hobbies.map { $0.name }.joined(separator: ", ")
                self.title = (user.name != nil ? (user.name! + "'s ") : "") + "Profile"
                let firstFiveLanguages = user.languages.prefix(5)
                for language in firstFiveLanguages {
                    let flagImageView = UIImageView(image: language.flagImage)
                    flagImageView.cornerRadius = 10
                    NSLayoutConstraint.activate([
                        NSLayoutConstraint(item: flagImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 19),
                        NSLayoutConstraint(item: flagImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 19)
                        ])
                    self.languagesStackView.addArrangedSubview(flagImageView)
                }
                DispatchQueue.main.async {
                    self.aboutLabel.text = (user.about ?? "") + "\nHobbies: " + user.hobbies.map { $0.name }.joined(separator: ", ")
                }

                let input = UserProfileViewModel.Input(
                    addFriendButtonTap: self.addFriendButton.rx.tap.asSignal(),
                    initialIsFriendState: user.isFriend ?? false,
                    userId: user.id
                )
                let output = self.viewModel.transform(input: input)

                output.error.emit(to: self.rx.error).disposed(by: self.bag)
                output.isLoading.drive(self.rx.isLoading).disposed(by: self.bag)
                output.friendButtonTitle.drive(self.addFriendButton.rx.title()).disposed(by: self.bag)
        }.disposed(by: bag)
    }
}
