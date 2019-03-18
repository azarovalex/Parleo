//
//  NetworkService.swift
//  Parleo
//
//  Created by Alex Azarov on 3/4/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import ObjectMapper

protocol NetworkService {
    associatedtype API: TargetType
    var provider: MoyaProvider<API> { get set }
    init()
}

//MARK: - Private
extension NetworkService {

    init(mockType: ServiceMockType = .none) {
        self.init()
        switch mockType {
        case .immediate:
            provider = MoyaProvider<API>(stubClosure: MoyaProvider.immediatelyStub)
        case .delayed(let interval):
            provider = MoyaProvider<API>(stubClosure: MoyaProvider.delayedStub(interval))
        case .none:
            break
        }
    }

    func send(_ api: API) -> Single<Result<Void>> {
        return makeRequest(to: api).map { result in
            guard let response = result.value else { return .failure(result.error ?? EmptyError()) }
            guard (try? response.filterSuccessfulStatusCodes()) != nil else { return .failure(NetworkError(response: response)) }
            return .success(())
        }
    }

    func fetchString(_ api: API) -> Single<Result<String>> {
        return makeRequest(to: api).map { result in
            guard let response = result.value else { return .failure(result.error ?? EmptyError()) }
            guard let data = try? response.mapString() else { return .failure(NetworkError(response: response)) }
            return .success(data)
        }
    }

    func fetchValue<T>(_ api: API) -> Single<Result<T>> {
        return makeRequest(to: api).map { result in
            guard let response = result.value else { return .failure(result.error ?? EmptyError()) }
            guard let data = try? response.mapJSON() as? T, let unwrappedData = data else {
                return .failure(NetworkError(response: response))
            }
            return .success(unwrappedData)
        }
    }

    func fetchModel<T: BaseMappable>(_ api: API) -> Single<Result<T>> {
        return makeRequest(to: api).map { result in
            guard let response = result.value else { return .failure(result.error ?? EmptyError()) }
            guard let data = T(response: response) else { return .failure(NetworkError(response: response)) }
            return .success(data)
        }
    }

    func fetchArray<T: BaseMappable>(_ api: API) -> Single<Result<[T]>> {
        return makeRequest(to: api).map { result in
            guard let response = result.value else { return .failure(result.error ?? EmptyError()) }
            guard let data = [T](response: response) else { return .failure(NetworkError(response: response)) }
            return .success(data)
        }
    }

    private func makeRequest(to api: API) -> Single<Result<Response>> {
        return provider.rx.request(api).map { .success($0) }.catchError { Single.just(.failure($0)) }
    }
}
