//
//  JMainViewController.swift
//  DeveloperArchitecture
//
//  Created by Jeffrey on 2020/9/25.
//

import UIKit

var mprogressHUD1 : JMainViewController? = nil

@objcMembers
class JMainViewController: UIViewController {

    let indexArr : String? = "323"
    let indexArr2 : String? = "323"
    open class var shared1: JMainViewController {
        get {
            if mprogressHUD1 == nil {
                mprogressHUD1 = JMainViewController()
            }
            return mprogressHUD1!
        }
    }
    static let shared2 = JCoreDataManager()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dic = ["nameStr" : "name","sexStr" : "M" , "ageInt" : "18"] as [String : Any]
        
    }
}
