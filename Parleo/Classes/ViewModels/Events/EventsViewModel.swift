//
//  EventsViewModel.swift
//  Parleo
//
//  Created by Artyom Shaiter on 3/18/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Action

class EventsViewModel {
    enum Content: Int {
        case allEvents
        case myEvents
    }
    
    struct PagingSource: PaginationUISource {
        let refreshRelay = PublishRelay<Void>()
        let loadNextPageRelay = PublishRelay<Void>()
        let bag = DisposeBag()
        
        var loadNextPage: Observable<Void> { return loadNextPageRelay.asObservable() }
        var refresh: Observable<Void> { return refreshRelay.asObservable() }
    }
    
    private var events = BehaviorRelay<[ParleoEvent]>(value: [])
    private let allEvents = BehaviorRelay<[ParleoEvent]>(value: [])
    private let myEvents = BehaviorRelay<[ParleoEvent]>(value: [])
    private let fetchingCompletedRelay = PublishRelay<Void>()
    private var paginationSink: PaginationSink<ParleoEvent>!
    
    private let allEventsPagingSource = PagingSource()
    private let userEventsPagingSource = PagingSource()
    let bag = DisposeBag()
    
    private var contentMode = Content.allEvents
    
    struct Input {
        let viewEvent: Signal<IndexPath>
        let fetchNextPage: Signal<Void>
        let changeContent: Signal<Content>
    }
    
    struct Output {
        let cells: Driver<[EventTableCellViewModel]>
        let viewEvent: Signal<ParleoEvent>
        let refreshAction: CocoaAction
    }
    
    func transform(input: Input) -> Output {
        input.fetchNextPage.emit(onNext: { [weak self] in
            guard let self = self else { return }
            switch self.contentMode {
            case .allEvents: self.allEventsPagingSource.loadNextPageRelay.accept(())
            case .myEvents: self.userEventsPagingSource.loadNextPageRelay.accept(())
            }
        }).disposed(by: bag)
        
        let eventsService = EventsService()
        let allEventsRequest: PaginationSink<ParleoEvent>.PaginationNetworkRequest = { page, pageSize in
            return eventsService.fetchParleoEvents(page: page, pageSize: pageSize)
        }
        
        let userService = UserService()
        let currentUserEventsRequest: PaginationSink<ParleoEvent>.PaginationNetworkRequest = { page, pageSize in
            return userService.fetchCurrentUserEvents(page: page, pageSize: pageSize)
        }
        
        let allEventsPaginationSink = PaginationSink(ui: allEventsPagingSource, request: allEventsRequest)
        allEventsPaginationSink.isLoading.filter { $0 == false }.map { _ in }.bind(to: fetchingCompletedRelay).disposed(by: bag)
        
        let userEventsPaginationSink = PaginationSink(ui: userEventsPagingSource, request: currentUserEventsRequest)
        userEventsPaginationSink.isLoading.filter { $0 == false }.map { _ in }.bind(to: fetchingCompletedRelay).disposed(by: bag)
        
        input.changeContent
            .asObservable()
            .bind { [weak self] content in
                self?.contentMode = content
                let pagingSource = content == .allEvents ? self?.allEventsPagingSource : self?.userEventsPagingSource
                self?.paginationSink = content == .allEvents ? allEventsPaginationSink : userEventsPaginationSink
                pagingSource?.refreshRelay.accept(())
            }.disposed(by: bag)
        
        let cellsDriver = Observable.of(allEventsPaginationSink.elements, userEventsPaginationSink.elements).merge()
            .asDriver(onErrorDriveWith: .never())
            .map {
                $0.map{ EventTableCellViewModel(title: $0.title, description: $0.description, backgroungImageURL: $0.eventImageURL, flagImage: R.image.fr()!) }
            }
        
        let viewEventSignal = Observable.combineLatest(input.viewEvent.asObservable(), paginationSink.elements)
            .map { indexPath, events in
                events[indexPath.row]
            }
            .asSignal(onErrorSignalWith: .never())
        
        return Output(cells: cellsDriver,
                      viewEvent: viewEventSignal,
                      refreshAction: getRefreshAction())
    }
    
    func getRefreshAction() -> CocoaAction {
        return CocoaAction(workFactory: { [unowned self] in
            switch self.contentMode {
            case .allEvents: self.allEventsPagingSource.refreshRelay.accept(())
            case .myEvents: self.userEventsPagingSource.refreshRelay.accept(())
            }
            return self.fetchingCompletedRelay.asObservable().take(1)
        })
    }
}
