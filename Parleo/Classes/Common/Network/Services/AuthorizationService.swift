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

    func logIn(with username: String, password: String) -> Single<Result<User>> {
        return fetchModel(.login(username: "alex", password: "qwerty"))
    }
}
