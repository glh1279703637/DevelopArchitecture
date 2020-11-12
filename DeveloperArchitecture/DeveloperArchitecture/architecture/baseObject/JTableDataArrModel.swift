//
//  JTableDataArrModel.swift
//  DeveloperArchitecture
//
//  Created by Jeffrey on 2020/10/30.
//  Copyright © 2020 Jeffery. All rights reserved.
//

import Foundation

class JTableDataArrModel : JBaseDataModel {
    lazy var m_titleArr: [Any] = { return [] }()
    lazy var m_dataModelArr: [Any] = { return [] }()
    lazy var m_dataTypeArr: [String] = { return [] }()
    lazy var m_otherMarkArr: [Any] = { return [] }()
    
    func funj_setTypeForSection(_ section : Int , isOpen : Bool) {
        if section >= m_dataTypeArr.count {
            m_dataTypeArr.append(isOpen ? "1" : "0")
        } else {
            m_dataTypeArr[section] = isOpen ? "1" : "0"
        }
    }
    func funj_getDataWithSecton(_ section : Int) ->[Any] {
        if section < m_dataTypeArr.count && m_dataTypeArr[section] == "1" {
            return m_dataModelArr[section] as! [Any]
        } else {
            return []
        }
    }
    func funj_getTypeWithSection(_ section : Int) -> Bool {
        if m_dataTypeArr[section] == "1" { return true}
        return false
    }
}
