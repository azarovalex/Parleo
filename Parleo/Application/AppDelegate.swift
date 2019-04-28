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
//        Storage.shared.accessToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImFsZXhAYXphcm92LmJ5IiwianRpIjoiM2YwYThkMDgtNzY5Yy00NzA3LWIxZTQtZmJmOGVjZjdjNDhjIiwiZXhwIjoxNTU4OTY2NjI1fQ.QFCK0UjBxXejWAh4jAz-1qjvB-DftANon4sXA4eM7b0"
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


