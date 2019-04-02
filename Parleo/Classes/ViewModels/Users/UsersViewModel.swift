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

class UsersViewModel: ViewModelType {

    private let bag = DisposeBag()

    struct Input {

    }

    struct Output {
        let cells: Driver<[Void]>
        let refreshAction: CocoaAction
    }

    func transform(input: Input) -> Output {
        let cellsRelay = BehaviorRelay<[()]>(value: [])
        let action = CocoaAction { [unowned self] in
            let cells = Driver.just([(), (), (), (), (), (), (), (), (), (), (), ()])
                .delay(1)
            cells.drive(cellsRelay).disposed(by: self.bag)
            return cells.asObservable().map { _ in }
        }
        action.execute()
        return Output(cells: cellsRelay.asDriver(), refreshAction: action)
    }
}
