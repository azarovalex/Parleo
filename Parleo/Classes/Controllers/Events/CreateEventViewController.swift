//
//  CreateEventViewController.swift
//  Parleo
//
//  Created by Alex Azarov on 4/2/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import RxCocoa
import RxSwift
import MapKit

class CreateEventViewController: UIViewController {
    @IBOutlet private var imageButton: UIButton!
    @IBOutlet private var eventNameTextField: RoundedTextField!
    @IBOutlet private var eventDescriptionTextView: UITextView!
    @IBOutlet private var inviteFriendsButton: UIButton!
    @IBOutlet private var setDateButton: UIButton!
    @IBOutlet private var addLanguageButton: UIButton!
    @IBOutlet private var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
            mapView.addAnnotation(centerAnnotation)
        }
    }
    @IBOutlet private var saveButton: UIBarButtonItem!
    
    private let centerAnnotation = MKPointAnnotation()
    
    private let bag = DisposeBag()
    private let viewModel = CreateEventViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        bindData()
    }
    
    @IBAction func saveButtonClicked(_ sender: UIBarButtonItem) {
        viewModel.saveButtonClicked()
    }
}


// MARK: - Setup
private extension CreateEventViewController {
    func bindData() {
        imageButton.rx.tap
            .flatMap { [unowned self] in
                self.rx.pickImage(title: "Add event Image", allowsEditing: true) }
            .do(onNext: { [weak self] image in
                self?.imageButton.imageView?.contentMode = .scaleAspectFill
                self?.viewModel.eventImage.accept(image)
            })
            .bind(to: imageButton.rx.image())
            .disposed(by: bag)
        
        eventNameTextField.rx.text.asObservable().bind(to: viewModel.title).disposed(by: bag)
        eventDescriptionTextView.rx.text.asObservable().bind(to: viewModel.description).disposed(by: bag)
        
        setDateButton.rx.tap
            .bind(onNext: { [weak self] in
                let currentDate = Date()
                let minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)
                let maximumDate = Calendar.current.date(byAdding: .month, value: 2, to: currentDate)
                DatePickerAlert(font: R.font.montserratRegular(size: 14)!)
                    .show("Pick events start date",
                          minimumDate: minimumDate,
                          maximumDate: maximumDate,
                          datePickerMode: .dateAndTime) { [weak self] date in
                        guard let date = date else { return }
                        self?.viewModel.startDate.accept(date)
                        self?.setDateButton.setTitle(date.asString(format: "MMM d, yyyy: H m"), for: .normal)
                    }
            })
            .disposed(by: bag)
        
        addLanguageButton.rx.tap
            .bind(onNext: { [weak self] in
                let languagePickerViewController = R.storyboard.languagePicker.instantiateInitialViewController()!
                languagePickerViewController.delegate = self
                languagePickerViewController.setInitial(self?.viewModel.languages.value ?? [])
                self?.navigationController?.present(languagePickerViewController, animated: true)
            })
            .disposed(by: bag)
        
        viewModel.location
            .asDriver()
            .drive(onNext: { [weak self] location in
                if let location = location {
                    self?.centerAnnotation.coordinate = location
                }
            })
            .disposed(by: bag)
        
        viewModel.isSaveButtonEnabled.asDriver().drive(saveButton.rx.isEnabled).disposed(by: bag)
        viewModel.eventSubmitted
            .asDriver(onErrorDriveWith: .never())
            .drive(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: bag)
        
        viewModel.isLoadingRelay.bind(to: rx.isLoading).disposed(by: bag)
        viewModel.errorRelay.bind(to: rx.error).disposed(by: bag)
    }

    func setup() {
        eventDescriptionTextView.textContainerInset = UIEdgeInsets(top: 13, left: 20, bottom: 13, right: 20)
    }
}

extension CreateEventViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        viewModel.location.accept(mapView.region.center)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? MKPointAnnotation,
            annotation == centerAnnotation else { return nil }
        
        let annotationView: MKAnnotationView
        if let dequeuedAnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotation") {
            annotationView = dequeuedAnotationView
        } else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "annotation")
            annotationView.image = R.image.locationIconBig()!
        }
        return annotationView
    }
}

extension CreateEventViewController: LanguagePickerDelegate {
    
    func updateSelectedLanguages(with languages: [Language]) {
        viewModel.languages.accept(languages)
        let buttonTitle = languages.count == 0 ? "Add languages" :
            ("Selected languages: " + languages.map { $0.code }.joined(separator: ", "))
        addLanguageButton.setTitle(buttonTitle, for: .normal)
    }
}
