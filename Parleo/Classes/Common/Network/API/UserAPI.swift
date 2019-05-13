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
    case register(email: String, password: String)
    case login(email: String, password: String)
    case getUser(id: String)
    case updateUser(id: String, user: User)
    case getMyProfile
    case verifyEmail(token: String)
    case uploadImage(id: String, image: UIImage)
    case updateLocation(id: String, lat: Double, lon: Double)
    case getCurrentUserEvents(page: Int, pageSize: Int)
}

extension UserAPI: AuthorizedTargetType {

    var baseURL: URL { return Credentials.Backend.stage }

    var path: String {
        switch self {
        case .getUsers:
            return "/api/Users"
        case .register:
            return "/api/Accounts/register"
        case .login:
            return "/api/Accounts/login"
        case .getUser(let id), .updateUser(let id, _):
            return "/api/Accounts/\(id)"
        case .getMyProfile:
            return "/api/Accounts/me"
        case .verifyEmail:
            return "/api/Accounts/activate"
        case .uploadImage(let id, _):
            return "/api/Accounts/\(id)/image"
        case .updateLocation(let id, _, _):
            return "/api/Accounts/\(id)/location"
        case .getCurrentUserEvents:
            return "/api/Users/current/attending-events"
        }
    }

    var needsAuth: Bool {
        switch self {
        case .register, .login:
            return false
        default:
            return true
        }
    }

    var method: Method {
        switch self {
        case .getUsers, .getUser, .getMyProfile, .verifyEmail, .getCurrentUserEvents:
            return .get
        case .register, .login:
            return .post
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
        case .register(let email, let password), .login(let email, let password):
            return .requestParameters(parameters: ["email": email, "password": password], encoding: JSONEncoding.default)
        case .updateUser(_, let user):
            return .requestParameters(parameters: user.toJSON(), encoding: JSONEncoding.default)
        case .verifyEmail(let token):
            return .requestParameters(parameters: ["token": token], encoding: URLEncoding.queryString)
        case .uploadImage(_, let image):
            let imageData = MultipartFormData(provider: .data(image.jpegData(compressionQuality: 0)!), name: "image", fileName: "\(UUID().uuidString).jpg", mimeType: "image/jpeg")
            return .uploadMultipart([imageData])
        case .updateLocation(_, let lat, let lon):
            return .requestParameters(parameters: ["latitude": lat, "longitude": lon], encoding: JSONEncoding.default)
        case .getCurrentUserEvents(let page, let pageSize):
            return .requestParameters(parameters: ["PageNumber": page, "PageSize": pageSize], encoding: URLEncoding.queryString)
        }
    }

    var headers: [String : String]? {
        return [:]
    }
}
