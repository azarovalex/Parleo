//
//  SingUpViewModel.swift
//  Parleo
//
//  Created by Alex Azarov on 4/2/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import RxSwift
import RxCocoa
import Action

class SignUpViewModel: ViewModelType {
    
    private let navigationRelay = PublishRelay<Void>()

    struct Input {
        let credentials: (email: String, password: String)
    }

    struct Output {
        let registerAction: CocoaAction
        let isLoading: Driver<Bool>
        let errors: Signal<Error>
        let navigate: Signal<Void>
    }

    func transform(input: Input) -> Output {
        let action = getRegistrationAction()
        return Output(registerAction: action,
                      isLoading: action.executing.asDriver { _ in .never() },
                      errors: action.underlyingError.asSignal { _ in .never() },
                      navigate: navigationRelay.asSignal())
    }
}

// MARK: - Private
private extension SignUpViewModel {

    func getRegistrationAction() -> CocoaAction {
        return CocoaAction {
            return .never()
        }
    }
}
