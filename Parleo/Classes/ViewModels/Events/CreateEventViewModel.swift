//
//  CreateEventViewModel.swift
//  Parleo
//
//  Created by Artyom Shaiter on 5/13/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import RxCocoa
import RxSwift
import MapKit

class CreateEventViewModel {
    let eventImage = BehaviorRelay<UIImage?>(value: nil)
    let title = BehaviorRelay<String?>(value: nil)
    let description = BehaviorRelay<String?>(value: nil)
    let startDate = BehaviorRelay<Date?>(value: nil)
    let languages = BehaviorRelay<[Language]>(value: [])
    let location = BehaviorRelay<CLLocationCoordinate2D?>(value: nil)
    let isSaveButtonEnabled = BehaviorRelay<Bool>(value: false)
    let eventSubmitted = PublishRelay<Void>()
    let isLoadingRelay = PublishRelay<Bool>()
    let errorRelay = PublishRelay<Error>()
    
    private let disposeBag = DisposeBag()
    
    private let eventsService = EventsService()
    
    init() {
        Observable.combineLatest(eventImage, title, description, startDate, languages, location)
            .map { (eventImage, tilte, description, startDate, languages, location) in
                eventImage != nil &&
                    tilte != nil &&
                    description != nil &&
                    startDate != nil &&
                    !languages.isEmpty &&
                    location != nil
            }
            .bind(to: isSaveButtonEnabled)
            .disposed(by: disposeBag)
    }
    
    func saveButtonClicked() {
        let responce = eventsService.createParleoEvent(name: title.value!,
                                                       description: description.value!,
                                                       maxParticipants: 20,
                                                       latitude: location.value!.latitude,
                                                       longitude: location.value!.longitude,
                                                       startTime: startDate.value!,
                                                       endDate: Calendar.current.date(byAdding: .day, value: 1, to: startDate.value!) ?? Date(),
                                                       languageCode: languages.value.first!.code)
        isLoadingRelay.accept(true)
        responce.asObservable()
            .bind { [weak self] result in
                if let error = result.error {
                    self?.errorRelay.accept(error)
                    self?.isLoadingRelay.accept(false)
                } else if let parleoEvent = result.value {
                    guard let self = self else { return }

                    let responce = self.eventsService.uploadParleoEventImage(eventId: parleoEvent.id,
                                                                             image: self.eventImage.value!)
                    responce.asObservable()
                        .bind { [weak self] result in
                            if let error = result.error {
                                self?.errorRelay.accept(error)
                            } else {
                                self?.eventSubmitted.accept(())
                            }
                            self?.isLoadingRelay.accept(false)
                        }
                        .disposed(by: self.disposeBag)
                }
            }
            .disposed(by: disposeBag)
    }
}
