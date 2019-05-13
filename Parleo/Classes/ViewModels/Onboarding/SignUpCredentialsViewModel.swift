//
//  SignUpCredentialsViewModel.swift
//  Parleo
//
//  Created by Alex Azarov on 4/30/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import RxSwift
import RxCocoa
import Action

class SignUpCredentialsViewModel: ViewModelType {

    struct Input {
        let email: Driver<String>
        let password: Driver<String>
        let repeatedPassword: Driver<String>
    }

    struct Output {
        let registerAction: CocoaAction
        let error: Signal<Error>
        let isLoading: Driver<Bool>
        let registered: Signal<Void>
    }

    func transform(input: Input) -> Output {
        let registerAction = getRegisterAction(input: input)
        return Output(registerAction: registerAction,
                      error: registerAction.errorSignal,
                      isLoading: registerAction.executingDriver,
                      registered: registerAction.elements.asSignal { _ in .never() })
    }
}

// MARK: - Private
private extension SignUpCredentialsViewModel {

    typealias UserInfo = (email: String, password: String, repeatedPassword: String)

    func getRegisterAction(input: Input) -> CocoaAction {
        let loginInfo = Driver.combineLatest(input.email, input.password, input.repeatedPassword,
                                             resultSelector: { (email: $0, password: $1, repeatedPassword: $2) })
        let enabledIf = loginInfo.map { !$0.0.isEmpty && !$0.1.isEmpty && !$0.2.isEmpty }
        let accountService = AccountService()
        return CocoaAction(enabledIf: enabledIf.asObservable(), workFactory: {
            return loginInfo.asObservable().take(1)
                .flatMap { [unowned self] in self.validate(userInfo: $0) }
                .flatMap { unwrapResult(accountService.register(with: $0.email, password: $0.password)) }
        })
    }

    func validate(userInfo: UserInfo) -> Observable<UserInfo> {
        guard userInfo.password == userInfo.repeatedPassword else {
            return .error(SimpleError(message: "Passwords are not the same"))
        }
        guard Validators.validate(email: userInfo.email) else {
            return .error(SimpleError(message: "Wrong email format"))
        }
        let passwordValidationResult = Validators.validate(password: userInfo.password)
        guard passwordValidationResult.result else {
            return .error(SimpleError(message: passwordValidationResult.error!))
        }
        return .just(userInfo)
    }
}
