//
//  JBaseInterfaceManager.swift
//  DeveloperArchitecture
//
//  Created by Jeffrey on 2020/10/30.
//  Copyright © 2020 Jeffery. All rights reserved.
//

import Foundation
import UIKit

class JBaseInterfaceManager: NSObject {
    class func funj_VerifyIsSuccessful(_ dict : [String : Any]? , isSuccessShow : Bool ,viewcontroller : UIViewController?) -> Bool {
        let msg = dict?["msg"] as? String ?? ""
        let result = dict?["result"] as? Int ?? -1
        if result == 0 {
            if isSuccessShow == true {
                if msg.count >= 15 {
                    _ = JAppViewTools.funj_showAlertBlock(message: msg)
                } else {
                    JAppViewTools.funj_showTextToast(nil, message: msg, time: 2)
                }
            }
            return true
        }else if result == 2 { // 未登录
            self.funj_didLogoutAccount()
            if viewcontroller != nil {
                JAppViewTools.funj_showTextToast(nil, message: "You are not logged in", time: 1) {
//                    viewcontroller.funj_getPresentVCWithController("JLogin_Register_ForgetItVC")
                }
            }
        }else {
            if msg.count >= 15 {
                _ = JAppViewTools.funj_showAlertBlock(message: msg)
            } else {
                JAppViewTools.funj_showTextToast(nil, message: msg, time: 2)
            }
        }
        return false
    }
    class func funj_didLogoutAccount() {
        let loginModel = JLoginUserModel.funj_getLastLoginUserMessage()
        if loginModel?.isLogining == "1" {
            JLoginUserModel.funj_insertLoginUserMessage(["userId":loginModel!.userId! ,"isLogining" : "0"])
        }
        
    }
}
