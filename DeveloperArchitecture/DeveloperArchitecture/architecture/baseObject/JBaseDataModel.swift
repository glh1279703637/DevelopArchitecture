//
//  JBaseDataModel.swift
//  DeveloperArchitecture
//
//  Created by Jeffrey on 2020/9/29.
//  Copyright © 2020 Jeffery. All rights reserved.
//

import Foundation

public class JBaseDataModel : NSObject {
    
    
    
    
    

}

extension NSObject {
    class func funj_propertyList() ->[String] {
        var m_count: UInt32 = 0
        var m_propertyList: [String] = []

        let list = class_copyPropertyList(self, &m_count)
        
        for i in 0..<Int(m_count) {
            let property = list?[i]
            let cName = property_getName(property!)
            let propertyName = String(utf8String: cName)
            m_propertyList.append(propertyName!)
        }
        return m_propertyList
    }
}
