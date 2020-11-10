//
//  JHttpReqHelp+Model.swift
//  DeveloperArchitecture
//
//  Created by Jeffrey on 2020/11/2.
//  Copyright © 2020 Jeffery. All rights reserved.
//

import Foundation
import UIKit

class JHttpReqHelpM<T : Codable> : JHttpReqHelp {
    override func funj_solveDataFromServer(_ data : Data){
        let modelObject = try? JSONDecoder().decode(T.self, from: data)
        if modelObject != nil {
            self.m_successModelCallback?(self.m_viewController, modelObject as? JReqModel)
        } else {
            self.m_failureCallback?(self.m_viewController,kLocalStr("The server is abnormal. Please try again later"))
            JAppViewTools.funj_showTextToast(nil, message: kLocalStr("The server is abnormal. Please try again later"), time: 1)
        }
        self.funj_removeHttpHelp()
    }
}

public class JReqModel :NSObject, Codable {
    var result : Int?
    var msg : String?
    var data : Array<JBaseDataModel>?

//    public required init(from decoder: Decoder) throws {
//        if let container = try? decoder.container(keyedBy: CodingKeys.self) {
//            result = try container.decode(Int.self, forKey: .result)
//            msg = try container.decode(String.self, forKey: .msg)
//            data = try container.decode([JBaseDataModel].self, forKey: .data)
//        }
//    }
}
