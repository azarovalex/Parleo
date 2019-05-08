//
//  ParleoEventsAPI.swift
//  Parleo
//
//  Created by Artyom Shaiter on 4/28/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import Moya

enum ParleoEventsAPI {
    case getParleoEvents(minPartic: Int, maxPartic: Int, maxDistance: Int, languages: [String], minDate: Date, maxDate: Date, page: Int, pageSize: Int, timeStamp: Date)
    case getParleoEvent(id: String)
    case postParleoEvent(name: String, description: String, maxParticipants: Int, latitude: Double, longitude: Double, isFinished: Bool, startTime: Date, endDate: Date, languageCode: String)
}

extension ParleoEventsAPI: AuthorizedTargetType {
    var needsAuth: Bool {
        return true
    }
    
    var baseURL: URL {
        return Credentials.Backend.stage
    }
    
    var path: String {
        switch self {
        case let .getParleoEvent(id: id): return "api/Events/\(id)"
        case .getParleoEvents, .postParleoEvent: return "api/Events"
        }
    }
    
    var method: Method {
        switch self {
        case .getParleoEvent, .getParleoEvents: return .get
        case .postParleoEvent: return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getParleoEvent: return .requestPlain
        case let .getParleoEvents(minPartic: minPartic,
                                  maxPartic: maxPartic,
                                  maxDistance: maxDistance,
                                  languages: languages,
                                  minDate: minDate,
                                  maxDate: maxDate,
                                  page: page,
                                  pageSize: pageSize,
                                  timeStamp: timeStamp):
            return .requestParameters(parameters: ["MinNumberOfParticipants": minPartic,
                                                   "MaxNumberOfParticipants": maxPartic,
                                                   "MaxDistance": maxDistance,
                                                   "Languages": languages,
                                                   "MinStartDate": minDate,
                                                   "MaxStartDate": maxDate,
                                                   "Page": page,
                                                   "PageSize": pageSize,
                                                   "TimeStamp": timeStamp],
                                      encoding: URLEncoding.queryString)
        case let .postParleoEvent(name: name,
                                  description: description,
                                  maxParticipants: maxParticipants,
                                  latitude: latitude,
                                  longitude: longitude,
                                  isFinished: isFinished,
                                  startTime: startTime,
                                  endDate: endDate,
                                  languageCode: languageCode):
            return .requestParameters(parameters: ["name": name,
                                                   "description": description,
                                                   "maxParticipants": maxParticipants,
                                                   "latitude": latitude,
                                                   "longitude": longitude,
                                                   "isFinished": isFinished,
                                                   "startTime": startTime,
                                                   "endDate": endDate,
                                                   "languageCode": languageCode],
                                      encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return [:]
    }
}
