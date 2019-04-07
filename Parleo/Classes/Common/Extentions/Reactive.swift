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
