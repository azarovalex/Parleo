//
//  LoginViewModel.swift
//  Parleo
//
//  Created by Alex Azarov on 3/10/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import RxSwift
import RxCocoa
import Action

class LoginViewModel: ViewModelType {

    private let accountService = AccountService()

    struct Input {
        let email: Driver<String>
        let password: Driver<String>
        let loginButtonTap: Signal<Void>
    }

    struct Output {
        let loginAction: CocoaAction
        let loggedIn: Signal<Void>
        let error: Signal<Error>
        let isLoading: Driver<Bool>
    }

    func transform(input: Input) -> Output {
        let action = getLoginAction(input: input)
        let loggedIn = action.elements.asSignal(onErrorSignalWith: .never())
        let errors = action.underlyingError.asSignal(onErrorSignalWith: .never())
        let isLoading = action.executing.asDriver(onErrorDriveWith: .never())

        return Output(loginAction: action, loggedIn: loggedIn, error: errors, isLoading: isLoading)
    }
}

// MARK: - Private
private extension LoginViewModel {

    typealias LoginInfo = (email: String, password: String)

    func getLoginAction(input: Input) -> CocoaAction {
        let usernameAndPassword = Driver.combineLatest(input.email, input.password) { (email: $0, password: $1) }.asObservable()
        let enabledIf = Driver.combineLatest(input.email, input.password) { $0 != "" && $1 != "" }.asObservable()

        return CocoaAction(enabledIf: enabledIf, workFactory: { _ -> Observable<Void> in
            usernameAndPassword.flatMap { [unowned self] info in self.login(with: info) }
        })
    }

    func login(with info: LoginInfo) -> Observable<Void> {
        return unwrapResult(accountService.login(with: info.email, password: info.password))
            .do(onNext: { token in Storage.shared.accessToken = token }).map { _ in }
    }
}
