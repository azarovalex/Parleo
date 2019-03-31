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

class EventsViewModel {
    // FIXME: Remove
    struct Event {
        let id: UUID
        let title: String
    }
    let events = BehaviorRelay<[Event]>(value: [])
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let addEvent: Signal<Void>
        let viewEvent: Signal<IndexPath>
        let filter: Signal<Void>
    }
    
    struct Output {
        let cells: Driver<[EventTableCellViewModel]>
        let addEvent: Signal<Void>
        let viewEvent: Signal<UUID> // FIXME: Use EventViewModel insted
    }
    
    func transform(input: Input) -> Output {
        let cellsDriver = events
            .asDriver()
            .map {
                $0.map{ EventTableCellViewModel(title: $0.title, description: $0.title) }
            }
        
        let viewEventSignal = input.viewEvent.map { [weak self] indexPath in
            self?.events.value[indexPath.row].id ?? UUID()
        }
        
        return Output(cells: cellsDriver,
                      addEvent: input.addEvent,
                      viewEvent: viewEventSignal)
    }
}
