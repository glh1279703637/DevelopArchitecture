//
//  AppDelegate.swift
//  DeveloperArchitecture
//
//  Created by Jeffrey on 2020/9/26.
//  Copyright © 2020 Jeffery. All rights reserved.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    public var m_reachability: Reachability?
    let m_hostNames = [nil, "google.com", "invalidhost"]
    var m_hostIndex = 0
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        funj_addRootMainViewController()
        
        
//        推送通知
//        funj_registerAppNoticationSetting(lauchOption: launchOptions);
        
        
        
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration  {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }


}

