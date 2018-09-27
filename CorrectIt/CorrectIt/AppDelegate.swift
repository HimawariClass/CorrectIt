//
//  AppDelegate.swift
//  CorrectIt
//
//  Created by Taillook on 2018/04/13.
//  Copyright © 2018年 HimawariClass. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: MainViewController())
        window!.makeKeyAndVisible()
        return true
    }
}

