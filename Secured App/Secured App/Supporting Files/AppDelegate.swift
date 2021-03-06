//
//  AppDelegate.swift
//  Secured App
//
//  Created by Mateusz Bąk on 17/09/2020.
//  Copyright © 2020 Mateusz Bąk. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if ReverseEngineeringToolsChecker.isReverseEngineered() {
            fatalError("Stop using reverse engineering tools")
        }
        
        guard let didApplicationFirstLaunched = UserDefaults.standard.value(forKey: "firstLaunchOfTheApplication") as? Bool, didApplicationFirstLaunched else {
            UserDefaults.standard.set(true, forKey: "firstLaunchOfTheApplication")
            try? KeychainWrapper(keychainOperations: KeychainOperations()).delete(account: Configurator.sessionIdDatabaseKey)
            return true
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
