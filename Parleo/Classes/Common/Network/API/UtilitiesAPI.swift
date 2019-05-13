//
//  UtilitiesAPI.swift
//  Parleo
//
//  Created by Alex Azarov on 5/8/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import Moya

enum UtilitiesAPI {
    case getLanguages
}

extension UtilitiesAPI: AuthorizedTargetType {

    var baseURL: URL { return Credentials.Backend.stage }

    var path: String {
        switch self {
        case .getLanguages:
            return "/api/Utilities/languages"
        }
    }

    var needsAuth: Bool {
        return true
    }

    var method: Moya.Method {
        switch self {
        case .getLanguages:
            return .get
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .getLanguages:
            return .requestPlain
        }
    }

    var headers: [String : String]? {
        return [:]
    }
}
