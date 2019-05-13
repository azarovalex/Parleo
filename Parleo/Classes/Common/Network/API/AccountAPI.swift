//
//  AccountAPI.swift
//  Parleo
//
//  Created by Alex Azarov on 5/7/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import Moya

enum AccountAPI {
    case register(email: String, password: String)
    case login(email: String, password: String)
    case verifyEmail(token: String)
}

extension AccountAPI: TargetType {

    var baseURL: URL { return Credentials.Backend.stage }

    var path: String {
        switch self {
        case .register:
            return "/api/Accounts/register"
        case .login:
            return "/api/Accounts/login"
        case .verifyEmail:
            return "/api/Accounts/activate"
        }
    }

    var method: Method {
        switch self {
        case .register, .login:
            return .post
        case .verifyEmail:
            return .get
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .register(let email, let password), .login(let email, let password):
            return .requestParameters(parameters: ["email": email, "password": password], encoding: JSONEncoding.default)
        case .verifyEmail(let token):
            return .requestParameters(parameters: ["token": token], encoding: URLEncoding.queryString)
        }
    }

    var headers: [String : String]? {
        return [:]
    }
}
