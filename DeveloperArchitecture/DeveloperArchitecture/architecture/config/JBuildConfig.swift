//
//  JBuildConfig.swift
//  DeveloperArchitecture
//
//  Created by Jeffrey on 2020/9/25.
//

import Foundation
import UIKit

//接口URL 根路径
let  APP_URL_ROOT = String("\( Bundle.main.object(forInfoDictionaryKey: "APP_ROOT_URL") as! String )api/")

//当前是否为企业版
let kcurrentIsEEVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as! String  == "com.mizholdings.ZhiJiaoCloud"






