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
    @IBOutlet var membersCollectionView: UICollectionView! {
        didSet {
            membersCollectionView.register(R.nib.participantCollectionViewCell)
            membersCollectionView.delegate = self
            membersCollectionView.dataSource = self
            membersCollectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
    }
    
    @IBOutlet private var joinButton: UIButton!
    
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
                self?.viewModel.setupAddress()
            })
            .disposed(by: disposeBag)
        viewModel.isLoadingRelay.bind(to: rx.isLoading).disposed(by: disposeBag)
        viewModel.errorRelay.bind(to: rx.error).disposed(by: disposeBag)
        viewModel.joinButtonIsHiddenRelay.asDriver().drive(joinButton.rx.isHidden).disposed(by: disposeBag)
    }
    
    @IBAction func joinButtonClicked(_ sender: UIButton) {
        viewModel.joinButtonClicked()
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
            annotationView.image = R.image.locationIconBig()
        }
        return annotationView
    }
}

extension EventDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.members.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.participantCollectionViewCell, for: indexPath) else {
            return UICollectionViewCell()
        }
        cell.imageURL = viewModel.members.value[indexPath.row].imageURL
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 44, height: 44)
    }
}
