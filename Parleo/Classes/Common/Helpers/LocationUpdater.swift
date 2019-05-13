//
//  LocationUpdater.swift
//  Parleo
//
//  Created by Alex Azarov on 5/13/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import CoreLocation

class LocationUpdater: NSObject {

    private let locationManager = CLLocationManager()
    private let userService = UserService()

    static let shared = LocationUpdater()

    private override init() {
        super.init()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        }
    }

    func startUpdatingLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationUpdater: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        _ = unwrapResult(userService.updateLocation(lat: locValue.latitude, lon: locValue.longitude))
            .subscribe(onNext: {
                print("😎LOCATION UPDATED SUCCESSFULLY😎: \(locValue)")
            }, onError: { error in
                print(error)
            })
    }
}
