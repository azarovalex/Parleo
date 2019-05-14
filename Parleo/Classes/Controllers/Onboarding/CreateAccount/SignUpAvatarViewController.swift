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

    private let pickedImageRelay = BehaviorRelay<UIImage?>(value: nil)
    private let viewModel = SignUpAvatarViewModel()
    private let bag = DisposeBag()

    var initialImageURL: URL?

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
            .do(onNext: { [unowned self] image in
                self.pickedImageRelay.accept(image) })
            .bind(to: addImageButton.rx.image())
            .disposed(by: bag)

        let output = viewModel.transform(
            input: SignUpAvatarViewModel.Input(avatarImage: pickedImageRelay.asDriver(),
                                               nextTap: nextButton.rx.tap.asSignal())
        )
        nextButton.rx.action = output.registerAction
        output.navigate
            .emit(onNext: { _ in
                let tabViewController = R.storyboard.main.instantiateInitialViewController()!
                UIApplication.shared.keyWindow?.rootViewController = tabViewController
            })
            .disposed(by: bag)
        output.errors.emit(to: rx.error).disposed(by: bag)
        output.isLoading.drive(rx.isLoading(onView: view)).disposed(by: bag)
        addImageButton.kf.setImage(with: initialImageURL, for: .normal, placeholder: R.image.addImage()!)
    }
}
