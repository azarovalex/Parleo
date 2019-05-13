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

    private let accountService = AccountService()

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
        return CocoaAction(workFactory: { [unowned self] in
            unwrapResult(self.accountService.verifyEmail(token: token))
                .map { response in
                    Storage.shared.accessToken = response.token
                    Storage.shared.currentUserId = response.id
                    LocationUpdater.shared.startUpdatingLocation()
                }
        })
    }
}
