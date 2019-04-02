//
//  AuthorizationAPI.swift
//  Parleo
//
//  Created by Alex Azarov on 3/4/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import Moya

enum AuthorizationAPI {
    case login(email: String, password: String)
    case register(email: String, password: String)
}

extension AuthorizationAPI: TargetType {

    var baseURL: URL { return Credentials.Backend.stage }

    var path: String {
        switch self {
        case .login:
            return "/api/Account/login"
        case .register:
            return "/api/Account/register"
        }
    }

    var method: Method {
        return .post
    }

    var sampleData: Data {
        switch self {
        case .login:
            return Data()
        case .register:
            return Data()
        }
    }

    var task: Task {
        switch self {
        case .login(let email, let password), .register(let email, let password):
            return .requestParameters(parameters: ["email": email, "password": password], encoding: JSONEncoding.default)
        }
    }

    var headers: [String : String]? {
        return [:]
    }
}
