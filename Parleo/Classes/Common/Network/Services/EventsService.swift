//
//  EventsService.swift
//  Parleo
//
//  Created by Artyom Shaiter on 4/21/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import Moya
import RxSwift

struct EventsService: NetworkService {
    var provider = MoyaProvider<ParleoEventsAPI>(plugins: [AuthPlugin(token: Storage.shared.accessToken)])
    
    func fetchParleoEvents(page: Int, pageSize: Int) -> Single<Result<PagedResponse<ParleoEvent>>> {
        return fetchModel(.getParleoEvents(minPartic: nil, maxPartic: nil, maxDistance: nil, languages: nil, minDate: nil, maxDate: nil, page: page, pageSize: pageSize, timeStamp: nil))
    }
    
    func createParleoEvent(name: String,
                           description: String,
                           maxParticipants: Int,
                           latitude: Double,
                           longitude: Double,
                           startTime: Date,
                           endDate: Date,
                           languageCode: String) -> Single<Result<ParleoEvent>>  {
        return fetchModel(.postParleoEvent(name: name,
                                           description: description,
                                           maxParticipants: maxParticipants,
                                           latitude: latitude,
                                           longitude: longitude,
                                           isFinished: false,
                                           startTime: startTime,
                                           endDate: endDate,
                                           languageCode: languageCode))
    }
    
    func uploadParleoEventImage(eventId: String, image: UIImage) -> Single<Result<Void>> {
        return send(.putParleoEventPhoto(eventId: eventId, image: image))
    }
    
    func joinEvent(eventId: String, userId: String) -> Single<Result<Void>> {
        return send(.addParticipant(eventId: eventId, userId: userId))
    }
}
