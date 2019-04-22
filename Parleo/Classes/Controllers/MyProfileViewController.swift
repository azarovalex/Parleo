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

    override func viewDidLoad() {
        super.viewDidLoad()

        settingsButton.rx.tap.bind {
            UIApplication.shared.keyWindow?.rootViewController = R.storyboard.onboarding.instantiateInitialViewController()!
        }.disposed(by: bag)
    }

}
