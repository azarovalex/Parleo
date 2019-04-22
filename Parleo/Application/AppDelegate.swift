//
//  AppDelegate.swift
//  Parleo
//
//  Created by Alex Azarov on 2/22/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import UIKit
import RxSwiftExt
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupNavigationButtons()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.disabledToolbarClasses = [DemoChatViewController.self]
        IQKeyboardManager.shared.disabledTouchResignedClasses = [DemoChatViewController.self]
        IQKeyboardManager.shared.disabledDistanceHandlingClasses = [DemoChatViewController.self]
        return true
    }
}

// MARK: - Setup
private extension AppDelegate {

    func setupNavigationButtons() {
        UIBarButtonItem.appearance().setTitleTextAttributes([
            .font : R.font.montserratRegular(size: 16)!
        ], for: .normal)
        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: UIColor.black.withAlphaComponent(0.5),
            .font: R.font.montserratRegular(size: 18)!
        ]
    }
}


