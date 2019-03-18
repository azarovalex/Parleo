//
//  ItemsListViewModel.swift
//  Parleo
//
//  Created by Artyom Shaiter on 3/4/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol ItemsListComformable: StringRepresentable, ImageRepresentable { }

class ItemsListViewModel {
    
    private let items = BehaviorRelay<[ItemsListComformable]>(value: [])
    
    struct Input {
        
    }
    
    struct Output {
        let cells: Driver<[ItemsListTableCellViewModel]>
    }
    
    func transform(input: Input) -> Output {
        let cellsDriver = items.asDriver()
            .map{ $0.map{ ItemsListTableCellViewModel(title: $0.text, image: $0.image, isSelected: false) }}
        return Output(cells: cellsDriver)
    }
}
