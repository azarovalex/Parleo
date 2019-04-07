//
//  EventDetailsViewController.swift
//  Parleo
//
//  Created by Alex Azarov on 4/2/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import UIKit
import MapKit

class EventDetailsViewController: UIViewController {

    @IBOutlet private var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
}

// MARK: - Setup
private extension EventDetailsViewController {

    func setup() {
        let annotation = MKPointAnnotation()
        let eventPlace = CLLocationCoordinate2D(latitude: 53.9, longitude: 27.566)
        annotation.coordinate = eventPlace
        annotation.title = "Event"
        mapView.addAnnotation(annotation)
        mapView.region = MKCoordinateRegion(center: eventPlace, latitudinalMeters: 100, longitudinalMeters: 100)
    }
}
