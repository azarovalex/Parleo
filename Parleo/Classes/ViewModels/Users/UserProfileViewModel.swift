//
//  UserProfileViewModel.swift
//  Parleo
//
//  Created by Alex Azarov on 5/13/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import RxSwift
import RxCocoa
import Action

class UserProfileViewModel: ViewModelType {

    private let userService = UserService()
    private let isFriendRelay = BehaviorRelay<Bool>(value: false)
    private let bag = DisposeBag()

    private var userId: String!

    struct Input {
        let addFriendButtonTap: Signal<Void>
        let initialIsFriendState: Bool
        let userId: String
    }

    struct Output {
        let isLoading: Driver<Bool>
        let error: Signal<Error>
        let friendButtonTitle: Driver<String>
    }

    func transform(input: Input) -> Output {
        isFriendRelay.accept(input.initialIsFriendState)
        userId = input.userId
        let toggleFriendAction = getToggleFriendAction()
        input.addFriendButtonTap.map { [unowned self] in self.isFriendRelay.value }
            .emit(to: toggleFriendAction.inputs).disposed(by: bag)
        let friendButtonTitle = isFriendRelay.asDriver()
            .map { $0 ? "Remove Friend" : "Add Friend" }

        return Output(isLoading: toggleFriendAction.executingDriver,
                                 error: toggleFriendAction.errorSignal,
                                 friendButtonTitle: friendButtonTitle)
    }
}

// MARK: - Private
private extension UserProfileViewModel {

    func getToggleFriendAction() -> Action<Bool, Void> {
        return Action<Bool, Void> { [unowned self] isFriend in
            let request = isFriend ? self.userService.removeFriend(userId: self.userId) : self.userService.addFriend(userId: self.userId)
            return unwrapResult(request)
                .do(onNext: { [unowned self] in self.isFriendRelay.accept(!isFriend) })
        }
    }
}
