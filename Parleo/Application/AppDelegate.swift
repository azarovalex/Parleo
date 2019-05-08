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
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupNavigationButtons()
        IQKeyboardManager.shared.enable = true
//        Storage.shared.accessToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImFsZXhAYXphcm92LmJ5IiwianRpIjoiM2YwYThkMDgtNzY5Yy00NzA3LWIxZTQtZmJmOGVjZjdjNDhjIiwiZXhwIjoxNTU4OTY2NjI1fQ.QFCK0UjBxXejWAh4jAz-1qjvB-DftANon4sXA4eM7b0"
        registerForPushNotifications()
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print(deviceToken.reduce("") { $0 + String(format: "%02x", $1) })
    }

    func registerForPushNotifications() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, _ in
                guard granted else { return }
                self?.getNotificationSettings()
        }
    }

    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
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


