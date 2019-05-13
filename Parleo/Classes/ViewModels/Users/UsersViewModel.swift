//
//  UsersViewModel.swift
//  Parleo
//
//  Created by Alex Azarov on 3/18/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import RxSwift
import RxCocoa
import Action

class UsersViewModel: PaginationUISource {
    private let loadNextPageRelay = PublishRelay<Void>()
    private let refreshRelay = PublishRelay<Void>()
    private let fetchingCompletedRelay = PublishRelay<Void>()
    private let userService = UserService()

    var refresh: Observable<Void> { return refreshRelay.asObservable() }
    var loadNextPage: Observable<Void> { return loadNextPageRelay.asObservable() }
    let bag = DisposeBag()
}

extension UsersViewModel: ViewModelType {
    
    struct Input {
        let fetchNextPage: Signal<Void>
        let screenConfiguration: UsersViewController.ScreenConfiguration
        let filter: BehaviorRelay<UsersFilter>
        let filterUpdated: Signal<Void>
    }

    struct Output {
        let error: Signal<Error>
        let isPaginationLoading: Driver<Bool>
        let cells: Driver<[User]>
        let refreshAction: CocoaAction
    }

    func transform(input: Input) -> Output {
        input.fetchNextPage.emit(to: loadNextPageRelay).disposed(by: bag)
        input.filterUpdated.emit(to: refreshRelay).disposed(by: bag)

        let networkRequest: PaginationSink<User>.PaginationNetworkRequest
        switch input.screenConfiguration {
        case .allUsers:
            networkRequest = { [unowned self] page, pageSize in
                self.userService.getUsers(page: page, pageSize: pageSize, filter: input.filter.value) }
        case .friends:
            networkRequest = { [unowned self] page, pageSize in
                self.userService.getFriends(page: page, pageSize: pageSize) }
        }

        let paginationSink = PaginationSink(ui: self, request: networkRequest)
        paginationSink.isLoading.filter { $0 == false }.map { _ in }.bind(to: fetchingCompletedRelay).disposed(by: bag)
        let cells = paginationSink.elements
            .asDriver { _ in .never() }
        return Output(error: paginationSink.error.asSignal { _ in .never() },
                      isPaginationLoading: paginationSink.isLoading.asDriver { _ in .never() },
                      cells: cells,
                      refreshAction: getRefreshAction())
    }
}

// MARK: - Private
private extension UsersViewModel {

    func getRefreshAction() -> CocoaAction {
        return CocoaAction(workFactory: { [unowned self] in
            self.refreshRelay.accept(())
            return self.fetchingCompletedRelay.asObservable().take(1)
        })
    }
}
