//
//  AuthPlugin.swift
//  Parleo
//
//  Created by Alex Azarov on 4/22/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import Foundation
import Moya

protocol AuthorizedTargetType: TargetType {
    var needsAuth: Bool { get }
}

struct AuthPlugin: PluginType {
    let token: () -> String?

    init(token: @escaping @autoclosure () -> String?) { self.token = token }

    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        guard let target = target as? AuthorizedTargetType, target.needsAuth, let token = token() else { return request }
        var request = request
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
