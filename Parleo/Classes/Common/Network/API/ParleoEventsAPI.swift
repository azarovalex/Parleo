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
    case putParleoEventPhoto(eventId: String, image: UIImage)
    case addParticipant(eventId: String, userId: String)
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
        case .putParleoEventPhoto(let eventId, _): return "\(basePath)/\(eventId)/image"
        case .getParleoEvents, .postParleoEvent: return basePath
        case .addParticipant(let eventId, _): return "\(basePath)/\(eventId)/participants"
        }
    }
    
    var method: Method {
        switch self {
        case .getParleoEvent, .getParleoEvents: return .get
        case .postParleoEvent: return .post
        case .putParleoEventPhoto, .addParticipant: return .put
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
                                                   "startTime": startTime.iso8601,
                                                   "endDate": endDate.iso8601,
                                                   "languageCode": languageCode],
                                      encoding: JSONEncoding.default)
            
        case .putParleoEventPhoto(_, let image):
            let imageData = MultipartFormData(provider: .data(image.jpegData(compressionQuality: 0)!), name: "image", fileName: "\(UUID().uuidString).jpg", mimeType: "image/jpeg")
            return .uploadMultipart([imageData])
            
        case .addParticipant(_, let userId):
            return .requestJSONEncodable([userId])
        }
    }
    
    var headers: [String : String]? {
        return [:]
    }
}

extension ISO8601DateFormatter {
    convenience init(_ formatOptions: Options, timeZone: TimeZone = TimeZone(secondsFromGMT: 0)!) {
        self.init()
        self.formatOptions = formatOptions
        self.timeZone = timeZone
    }
}

extension Formatter {
    static let iso8601 = ISO8601DateFormatter([.withInternetDateTime, .withFractionalSeconds])
}

extension Date {
    var iso8601: String {
        return Formatter.iso8601.string(from: self)
    }
}

extension String {
    var iso8601: Date? {
        return Formatter.iso8601.date(from: self)
    }
}
