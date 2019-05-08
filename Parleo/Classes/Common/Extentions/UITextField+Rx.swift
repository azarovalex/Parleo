//
//  UITextField+Rx.swift
//  Parleo
//
//  Created by Alex Azarov on 4/30/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import RxSwift
import RxCocoa

extension UITextField {

    var textDriver: Driver<String> {
        return self.rx.text.orEmpty.distinctUntilChanged().asDriver { _ in .never() }
    }
}
