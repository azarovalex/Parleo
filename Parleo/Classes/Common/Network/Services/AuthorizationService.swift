//
//  AuthorizationService.swift
//  Parleo
//
//  Created by Alex Azarov on 3/4/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import Moya
import RxSwift

struct AuthorizationService: NetworkService {

    var provider = MoyaProvider<AuthorizationAPI>()

    func login(with email: String, password: String) -> Single<Result<String>> {
        return fetchStringFromKey("token", api: .login(email: email, password: password))
    }

    func register(with email: String, password: String) -> Single<Result<String>> {
        return fetchStringFromKey("token", api: .register(email: email, password: password))
    }
}
