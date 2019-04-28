//
//  EventsService.swift
//  Parleo
//
//  Created by Artyom Shaiter on 4/21/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import ApiClient
import RxSwift

struct EventsService {
    func createEvent(name: String,
                     description: String,
                     maxParticipants: Int,
                     location: Location,
                     isFinished: Bool,
                     startTime: Date,
                     endDate: Date,
                     creatorId: UUID,
                     languageId: UUID) -> Observable<Response<Void>> {
        
        let builder = EventAPI.createEventAsyncWithRequestBuilder(name: name,
                                                                  _description: description,
                                                                  maxParticipants: maxParticipants,
                                                                  latitude: location.latitude,
                                                                  longitude: location.longitude,
                                                                  isFinished: isFinished,
                                                                  startTime: startTime,
                                                                  endDate: endDate,
                                                                  creatorId: creatorId,
                                                                  languageId: languageId)
        
        return builder.observable()
    }
    
    func getEvents(pageSize: Int,
                   page: Int,
                   minNumberOfParticipants: Int? = nil,
                   maxNumberOfParticipants: Int? = nil,
                   minDistance: Int? = nil,
                   maxDistance: Int? = nil,
                   languages: [UUID]? = nil,
                   minStartDate: Date? = nil,
                   maxStartDate: Date? = nil) -> Observable<Response<Void>>  {
        let builder = EventAPI.getEventsPageAsyncWithRequestBuilder(minNumberOfParticipants: minNumberOfParticipants,
                                                                    maxNumberOfParticipants: maxNumberOfParticipants,
                                                                    minDistance: minDistance,
                                                                    maxDistance: maxDistance,
                                                                    languages: languages,
                                                                    minStartDate: minStartDate,
                                                                    maxStartDate: maxStartDate,
                                                                    page: page,
                                                                    pageSize: pageSize)
        return builder.observable()
    }
}
