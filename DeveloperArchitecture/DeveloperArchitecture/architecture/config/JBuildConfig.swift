//
//  JBuildConfig.swift
//  DeveloperArchitecture
//
//  Created by Jeffrey on 2020/9/25.
//

import Foundation
import UIKit

// 配置的plist 文件 内容
var kconfigInfoDic : NSDictionary? {
    let path = Bundle.main.path(forResource: "config", ofType: "plist")
    return NSDictionary(contentsOfFile: path!)
}

//接口URL 根路径
let  APP_URL_ROOT = String("\((kconfigInfoDic?["APP_ROOT_URL"])!)api/")

//当前是否为企业版
let kcurrentIsEEVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as! String  == "com.mizholdings.ZhiJiaoCloud"








