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
        registerForPushNotifications()
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print(deviceToken.reduce("") { $0 + String(format: "%02x", $1) })
    }

    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        guard url.scheme == "parleo", url.host == "verify_email" else { return false }
        var parameters: [String: String] = [:]
        URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?
            .forEach { parameters[$0.name] = $0.value }
        guard let token = parameters["token"] else { return false }
        let emailVerificationNavigationController = R.storyboard.emailVerification.instantiateInitialViewController()!
        let emailVerificationViewController = emailVerificationNavigationController.viewControllers.first as! EmailVerificationViewController
        emailVerificationViewController.emailVerificationToken = token
        UIApplication.shared.keyWindow?.rootViewController = emailVerificationNavigationController
        return true
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


