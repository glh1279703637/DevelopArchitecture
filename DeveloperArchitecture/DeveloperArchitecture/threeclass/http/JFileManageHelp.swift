//
//  JFileManageHelp.swift
//  DeveloperArchitecture
//
//  Created by Jeffrey on 2020/11/12.
//  Copyright © 2020 Jeffery. All rights reserved.
//

import Foundation
protocol JFileManageHelpExtApi {
    static func funj_saveLocalData(_ fileName : String , content : Any) -> Bool
    
    static func funj_getLocalData(_ fileName : String) -> Any?
}

class JFileManageHelp : NSObject , JFileManageHelpExtApi{
    class func funj_saveLocalData(_ fileName : String , content : Any) -> Bool {
        let path = JAppUtility.funj_getTempPath("savefile", fileName: nil)
        if JAppUtility.funj_isFileExit(path) == false {
            _ = JAppUtility.funj_createDirector(path)
        }
        if content is [String : Any] || content is [Any] || content is String {
            let data = try? JSONSerialization.data(withJSONObject: content, options: .prettyPrinted)
            let ishas: ()? = try? data?.write(to: URL(fileURLWithPath: path))
            return (ishas != nil)
        }
        return false
    }
    class func funj_getLocalData(_ fileName : String) -> Any? {
        let path = JAppUtility.funj_getTempPath("savefile", fileName: nil)
        if JAppUtility.funj_isFileExit(path) == false {
            _ = JAppUtility.funj_createDirector(path)
        }
        let data = try? Data(contentsOf: URL(fileURLWithPath: path))
        if data != nil {
            let jsonObject = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
            return jsonObject
        }
        return nil
    }

}
