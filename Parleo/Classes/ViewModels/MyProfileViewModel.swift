//
//  MyProfileViewModel.swift
//  Parleo
//
//  Created by Alex Azarov on 4/27/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import RxSwift
import RxCocoa
import Action

class MyProfileViewModel {

    private let bag = DisposeBag()
}

extension MyProfileViewModel: ViewModelType {

    struct Input {
        let viewWillAppear: Signal<Void>
    }

    struct Output {
        let user: Signal<User>
        let isLoading: Driver<Bool>
        let error: Signal<Error>
    }

    func transform(input: Input) -> Output {
        let fetchUserAction = getFetchUserAction()
        input.viewWillAppear.asObservable().take(1).bind(to: fetchUserAction.inputs).disposed(by: bag)
        LocationUpdater.shared.startUpdatingLocation()
        return Output(user: fetchUserAction.elements.asSignal { _ in .never() },
                      isLoading: fetchUserAction.executing.asDriver { _ in .never() },
                      error: fetchUserAction.underlyingError.asSignal { _ in .never() })
    }
}

// MARK: - Private
private extension MyProfileViewModel {

    func getFetchUserAction() -> Action<Void, User> {
        let userService = UserService()
        return Action(workFactory: { unwrapResult(userService.getMyProfile()) })
    }
}
