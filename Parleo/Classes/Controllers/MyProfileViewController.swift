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
    }
}

// MARK: - Private
private extension MyProfileViewController {

    var user: Binder<User> {
        return Binder(self, binding: { viewController, user in
            
        })
    }
}
