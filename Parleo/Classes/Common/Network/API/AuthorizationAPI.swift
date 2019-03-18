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
        switch self {
        case .login(let email, _):
            return .mockedUser(with: email)
        }
    }

    var task: Task {
        return .requestPlain
    }

    var headers: [String : String]? {
        return [:]
    }
}

private extension Data {

    static func mockedUser(with email: String) -> Data {
        return User(id: 1, email: email).toJSONString()!.data(using: .utf8)!
    }
}
