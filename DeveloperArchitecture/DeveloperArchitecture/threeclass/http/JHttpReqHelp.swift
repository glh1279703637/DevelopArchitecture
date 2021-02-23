//
//  JHttpReqHelp.swift
//  DeveloperArchitecture
//
//  Created by Jeffrey on 2020/11/1.
//  Copyright © 2020 Jeffery. All rights reserved.
//

import Foundation
import UIKit
typealias ksuccessRequest = ((_ viewController : UIViewController?,_ dataArr : [Any]?,_ dataDic :[String : Any]?)->())
typealias ksuccessModelRequest = ((_ viewController : UIViewController?,_ dataModel : JReqModel?)->())
typealias kfailureRequest = ((_ viewController : UIViewController?,_ error : String)->())


var httpRequestHelpDic : [String : JHttpReqHelp]  = [:]

class JHttpReqHelp : Operation {
//    open class var shared: JHttpReqHelp {
//        get {
//            if httpRequestHelp == nil {httpRequestHelp = JHttpReqHelp()}
//            return httpRequestHelp!
//        }
//    }
    var m_isHasViewController : Bool = false
    var m_viewController : UIViewController?
    var m_successCallback : ksuccessRequest?
    var m_successModelCallback : ksuccessModelRequest?
    var m_failureCallback : kfailureRequest?
    var m_dataTask : URLSessionTask?
    var m_httpKey : String?
    
    var m_dataModel : AnyClass?
    
    private var m_addVerify : Bool = false
    private var m_isMustLogin : Bool = false
    private var m_isSuccessShow : Bool = false
    
    class func funj_requestMessage(viewController : UIViewController?, _ subUrl : String ,parameter : [String : Any]?) -> JHttpReqHelp? {
        let urlStr = APP_URL_ROOT + subUrl
        let httpRequest = JHttpReqHelp.funj_getHttpHelp(url: urlStr, paramter: parameter)
        httpRequest?.m_viewController = viewController
        httpRequest?.m_isHasViewController = viewController == nil ? false : true
        _ = httpRequest?.funj_requestMessage(urlStr, parameter: parameter)
        return httpRequest
    }
    func funj_requestMessage(_ urlStr : String ,parameter : [String : Any]?) -> JHttpReqHelp? {
        guard let urlS = URL(string: urlStr) else {return nil}
        var request = URLRequest(url: urlS)
        request.timeoutInterval = 15.0
        
        if let parameterArr = JHttpReqHelp.funj_solverParameterToConnect(parameter) {
            request.httpMethod = "POST"
            let strings = parameterArr.joined(separator: "&")
            request.httpBody = strings.data(using: .utf8)
        }
        funj_dataTaskMessage(request)
        return self
    }
    func funj_add(success callback : @escaping ksuccessRequest) -> JHttpReqHelp {
        self.m_successCallback = callback
        return self
    }
    func funj_add(fail callback: @escaping kfailureRequest) -> JHttpReqHelp {
        self.m_failureCallback = callback
        return self
    }
    func funj_add(model : AnyClass , callback : @escaping ksuccessModelRequest) -> JHttpReqHelp {
        self.m_dataModel = model
        self.m_successModelCallback = callback
        return self
    }
    func funj_solveDataFromServer(_ data : Data){
        if let jsonObject = try? JSONSerialization.jsonObject(with: data, options:.allowFragments) {
            var dict = jsonObject as? [String : Any]
            if dict == nil || self.funj_VerifyIsSuccessful(dict!) == false { return }
            let data = dict!["data"]
            if data is [Any] {
                let array = dict!["data"] as? [Any]
                dict?.removeValue(forKey: "data")
                self.m_successCallback?(self.m_viewController,array,dict)
            } else {
                self.m_successCallback?(self.m_viewController,nil,dict)
            }
        } else {
            self.m_failureCallback?(self.m_viewController,kLocalStr("The server is abnormal. Please try again later"))
            JAppViewTools.funj_showTextToast(nil, message: kLocalStr("The server is abnormal. Please try again later"), time: 1)
        }
        self.funj_removeHttpHelp()
    }
}
extension JHttpReqHelp {
    class func funj_solverParameterToConnect(_ parameter : [String : Any]?) -> [String]? {
        var parameterArr : [String] = []
        if parameter?.count ?? 0 <= 0 { return nil}

