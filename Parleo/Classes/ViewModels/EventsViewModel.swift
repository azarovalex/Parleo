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
        let viewEvent: Signal<IndexPath>
    }
    
    struct Output {
        let cells: Driver<[EventTableCellViewModel]>
        let viewEvent: Signal<UUID> // FIXME: Use EventViewModel insted
    }
    
    func transform(input: Input) -> Output {
        events.accept([
            Event(id: UUID(), title: "Kate's Cafe"),
            Event(id: UUID(), title: "My Cafe"),
            Event(id: UUID(), title: "Your Cafe")
        ])
        let cellsDriver = events
            .asDriver()
            .map {
                $0.map{ EventTableCellViewModel(title: $0.title, description: $0.title, backgroungImage: R.image.katesCafe()!, flagImage: R.image.ukFlag()!) }
            }
        
        let viewEventSignal = input.viewEvent.map { [weak self] indexPath in
            self?.events.value[indexPath.row].id ?? UUID()
        }
        
        return Output(cells: cellsDriver,
                      viewEvent: viewEventSignal)
    }
}
