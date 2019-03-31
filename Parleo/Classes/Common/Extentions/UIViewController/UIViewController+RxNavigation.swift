//
//  UIViewController+RxNavigation.swift
//  Parleo
//
//  Created by Alex Azarov on 3/10/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import RxSwift
import RxCocoa
import Rswift
import SegueManager

extension Reactive where Base: SegueManagerViewController {

    func navigate<Segue, Destination, Value>(with segue: StoryboardSegueIdentifier<Segue, Base, Destination>,
                                             segueHandler: ((TypedStoryboardSegueInfo<Segue, Base, Destination>, Value) -> Void)? = nil) -> Binder<Value> {
        return Binder(self.base) { viewController, value in
            if let handler = segueHandler {
                viewController.performSegue(withIdentifier: segue) { handler($0, value) }
            } else {
                viewController.performSegue(withIdentifier: segue)
            }
        }
    }
}

extension UIViewController {

    @IBAction func close() {
        if let navigationController = navigationController, navigationController.viewControllers.count > 1 {
            navigationController.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
}
