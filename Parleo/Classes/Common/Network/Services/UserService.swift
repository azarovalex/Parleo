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

    func getUsers(page: Int, pageSize: Int) -> Single<Result<PagedResponse<User>>> {
        return fetchModel(.getUsers(page: page, pageSize: pageSize))
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

    func uploadImage(userId: String, image: UIImage) -> Single<Result<Void>> {
        return send(.uploadImage(id: userId, image: image))
    }

    func updateLocation(userId: String, lat: Double, lon: Double) -> Single<Result<Void>> {
        return send(.updateLocation(id: userId, lat: lat, lon: lon))
    }
}
