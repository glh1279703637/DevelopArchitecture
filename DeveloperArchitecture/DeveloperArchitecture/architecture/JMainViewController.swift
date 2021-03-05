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
        var m_seaidosd : Int = 0
        
        let view : UIView = UIView(i: CGRectZero, bg: kColor_Red).funj_addCornerLayer(JFilletValue(w: 3, r: 3, c: kColor_Red))
        
        let bt : UIButton = UIButton().funj_addCornerLayer(JFilletValue(w: 3, r: 3, c: kColor_Red)).funj_addblock { (b) in
            
        }.funj_saveBgColor([kColor_Blue])
        


        
    }
    func funj_reloadDataConfitesd (){
        
    }

}
class Person {}
class Programmer : Person {}
class Nurse : Person {}


