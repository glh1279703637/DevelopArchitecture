//
//  JLoginUserModel.swift
//  DeveloperArchitecture
//
//  Created by Jeffrey on 2020/9/29.
//  Copyright © 2020 Jeffery. All rights reserved.
//

import Foundation
import UIKit
import CoreData

public class JLoginUserModel : JBaseDataModel {
    static var m_userModel : UserLoginDB? = nil

    class func funj_insertLoginUserMessage(_ data : Dictionary<String,Any>) {
        if data["userId"] == nil || data.count <= 0 {
            return
        }
        
        let properyList = UserLoginDB.funj_allPropertyList()
        var dict : Dictionary<String,String> = Dictionary()
        for (k,v) in data {
            if properyList.contains(k) {
                dict[k] = "\(v)"
            }
        }
        let serverTime = JAppUtility.funj_getDateTime(nil)
        dict["serverTime"] = serverTime
        
        JCoreDataManager.shared.funj_insertMessageContext(UserLoginDB.fetchRequest(), dict, mainDic: ["userId":dict["userId"]!])
        self.funj_setUserDicData(true)
    }
    class func funj_getLastLoginUserMessage() -> UserLoginDB? {
        var loginModel : UserLoginDB? = nil
        if m_userModel != nil {
            loginModel = m_userModel
        }else {
            let userList = JCoreDataManager.shared.funj_getMessageContext(UserLoginDB.fetchRequest(), dict: nil, asc: nil, desc: "serverTime", limit: 1)
            
            if userList.count > 0 {
                loginModel = userList.first as? UserLoginDB
            }
        }
        
        return loginModel
    }
    class func funj_getLastLoginTokenMessage() -> String {
        var token : String = ""
        let loginModel = JLoginUserModel.funj_getLastLoginUserMessage()
        token = loginModel?.token ?? ""
        return token
    }
    class func funj_getIsLogining() -> Bool {
        var isLogining : Bool = false
        let loginModel = JLoginUserModel.funj_getLastLoginUserMessage()
        isLogining = loginModel?.isLogining == "1" ? true : false
        return isLogining
    }
    class func funj_deleteUserMessage(_ userId : String) {
        JCoreDataManager.shared.funj_deleteMessageContext(UserLoginDB.fetchRequest(), dict: ["userId":userId])
        self.funj_setUserDicData(true)
    }
    class func funj_setUserDicData(_ reload : Bool){
        if reload {
            m_userModel = nil
        }
    }
}

@objc(UserLoginDB)
public class UserLoginDB : NSManagedObject {
    public override class func fetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        return NSFetchRequest<NSFetchRequestResult>(entityName: "UserLoginDB")
    }
    
    @NSManaged public var account: String?
    @NSManaged public var isLogining: String?
    @NSManaged public var mySign: String?
    @NSManaged public var nickName: String?
    @NSManaged public var sex: String?
    @NSManaged public var originalPassCode: String?
    @NSManaged public var password: String?
    @NSManaged public var photoPath: String?
    @NSManaged public var serverTime: String?
    @NSManaged public var token: String?
    @NSManaged public var userId: String?
    @NSManaged public var userName: String?
}
