//
//  UserAPI.swift
//  Parleo
//
//  Created by Alex Azarov on 3/4/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import Moya

enum UserAPI {
    case getUsers(page: Int, pageSize: Int)
    case getUser(id: String)
    case updateUser(id: String, user: User)
    case getMyProfile
    case uploadImage(id: String, image: UIImage)
    case updateLocation(id: String, lat: Double, lon: Double)
}

extension UserAPI: AuthorizedTargetType {

    var baseURL: URL { return Credentials.Backend.stage }

    var path: String {
        switch self {
        case .getUsers:
            return "/api/Account"
        case .getUser(let id), .updateUser(let id, _):
            return "/api/Account/\(id)"
        case .getMyProfile:
            return "/api/Account/me"
        case .uploadImage(let id, _):
            return "/api/Account/\(id)/image"
        case .updateLocation(let id, _, _):
            return "/api/Account/\(id)/location"
        }
    }

    var needsAuth: Bool {
        return true
    }

    var method: Method {
        switch self {
        case .getUsers, .getUser, .getMyProfile:
            return .get
        case .updateUser, .uploadImage, .updateLocation:
            return .put
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .getUser, .getMyProfile:
            return .requestPlain
        case .getUsers(let page, let pageSize):
            return .requestParameters(parameters: ["PageNumber": page, "PageSize": pageSize], encoding: URLEncoding.queryString)
        case .updateUser(_, let user):
            return .requestParameters(parameters: user.toJSON(), encoding: JSONEncoding.default)
        case .uploadImage(_, let image):
            let imageData = MultipartFormData(provider: .data(image.jpegData(compressionQuality: 0)!), name: "image", fileName: "\(UUID().uuidString).jpg", mimeType: "image/jpeg")
            return .uploadMultipart([imageData])
        case .updateLocation(_, let lat, let lon):
            return .requestParameters(parameters: ["latitude": lat, "longitude": lon], encoding: JSONEncoding.default)
        }
    }

    var headers: [String : String]? {
        return [:]
    }
}
