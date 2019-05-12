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

class EventsViewModel: PaginationUISource {
    enum Content: Int {
        case allEvents
        case myEvents
    }
    
    private var events = BehaviorRelay<[ParleoEvent]>(value: [])
    private let allEvents = BehaviorRelay<[ParleoEvent]>(value: [])
    private let myEvents = BehaviorRelay<[ParleoEvent]>(value: [])
    private let refreshRelay = PublishRelay<Void>()
    private let loadNextPageRelay = PublishRelay<Void>()
    private let fetchingCompletedRelay = PublishRelay<Void>()
    
    var loadNextPage: Observable<Void> { return loadNextPageRelay.asObservable() }
    var refresh: Observable<Void> { return refreshRelay.asObservable() }
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
        input.fetchNextPage.emit(to: loadNextPageRelay).disposed(by: bag)
        
        input.changeContent
            .asObservable()
            .bind { [weak self] content in
                self?.contentMode = content
                self?.refreshRelay.accept(())
            }.disposed(by: bag)
        
        let eventsService = EventsService()
        let networkRequest: PaginationSink<ParleoEvent>.PaginationNetworkRequest = { page, pageSize in
            return eventsService.fetchParleoEvents(page: page, pageSize: pageSize)
        }
        
        let paginationSink = PaginationSink(ui: self, request: networkRequest)
        paginationSink.isLoading.filter { $0 == false }.map { _ in }.bind(to: fetchingCompletedRelay).disposed(by: bag)
        
        let cellsDriver = paginationSink.elements
            .asDriver(onErrorDriveWith: .never())
            .map {
                $0.map{ EventTableCellViewModel(title: $0.title, description: $0.description, backgroungImageURL: $0.eventImageURL, flagImage: R.image.ukFlag()!) }
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
            self.refreshRelay.accept(())
            return self.fetchingCompletedRelay.asObservable().take(1)
        })
    }
}
