//
//  JMainViewController.swift
//  DeveloperArchitecture
//
//  Created by Jeffrey on 2020/9/25.
//

import UIKit


@objcMembers
class JMainViewController: UIViewController,UITableViewDelegate{
    let indexArr : String? = "323"
    let indexArr2 : String? = "323"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = UserLoginDB ()
        
//        JAA.funj_bike()
        funj_bike()
        
        
//
//        JLoginUserMessage.funj_insertLoginUserMessage(["userId":123,"nickName":"1233"])
//        JLoginUserMessage.funj_insertLoginUserMessage(["userId":1231,"nickName":"123313"])
//        JLoginUserMessage.funj_insertLoginUserMessage(["userId":1232,"nickName":"123324"])
//        JLoginUserMessage.funj_insertLoginUserMessage(["userId":1233,"nickName":"123335"])

        let login = JLoginUserMessage.funj_getLastLoginUserMessage()
        
        print(login)
        type(of: self)
        let ss = self.classForCoder
        print(UIButton.classForCoder())
        print(self.classForCoder)

        
    }


}

