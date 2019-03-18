//
//  LoginViewModel.swift
//  Parleo
//
//  Created by Alex Azarov on 3/10/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import RxSwift
import RxCocoa

class LoginViewModel: ViewModelType {

    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    private let errorsRelay = PublishRelay<Error>()
    private let authorizationService = AuthorizationService(mockType: .delayed(1))

    struct Input {
        let email: Driver<String>
        let password: Driver<String>
        let loginButtonTap: Signal<Void>
    }

    struct Output {
        let loggedIn: Signal<Void>
        let error: Signal<Error>
        let isLoading: Driver<Bool>
        let isLoginButtonEnabled: Driver<Bool>
    }

    func transform(input: Input) -> Output {
        let isLoginButtonEnabled = Driver.combineLatest(input.email, input.password) { $0 != "" && $1 != "" }
        let loggedIn = getLoggedInSignal(input: input)

        return Output(loggedIn: loggedIn,
                      error: errorsRelay.asSignal(),
                      isLoading: isLoadingRelay.asDriver(),
                      isLoginButtonEnabled: isLoginButtonEnabled)
    }
}

// MARK: - Private
private extension LoginViewModel {

    func getLoggedInSignal(input: Input) -> Signal<Void> {
        let usernameAndPassword = Driver.combineLatest(input.email, input.password) { (email: $0, password: $1) }

        return input.loginButtonTap
            .withLatestFrom(usernameAndPassword)
            .do { [weak self] in self?.isLoadingRelay.accept(true) }
            .flatMap { pair in
                self.authorizationService.logIn(with: pair.email, password: pair.password)
                    .do { [weak self] in self?.isLoadingRelay.accept(false) }
                    .flatMap { result in
                        switch result {
                        case .success(let user):
                            Storage.shared.currentUser = user
                            return .just(())
                        case .failure(let error):
                            return .error(error)
                        } }
                    .asSignal(onErrorRecover: { error in
                        self.errorsRelay.accept(error)
                        return .never() }) }
    }
}
