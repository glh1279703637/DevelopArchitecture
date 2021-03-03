//
//  JBaseDataModel.swift
//  DeveloperArchitecture
//
//  Created by Jeffrey on 2020/9/29.
//  Copyright © 2020 Jeffery. All rights reserved.
//

import Foundation
public class JBaseDataModel : NSObject,Codable {
    var m_nameStr : String?
    var m_sexStr : String?
    var m_ageInt : Int?
    public var account: String?
    
    init(json : [String : Any]?) {
        super.init()
        funj_resetJSonToModel(json)
    }
    func funj_resetJSonToModel(_ json : [String : Any]?){
        let propertyArr = JBaseDataModel.funj_allPropertyList()
        for varName in propertyArr { // 类似Int 的属性无法获取 ，需要注意
            if let name = json?[varName] {
                let propertyName = "m_" + varName
                self.setValue(name, forKey: propertyName)
            }
        }
    }
//    public required init(from decoder: Decoder) throws {
//        if let container = try? decoder.container(keyedBy: CodingKeys.self) {
//            var result = [String: Any]()
//            try container.allKeys.forEach { (key) throws in
//                result[key.stringValue] = try container.decode(JBaseDataModel.self, forKey: key).value
//            }
//            value = result
//        } else if var container = try? decoder.unkeyedContainer() {
//            var result = [Any]()
//            while !container.isAtEnd {
//                if let anyObject = try? container.decode(JBaseDataModel.self), let value = anyObject.value {
//                    result.append(value)
//                }
//            }
//            value = result
//        } else if let container = try? decoder.singleValueContainer() {
//            if let intVal = try? container.decode(Int.self) {
//                value = intVal
//            } else if let doubleVal = try? container.decode(Double.self) {
//                value = doubleVal
//            } else if let boolVal = try? container.decode(Bool.self) {
//                value = boolVal
//            } else if let stringVal = try? container.decode(String.self) {
//                value = stringVal
//            }else if container.decodeNil() {
//                value = nil
//            } else {
//                throw DecodingError.dataCorruptedError(in: container, debugDescription: "the container contains nothing serialisable")
//            }
//        } else {
//            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Could not serialise"))
//        }
//    }
}



extension NSObject {
    //获取对象所有属性名
    class func funj_allPropertyList() ->[String] {
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
    //获取对象所有属性名和属性值
    func funj_allPropertyAndNameList() -> [String : Any] {
        var count: UInt32 = 0
        let properties = class_copyPropertyList(self.classForCoder, &count)
        var resultDict: [String: Any] = [:]
        for i in 0..<Int(count) {
            let property = properties?[i]
            let name = property_getName(property!) // 取得属性名
            if let propertyName = String(utf8String: name) {
                if let propertyValue = self.value(forKey: propertyName) {// 取得属性值
                    resultDict[propertyName] = propertyValue as Any
                }
            }
        }
        return resultDict
    }
    //获取对象的所有方法名
    class func funj_allMethods() -> [String] {
        var count: UInt32 = 0
        let methods = class_copyMethodList(self, &count)
        var propertyList: [String] = []
        for i in 0..<Int(count) {
            guard let method = methods?[i] else { continue }
            let sel = method_getName(method)
            propertyList.append(NSStringFromSelector(sel))
//            let methodName = sel_getName(sel)
//            let argument = method_getNumberOfArguments(method!)
//            print("name: \(NSStringFromSelector(sel)), arguemtns: \(argument)")
        }
        return propertyList
    }
    //获取对象的成员变量名称
    class func funj_allMemberVariables() ->[String] {
        var count:UInt32 = 0
        let ivars = class_copyIvarList(self, &count)
        var result: [String] = []
        for i in 0..<Int(count) {
            guard let ivar = ivars?[i] else { continue }
            guard let name = ivar_getName(ivar) else { continue }
            if let varName = String(utf8String: name) {
                result.append(varName)
            }
        }
        return result
    }
}
