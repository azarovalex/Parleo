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

    var refresh: Observable<Void> { return refreshRelay.asObservable() }
    var loadNextPage: Observable<Void> { return loadNextPageRelay.asObservable() }
    let bag = DisposeBag()
}

extension UsersViewModel: ViewModelType {
    
    struct Input {
        let fetchNextPage: Signal<Void>
    }

    struct Output {
        let error: Signal<Error>
        let isPaginationLoading: Driver<Bool>
        let cells: Driver<[User]>
        let refreshAction: CocoaAction
    }

    func transform(input: Input) -> Output {
        input.fetchNextPage.emit(to: loadNextPageRelay).disposed(by: bag)

        let userService = UserService()
        let networkRequest: PaginationSink<User>.PaginationNetworkRequest = { page, pageSize in
            return userService.getUsers(page: page, pageSize: pageSize)
        }

        let paginationSink = PaginationSink(ui: self, request: networkRequest)
        paginationSink.isLoading.filter { $0 == false }.map { _ in }.bind(to: fetchingCompletedRelay).disposed(by: bag)
        return Output(error: paginationSink.error.asSignal { _ in .never() },
                      isPaginationLoading: paginationSink.isLoading.asDriver { _ in .never() },
                      cells: paginationSink.elements.do(onNext: { print($0.count) }).asDriver { _ in .never() },
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
