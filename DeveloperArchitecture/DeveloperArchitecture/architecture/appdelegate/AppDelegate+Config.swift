//
//  AppDelegate+Config.swift
//  DeveloperArchitecture
//
//  Created by Jeffrey on 2020/9/25.
//

import Foundation
import UIKit

extension AppDelegate {


    func funj_addRootMainViewController() {
        if #available(iOS 11.0, *) {
            UITableView.appearance().estimatedRowHeight = 0
            UITableView.appearance().estimatedSectionFooterHeight = 0;
            UITableView.appearance().estimatedSectionHeaderHeight = 0;
        }
        if(self.funj_isFirstLoadUserView()){
            // 第一次使用 出现引导页
            
        }
        funj_setupReachability()
    }
    func funj_isFirstLoadUserView() ->Bool{
        if UserDefaults.standard.bool(forKey: "everLaunched") {
            UserDefaults.standard.setValue(true, forKey: "everLaunched")
            UserDefaults.standard.setValue(true, forKey: "firstLaunch")
            UserDefaults.standard.synchronize()
        } else {
            UserDefaults.standard.setValue(false, forKey: "firstLaunch")
            UserDefaults.standard.synchronize()
        }
        return UserDefaults.standard.bool(forKey: "firstLaunch")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
    }
    
    // 处理网络状态情况
    func funj_setupReachability() {
        self.m_reachability = try? Reachability()
        do {
            try self.m_reachability?.startNotifier()
        } catch  {
            return
        }
//        NotificationCenter.default.addObserver(self, selector: #selector(funj_reachabilityChanged(_:)), name: .reachabilityChanged, object: nil)
    }
//    @objc func funj_reachabilityChanged(_ note: Notification) {
//        let reachability = note.object as! Reachability
//        print(reachability.connection)
//    }
}
