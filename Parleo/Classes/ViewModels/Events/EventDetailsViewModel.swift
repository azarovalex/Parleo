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
    let joinButtonIsHiddenRelay = BehaviorRelay<Bool>(value: true)
    let isLoadingRelay = PublishRelay<Bool>()
    let errorRelay = PublishRelay<Error>()
    private let eventId: String
    
    private let eventsService = EventsService()
    private let userService = UserService()
    private let disposeBag = DisposeBag()
    
    init(parleoEvent: ParleoEvent) {
        eventId = parleoEvent.id
        eventImageURL.accept(parleoEvent.eventImageURL)
        title.accept(parleoEvent.title)
        description.accept(parleoEvent.description)
        dateString.accept(parleoEvent.startTime.asString(format: "MMM d, yyyy: H m"))
        flagImage.accept(parleoEvent.language?.flagImage ?? R.image.flagTemplate()!)
        location.accept(CLLocationCoordinate2D(latitude: parleoEvent.latitude,
                                               longitude: parleoEvent.longitude))
        members.accept(parleoEvent.participants)
        
        checkIsCurrentUserParticipant()
    }
    
    func checkIsCurrentUserParticipant() {
        let responce = userService.getMyProfile()
        
        responce.asObservable()
            .bind(onNext: { [weak self] result in
                guard let self = self else { return }
                if let userId = result.value?.id, !self.members.value.contains(where: { $0.id == userId }) {
                    self.joinButtonIsHiddenRelay.accept(false)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func setupAddress() {
        let location = CLLocation(latitude: self.location.value?.latitude ?? 0,
                                  longitude: self.location.value?.longitude ?? 0)
        CLGeocoder().reverseGeocodeLocation(location) { [weak self] placemark, _ in
            guard let placemark = placemark?.first else {
                return
            }
            self?.address.accept(placemark.name)
        }
    }
    
    func joinButtonClicked() {
        let responce = userService.getMyProfile()
        
        isLoadingRelay.accept(true)
        responce.asObservable()
            .bind(onNext: { [weak self] result in
                guard let self = self else { return }
                if let userId = result.value?.id {
                    let responce = self.eventsService.joinEvent(eventId: self.eventId, userId: userId)
                    responce.asObservable()
                        .bind(onNext: { [weak self] result in
                            if let error = result.error {
                                self?.errorRelay.accept(error)
                            } else {
                                self?.joinButtonIsHiddenRelay.accept(true)
                            }
                            self?.isLoadingRelay.accept(false)
                        })
                        .disposed(by: self.disposeBag)
                } else {
                    self.isLoadingRelay.accept(false)
                }
            })
            .disposed(by: disposeBag)
    }
}
