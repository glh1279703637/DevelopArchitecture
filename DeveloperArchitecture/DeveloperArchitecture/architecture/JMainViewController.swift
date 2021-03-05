//
//  JMainViewController.swift
//  DeveloperArchitecture
//
//  Created by Jeffrey on 2020/9/25.
//

import UIKit

@objcMembers
class JMainViewController: JBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view : UIView = UIView(i: CGRectZero, bg: kColor_Red).funj_addCornerLayer(JFilletValue(w: 3, r: 3, c: kColor_Red))
        
        let bt : UIButton = UIButton().funj_addCornerLayer(JFilletValue(w: 3, r: 3, c: kColor_Red)).funj_addblock { (b) in
            
        }.funj_saveBgColor([kColor_Blue])
        
        
        repeat {
            
        } while  3 > 4
        
        

        
    }

}
class Person {}
class Programmer : Person {}
class Nurse : Person {}


