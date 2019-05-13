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

    func updateUser(newUser: UserUpdate) -> Single<Result<Void>> {
        return send(.updateUser(user: newUser))
    }

    func getMyProfile() -> Single<Result<User>> {
        return fetchModel(.getMyProfile)
    }

    func uploadImage(image: UIImage) -> Single<Result<Void>> {
        return send(.uploadImage(image: image))
    }

    func updateLocation(lat: Double, lon: Double) -> Single<Result<Void>> {
        return send(.updateLocation(lat: lat, lon: lon))
    }
}
