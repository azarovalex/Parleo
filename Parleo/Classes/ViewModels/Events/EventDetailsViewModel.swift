//
//  EventDetailsViewModel.swift
//  Parleo
//
//  Created by Artyom Shaiter on 5/14/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import RxCocoa
import RxSwift
import MapKit

class EventDetailsViewModel {
    let eventImageURL = BehaviorRelay<URL?>(value: nil)
    let title = BehaviorRelay<String?>(value: nil)
    let description = BehaviorRelay<String?>(value: nil)
    let dateString = BehaviorRelay<String?>(value: nil)
    let flagImage = BehaviorRelay<UIImage?>(value: R.image.flagTemplate())
    let address = BehaviorRelay<String?>(value: nil)
    let location = BehaviorRelay<CLLocationCoordinate2D?>(value: nil)
    let members = BehaviorRelay<[ParleoEvent.Participants]>(value: [])
    
    init(parleoEvent: ParleoEvent) {
        eventImageURL.accept(parleoEvent.eventImageURL)
        title.accept(parleoEvent.title)
        description.accept(parleoEvent.description)
        dateString.accept(parleoEvent.startTime.asString(format: "MMM d, yyyy: H m"))
        flagImage.accept(parleoEvent.language?.flagImage ?? R.image.flagTemplate()!)
        location.accept(CLLocationCoordinate2D(latitude: parleoEvent.latitude,
                                               longitude: parleoEvent.longitude))
        members.accept(parleoEvent.participants)
    }
    
    func setupAddress() {
        let location = CLLocation(latitude: self.location.value?.latitude ?? 0,
                                  longitude: self.location.value?.longitude ?? 0)
        CLGeocoder().reverseGeocodeLocation(location) { [weak self] placemark, _ in
            guard let placemark = placemark?.first else {
                return
            }
            self?.address.accept(placemark.administrativeArea)
        }
    }
}
