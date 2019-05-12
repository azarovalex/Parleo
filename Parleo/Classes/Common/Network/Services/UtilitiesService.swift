//
//  UtilitiesService.swift
//  Parleo
//
//  Created by Alex Azarov on 5/8/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import Moya
import RxSwift

struct UtilitiesService: NetworkService {

    var provider = MoyaProvider<UtilitiesAPI>(plugins: [AuthPlugin(token: Storage.shared.accessToken)])

    func getLanguages() -> Single<Result<[LanguageId]>> {
        return fetchArray(.getLanguages)
    }
}
