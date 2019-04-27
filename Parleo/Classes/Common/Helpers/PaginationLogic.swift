//
//  PaginationLogic.swift
//  Parleo
//
//  Created by Alex Azarov on 4/27/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import RxSwift
import ObjectMapper

protocol PaginationUISource {
    var loadNextPage: Observable<Void> { get }
    var refresh: Observable<Void> { get }
    var bag: DisposeBag { get }
}

struct PaginationSink<Item: BaseMappable> {

    typealias PaginationNetworkRequest = (_ page: Int, _ pageSize: Int) -> Single<Result<PagedResponse<Item>>>

    let isLoading: Observable<Bool>
    let elements: Observable<[Item]>
    let error: Observable<Error>
}

extension PaginationSink {

    init(ui: PaginationUISource, request: @escaping PaginationNetworkRequest) {
        let defaultPageSize = 5

        let loadResults = BehaviorSubject<[Int: [Item]]>(value: [:])

        var totalCount = 0
        var currentCount = 0

        let reload = ui.refresh
            .do(onNext: { currentCount = 0 })
            .map { -1 }

        let maxPage = loadResults.map { $0.keys }.map { $0.max() ?? 1 }

        let loadNext = ui.loadNextPage
            .filter { currentCount < totalCount }
            .withLatestFrom(maxPage).map { $0 + 1 }
            .share()

        let start = Observable.merge(reload, loadNext, Observable.just(1))

        let page = start
            .flatMap { page -> Observable<Event<(pageNumber: Int, items: [Item])>> in
                let videos = unwrapResult(request(page == -1 ? 1 : page, defaultPageSize))
                    .do(onNext: { response in
                        totalCount = response.totalAmount
                        currentCount += response.items.count })
                    .map { $0.items }

                return Observable.combineLatest(Observable.just(page), videos) { (pageNumber: $0, items: $1) }
                    .materialize()
                    .filter { $0.isCompleted == false } }
            .share()

        page
            .map { $0.element }.filter { $0 != nil }.map { $0! }
            .withLatestFrom(loadResults) { (pages: $1, newPage: $0) }
            .map { $0.newPage.pageNumber == -1 ? [1: $0.newPage.items] : $0.pages.merging([$0.newPage], uniquingKeysWith: { $1 }) }
            .bind(to: loadResults)
            .disposed(by: ui.bag)

        isLoading = Observable.merge(start.map { _ in 1 }, page.map { _ in -1 })
            .scan(0, accumulator: +).map { $0 > 0 }
        elements = loadResults.map { $0.sorted(by: { $0.key < $1.key }).flatMap { $0.value } }
        error = page.map { $0.error }.filter { $0 != nil }.map { $0! }
    }
}

