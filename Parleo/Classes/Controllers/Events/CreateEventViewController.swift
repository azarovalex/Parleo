//
//  CreateEventViewController.swift
//  Parleo
//
//  Created by Alex Azarov on 4/2/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import RxCocoa
import RxSwift

class CreateEventViewController: UIViewController {
    @IBOutlet private var imageButton: UIButton!
    @IBOutlet private var eventNameTextField: RoundedTextField!
    @IBOutlet private var eventDescriptionTextView: UITextView!
    @IBOutlet private var inviteFriendsButton: UIButton!
    @IBOutlet private var setDateButton: UIButton!
    @IBOutlet private var addLanguageButton: UIButton!
    
    
    

    private let bag = DisposeBag()
    private let pickedImageRelay = BehaviorRelay<UIImage?>(value: nil)
    private let viewModel = CreateEventViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        bindData()
    }
}


// MARK: - Setup
private extension CreateEventViewController {
    func bindData() {
        imageButton.rx.tap
            .flatMap { [unowned self] in
                self.rx.pickImage(title: "Add event Image", allowsEditing: true) }
            .do(onNext: { [unowned self] image in
                self.pickedImageRelay.accept(image)
            })
            .bind(to: imageButton.rx.image())
            .disposed(by: bag)
        
        let titleObservable = eventNameTextField.rx.text.asObservable()
        let descriptionObservable = eventDescriptionTextView.rx.text.asObservable()
        let buttonClicked = setDateButton
        
        let output = viewModel.transform(input: CreateEventViewModel.Input(imageRelay: pickedImageRelay,
                                                                           titleObservable: titleObservable,
                                                                           descriptionObservable: descriptionObservable))
    }

    func setup() {
        eventDescriptionTextView.textContainerInset = UIEdgeInsets(top: 13, left: 20, bottom: 13, right: 20)
    }
}
