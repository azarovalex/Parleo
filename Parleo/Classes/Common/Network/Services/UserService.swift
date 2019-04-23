//
//  UserService.swift
//  Parleo
//
//  Created by Alex Azarov on 3/4/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import Moya
import RxSwift

struct UserService: NetworkService {

    var provider = MoyaProvider<UserAPI>(plugins: [AuthPlugin(token: Storage.shared.accessToken)])

    func getUsers() -> Single<Result<UsersPaginationResponse>> {
        return fetchModel(.getUsers)
    }

    func register(with email: String, password: String) -> Single<Result<Void>> {
        return send(.register(email: email, password: password))
    }

    func login(with email: String, password: String) -> Single<Result<String>> {
        return fetchStringFromKey("token", api: .login(email: email, password: password))
    }

    func getUser(with id: String) -> Single<Result<User>> {
        return fetchModel(.getUser(id: id))
    }

    func updateUser(id: String, newUser: User) -> Single<Result<Void>> {
        return send(.updateUser(id: id, user: newUser))
    }

    func getMyProfile() -> Single<Result<User>> {
        return fetchModel(.getMyProfile)
    }

    func verifyEmail(token: String) -> Single<Result<Void>> {
        return send(.verifyEmail(token: token))
    }

    func uploadImage(userId: String, image: UIImage) -> Single<Result<Void>> {
        return send(.uploadImage(id: userId, image: image))
    }

    func updateLocation(userId: String, lat: Double, lon: Double) -> Single<Result<Void>> {
        return send(.updateLocation(id: userId, lat: lat, lon: lon))
    }
}
