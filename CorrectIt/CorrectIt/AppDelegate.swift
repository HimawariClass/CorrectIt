//
//  AppDelegate.swift
//  CorrectIt
//
//  Created by Taillook on 2018/04/13.
//  Copyright © 2018年 HimawariClass. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        do {
            _ = try Realm()
        } catch {
            var config = Realm.Configuration()
            config.deleteRealmIfMigrationNeeded = true
            _ = try! Realm(configuration: config)
        }
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: MainViewController())
        window!.makeKeyAndVisible()
        return true
    }
}

