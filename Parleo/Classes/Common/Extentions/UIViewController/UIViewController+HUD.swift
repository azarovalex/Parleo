//
//  UIViewController+HUD.swift
//  Parleo
//
//  Created by Alex Azarov on 3/10/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import Foundation
import PKHUD
import RxSwift
import RxCocoa

extension Reactive where Base: UIViewController {

    var isLoading: Binder<Bool> {
        return Binder(self.base) { viewController, isLoading in
            isLoading ? HUD.show(.progress) : HUD.hide()
        }
    }

    var viewWillAppear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewWillAppear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }

    func isLoading(onView view: UIView) -> Binder<Bool> {
        return Binder(self.base) { viewController, isLoading in
            isLoading ? HUD.show(.progress, onView: view) : HUD.hide()
        }
    }

    func flash(type: HUDContentType) -> Binder<Void> {
        return Binder(self.base) { viewController, _ in
            HUD.flash(type)
        }
    }
}
