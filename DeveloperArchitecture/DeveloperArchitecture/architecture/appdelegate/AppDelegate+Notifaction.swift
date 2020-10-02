//
//  AppDelegate+Notifaction.swift
//  DeveloperArchitecture
//
//  Created by Jeffrey on 2020/9/25.
//

import Foundation
import UIKit
//import UserNotifications

extension AppDelegate : UNUserNotificationCenterDelegate{
    public func funj_registerAppNoticationSetting(lauchOption:[UIApplication.LaunchOptionsKey:Any]?){
        let notiCenter = UNUserNotificationCenter.current()
        notiCenter.delegate = self;
        let types = UNAuthorizationOptions(arrayLiteral: .alert,.badge,.sound)
        notiCenter.requestAuthorization(options: types) { (flag, error) in
            if flag {
                print("regist notifaction success")
            }
        }
        UIApplication.shared.registerForRemoteNotifications()
        
        print("ididid - -- ")
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let device = NSData(data: deviceToken)
        let deviceId  = device.description.replacingOccurrences(of: "<", with: "").replacingOccurrences(of: ">", with: "").replacingOccurrences(of: " ", with: "")
        print("token:\(deviceId)")
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound,.alert])
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
}
