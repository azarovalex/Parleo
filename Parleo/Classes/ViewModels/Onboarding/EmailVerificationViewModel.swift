//
//  EmailVerificationViewModel.swift
//  Parleo
//
//  Created by Alex Azarov on 5/7/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import RxSwift
import RxCocoa
import Action

class EmailVerificationViewModel: ViewModelType {

    struct Input {
        let token: String
    }

    struct Output {
        let verifyEmailAction: CocoaAction
        let isLoading: Driver<Bool>
        let error: Signal<Error>
        let navigation: Signal<Void>
    }

    func transform(input: Input) -> Output {
        let verifyEmailAction = getVerifyEmailAction(token: input.token)

        return Output(verifyEmailAction: verifyEmailAction,
                      isLoading: verifyEmailAction.executingDriver,
                      error: verifyEmailAction.errorSignal,
                      navigation: verifyEmailAction.elements.asSignal { _ in .never() })
    }
}

// MARK: - Private
private extension EmailVerificationViewModel {

    func getVerifyEmailAction(token: String) -> CocoaAction {
        let accountService = AccountService()

        return CocoaAction(workFactory: {
            return .just(())
            unwrapResult(accountService.verifyEmail(token: token))
        })
    }
}
