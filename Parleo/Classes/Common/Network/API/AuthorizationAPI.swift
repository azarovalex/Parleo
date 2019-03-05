//
//  AuthorizationAPI.swift
//  Parleo
//
//  Created by Alex Azarov on 3/4/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import Moya

enum AuthorizationAPI {
    case login(username: String, password: String)
}

extension AuthorizationAPI: TargetType {

    var baseURL: URL { return Credentials.Backend.stage }

    var path: String {
        switch self {
        case .login:
            return "/login"
        }
    }

    var method: Method {
        return .post
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        return .requestPlain
    }

    var headers: [String : String]? {
        return [:]
    }
}
