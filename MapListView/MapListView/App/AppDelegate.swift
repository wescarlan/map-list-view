//
//  AppDelegate.swift
//  MapListView
//
//  Created by Wesley on 4/19/19.
//  Copyright © 2019 Wesley. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static var window: UIWindow?

    var window: UIWindow? {
        get { return AppDelegate.window }
        set { AppDelegate.window = newValue }
    }
    
    static var navigationController: UINavigationController? {
        didSet {
            guard let window = window else { return }
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                window.rootViewController = navigationController
                window.makeKeyAndVisible()
            }, completion: nil)
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = Storyboard.main.instantiateInitialViewController()
        return true
    }
}