        for (key , value) in parameter! {
            if value is Dictionary<String, Any> || value is Array<Any> {
                if let jsonData = try? JSONSerialization.data(withJSONObject: value, options: .prettyPrinted) {
                    var jsonStr = String(data: jsonData, encoding: .utf8)
                    jsonStr = jsonStr?.replacingOccurrences(of: "&", with: "%26")
                    parameterArr.append("\(key) = \(jsonStr!)")
                }
            } else {
                if value is String {
                    var value1 = (value as AnyObject).replacingOccurrences(of: "%", with: "%25")
                    value1 = (value1 as AnyObject).replacingOccurrences(of: "&", with: "%26")
                    parameterArr.append("\(key) = \(value1)")
                } else {
                    parameterArr.append("\(key) = \(value)")
                }
            }
        }
        return parameterArr
    }
    class func funj_getHttpHelp(url : String , paramter : [String : Any]? ) -> JHttpReqHelp? {
        var key = url
        if let value = JAppUtility.funj_stringFromObject(paramter) {
            key += value
        }
        key = JCryptHelp.funj_encryptMD5(key) ?? url
        var httpRequest = httpRequestHelpDic[key]
        if httpRequest == nil {
            httpRequest = JHttpReqHelp()
            httpRequest?.m_httpKey = key
            httpRequestHelpDic[key] = httpRequest
        }else {
            if httpRequest!.isCancelled || httpRequest!.isFinished {
                httpRequest = JHttpReqHelp()
                httpRequest?.m_httpKey = key
                httpRequestHelpDic[key] = httpRequest
            } else{
                httpRequest = nil
            }
        }
        return httpRequest
    }
    func funj_removeHttpHelp () {
        httpRequestHelpDic.removeValue(forKey: self.m_httpKey ?? "")
    }
    func funj_dataTaskMessage(_ request : URLRequest) {
        if JHttpReqHelp.funj_checkNetworkType() == false { return }
        (self.m_viewController as? JBaseViewController)?.funj_showProgressView()
        m_dataTask = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
            DispatchQueue.main.async { [weak self] in 
                (self?.m_viewController as? JBaseViewController)?.funj_closeProgressView()
                if (self?.m_isHasViewController ?? false) && self?.m_viewController == nil { return }
                if error == nil && data != nil {
                    self?.funj_solveDataFromServer(data!)
                } else {
                    self?.m_failureCallback?(self?.m_viewController,"")
                }
            }
        })
        m_dataTask?.resume()
    }
}
extension JHttpReqHelp {
    class func funj_checkNetworkType() ->Bool {
        let statue = try? Reachability().connection
        if statue == nil || statue == .unavailable {
            JAppViewTools.funj_showTextToast(nil, message: kLocalStr("The current network is not available, please check your network settings"), time: 2)
            return false
        }
        return true
    }
}

extension JHttpReqHelp {
    func funj_addVerify(isSuccessShow : Bool , isMustLogin : Bool) -> JHttpReqHelp {
        self.m_addVerify = true
        self.m_isMustLogin = isMustLogin
        self.m_isSuccessShow = isSuccessShow
        return self
    }
    func funj_VerifyIsSuccessful(_ dict : [String : Any]) -> Bool {
        if self.m_addVerify == false { return true}
        return JBaseInterfaceManager.funj_VerifyIsSuccessful(dict, isSuccessShow: self.m_isSuccessShow, viewcontroller: self.m_isMustLogin == true ? self.m_viewController : nil)
    }
}

