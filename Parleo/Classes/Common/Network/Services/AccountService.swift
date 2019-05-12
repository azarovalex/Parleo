//
//  AccountService.swift
//  Parleo
//
//  Created by Alex Azarov on 5/7/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import Moya
import RxSwift

struct AccountService: NetworkService {

    var provider = MoyaProvider<AccountAPI>()

    func register(with email: String, password: String) -> Single<Result<Void>> {
        return send(.register(email: email, password: password))
    }

    func login(with email: String, password: String) -> Single<Result<String>> {
        return fetchStringFromKey("token", api: .login(email: email, password: password))
    }

    func verifyEmail(token: String) -> Single<Result<EmailVerificationResponse>> {
        return fetchModel(.verifyEmail(token: token))
    }
}
