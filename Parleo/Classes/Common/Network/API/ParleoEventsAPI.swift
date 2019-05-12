//
//  ParleoEventsAPI.swift
//  Parleo
//
//  Created by Artyom Shaiter on 4/28/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import Moya

enum ParleoEventsAPI {
    case getParleoEvents(minPartic: Int?, maxPartic: Int?, maxDistance: Int?, languages: [String]?, minDate: Date?, maxDate: Date?, page: Int, pageSize: Int, timeStamp: Date?)
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
        let basePath = "/api/Events"
        switch self {
        case let .getParleoEvent(id: id): return "\(basePath)/\(id)"
        case .getParleoEvents, .postParleoEvent: return basePath
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
            var parameters: [String: Any] = ["PageNumber": page,
                                             "PageSize": pageSize]
            if let minPartic = minPartic {
                parameters["MinNumberOfParticipants"] = minPartic
            }
            if let maxPartic = maxPartic {
                parameters["MaxNumberOfParticipants"] = maxPartic
            }
            if let maxDistance = maxDistance {
                parameters["MaxDistance"] = maxDistance
            }
            if let languages = languages {
                parameters["Languages"] = languages
            }
            if let minDate = minDate {
                parameters["MinStartDate"] = minDate
            }
            if let maxDate = maxDate {
                parameters["MaxStartDate"] = maxDate
            }
            if let timeStamp = timeStamp {
                parameters["TimeStamp"] = timeStamp
            }
            
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
            
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
