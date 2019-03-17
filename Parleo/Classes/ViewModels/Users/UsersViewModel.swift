//
//  UsersViewModel.swift
//  Parleo
//
//  Created by Alex Azarov on 3/18/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import RxSwift
import RxCocoa

class UsersViewModel: ViewModelType {

    struct Input {

    }

    struct Output {
        let cells: Driver<[Void]>
    }

    func transform(input: Input) -> Output {
        let cells = Driver.just([(), (), (), (), (), (), ()])
        return Output(cells: cells)
    }
}
