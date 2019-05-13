//
//  UserAPI.swift
//  Parleo
//
//  Created by Alex Azarov on 3/4/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import Moya

enum UserAPI {
    case getUsers(page: Int, pageSize: Int, filter: UsersFilter)
    case getUser(id: String)
    case getMyProfile
    case updateUser(user: UserUpdate)
    case uploadImage(image: UIImage)
    case updateLocation(lat: Double, lon: Double)
    case getFriends(page: Int, pageSize: Int)
    case removeFriend(userId: String)
    case addFriend(userId: String)
}

extension UserAPI: AuthorizedTargetType {

    var baseURL: URL { return Credentials.Backend.stage }

    var path: String {
        switch self {
        case .getUsers:
            return "/api/Users"
        case .getUser(let id):
            return "/api/Users/\(id)"
        case .updateUser:
            return "/api/Users/current"
        case .getMyProfile:
            return "/api/Users/current"
        case .uploadImage:
            return "/api/Users/current/image"
        case .updateLocation:
            return "/api/Users/current/location"
        case .getFriends:
            return "/api/Users/current/friends"
        case .removeFriend(let userId):
            return "/api/Users/current/friends/\(userId)"
        case .addFriend(let userId):
            return "/api/Users/current/friends/\(userId)"
        }
    }

    var needsAuth: Bool {
        return true
    }

    var method: Method {
        switch self {
        case .getUsers, .getUser, .getMyProfile, .getFriends:
            return .get
        case .updateUser, .uploadImage, .updateLocation, .addFriend:
            return .put
        case .removeFriend:
            return .delete
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .getUser, .getMyProfile, .removeFriend, .addFriend:
            return .requestPlain
        case .getUsers(let page, let pageSize, let filter):
            var parameters: [String: Any] = ["PageNumber": page, "PageSize": pageSize,
                                             "MinAge": filter.minAge, "MaxAge": filter.maxAge,
                                             "Languages": filter.languages.map { $0.code! }]
            if (filter.isMale && !filter.isFemale) || (!filter.isMale && filter.isFemale) {
                parameters["Gender"] = filter.isMale
            }
            return .requestParameters(parameters: parameters, encoding: URLEncoding(destination: .queryString, arrayEncoding: .noBrackets))
        case .updateUser(let user):
            return .requestParameters(parameters: user.toJSON(), encoding: JSONEncoding.default)
        case .uploadImage(let image):
            let imageData = MultipartFormData(provider: .data(image.jpegData(compressionQuality: 0)!), name: "image", fileName: "\(UUID().uuidString).jpg", mimeType: "image/jpeg")
            return .uploadMultipart([imageData])
        case .updateLocation(let lat, let lon):
            return .requestParameters(parameters: ["latitude": lat, "longitude": lon], encoding: JSONEncoding.default)
        case .getFriends(let page, let pageSize):
            return .requestParameters(parameters: ["PageNumber": page, "PageSize": pageSize], encoding: URLEncoding.queryString)
        }
    }

    var headers: [String : String]? {
        return [:]
    }
}
