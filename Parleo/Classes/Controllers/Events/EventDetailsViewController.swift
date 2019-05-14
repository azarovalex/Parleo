//
//  EventDetailsViewController.swift
//  Parleo
//
//  Created by Alex Azarov on 4/2/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import RxCocoa
import RxSwift
import MapKit

class EventDetailsViewController: UIViewController {
    
    @IBOutlet private var eventImageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var flagImageView: UIImageView!
    @IBOutlet private var addressLabel: UILabel!
    @IBOutlet private var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
        }
    }
    
    var viewModel: EventDetailsViewModel!
    private let disposeBag = DisposeBag()
    private let pointAnnotation = MKPointAnnotation()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.addAnnotation(pointAnnotation)
        bindData()
    }
    
    private func bindData() {
        viewModel.eventImageURL
            .asDriver()
            .drive(onNext: { [weak self] imageURL in
                self?.eventImageView.kf.setImage(with: imageURL, placeholder: R.image.avatarTemplate()!)
            })
            .disposed(by: disposeBag)
        
        viewModel.title.asDriver().drive(titleLabel.rx.text).disposed(by: disposeBag)
        viewModel.description.asDriver().drive(descriptionLabel.rx.text).disposed(by: disposeBag)
        viewModel.dateString.asDriver().drive(dateLabel.rx.text).disposed(by: disposeBag)
        viewModel.flagImage.asDriver().drive(flagImageView.rx.image).disposed(by: disposeBag)
        viewModel.address.asDriver().drive(addressLabel.rx.text).disposed(by: disposeBag)
        viewModel.location
            .asDriver()
            .drive(onNext: { [weak self] location in
                guard let location = location else { return }
                self?.pointAnnotation.coordinate = location
                self?.mapView.setCenter(location, animated: false)
            })
            .disposed(by: disposeBag)
    }
    
    @IBAction func joinButtonClicked(_ sender: UIButton) {
    }
}

extension EventDetailsViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? MKPointAnnotation,
            annotation == pointAnnotation else { return nil }
        
        let annotationView: MKAnnotationView
        if let dequeuedAnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotation") {
            annotationView = dequeuedAnotationView
        } else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "annotation")
            annotationView.image = R.image.locationIcon()
        }
        return annotationView
    }
}
