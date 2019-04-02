//
//  NotificationsViewModel.swift
//  Parleo
//
//  Created by Alex Azarov on 3/31/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import RxSwift
import RxCocoa
import Action

class NotificationsViewModel: ViewModelType {

    private let cellsRelay = BehaviorRelay<[AppNotification]>(value: [])
    private let notificationsService = NotificationsService(mockType: .delayed(1))
    private let bag = DisposeBag()

    struct Input {}

    struct Output {
        let category: Driver<[AppNotification]>
        let errors: Signal<Error>
        let reloadAction: CocoaAction
    }

    func transform(input: Input) -> Output {
        let action = getCategoriesAction()
        action.execute()
        return Output(category: cellsRelay.asDriver(),
                      errors: action.underlyingError.asSignal { _ in .never() },
                      reloadAction: action)
    }
}

// MARK: - Private
private extension NotificationsViewModel {

    func getCategoriesAction() -> CocoaAction {
        return CocoaAction(workFactory: { [unowned self] in
            return unwrapResult(self.notificationsService.getNotifications())
                .do(onNext: { [unowned self] cells in self.cellsRelay.accept(cells) })
                .map { _ in }
        })
    }
}
