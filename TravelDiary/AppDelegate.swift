//
//  AppDelegate.swift
//  TravelDiary
//
//  Created by Heeral on 5/28/19.
//  Copyright © 2019 heeral. All rights reserved.
//

import UIKit
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let dataController = DataController.shared()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //load data controller
        dataController.load()
        
        // coustom appearance of all tab bars in the whole project
        UITabBar.appearance().barTintColor = .black
        UITabBar.appearance().tintColor = .orange
        UINavigationBar.appearance().tintColor = .orange
        // Override point for customization after application launch.
        
        return true
    }
    
    internal func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url as URL?,
                                                 sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                 annotation: options[UIApplication.OpenURLOptionsKey.annotation])
    }
}

