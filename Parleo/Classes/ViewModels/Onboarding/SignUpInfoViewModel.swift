//
//  SignUpInfoViewModel.swift
//  Parleo
//
//  Created by Alex Azarov on 5/12/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import RxSwift
import RxCocoa
import Action

class SignUpInfoViewModel {

    private let userSerive = UserService()
    private var action: Action<UserUpdate, Void>!

    struct Input {
        let user: UserUpdate
    }

    struct Output {
        let isLoading: Driver<Bool>
        let error: Signal<Error>
        let navigate: Signal<Void>
    }

    func updateUser(user: UserUpdate) -> Output {
        let navigationRelay = PublishRelay<Void>()
        action = Action<UserUpdate, Void> { [unowned self] user in
            unwrapResult(self.userSerive.updateUser(newUser: user))
                .do(onNext: { navigationRelay.accept(()) })
        }
        action.execute(user)

        return Output(isLoading: action.executingDriver,
                      error: action.errorSignal,
                      navigate: navigationRelay.asSignal())
    }
}
