//
//  Reactive.swift
//  Parleo
//
//  Created by Alex Azarov on 3/31/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import RxSwift
import RxCocoa
import Action
import ApiClient
import Rswift

func unwrapResult<ResultValue, O: ObservableConvertibleType>(_ observable: O) -> Observable<ResultValue> where O.E == Result<ResultValue> {
    return observable.asObservable().map { result in
        switch result {
        case .failure(let error):
            throw error
        case .success(let value):
            return value
        }
    }
}

extension RequestBuilder {
    func observable() -> Observable<ApiClient.Response<T>> {
        // TODO: Check memory leak [weak self]
        return Observable<ApiClient.Response<T>>.create { (observer) -> Disposable in
            self.execute { (response, error) -> Void in
                if let error = error {
                    observer.onError(error)
                } else if let response = response {
                    observer.onNext(response)
                    observer.onCompleted()
                } else {
                    observer.onError(NSError(domain: "Something is wrong with Alamofire response: both 'error' and 'response' are empty", code: 0))
                }
            }
            return Disposables.create(with: {
                // TODO: Cancel request
            })
        }
    }
}

extension CocoaAction {

    var executingDriver: Driver<Bool> {
        return executing.asDriver { _ in .never() }
    }

    var errorSignal: Signal<Error> {
        return underlyingError.asSignal { _ in .never() }
    }
}
