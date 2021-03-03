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
        
        let view : UIView = UIView(i: CGRectZero, bg: kColor_Red).funj_addCornerLayer2(JFilletValue(w: 3, r: 3, c: kColor_Red))
        
        let bt : UIButton = UIButton().funj_addCornerLayer(JFilletValue(w: 3, r: 3, c: kColor_Red)) as! UIButton
        
        
        print("\(view)  \(bt)")
        
        
        
    }

}
extension UIView {
    func funj_addCornerLayer2<T>(_ fillet : JFilletValue?) -> T{
        if fillet == nil || self.isKind(of: T.self as! AnyClass) == false { return self as! T }
        self.layer.borderWidth = fillet!.m_borderWidth
        self.layer.cornerRadius = fillet!.m_cornerRadius
        self.layer.borderColor = fillet!.m_borderColor?.cgColor
        if fillet!.m_cornerRadius >= 1.0 {
            self.layer.masksToBounds = true
        }
        return self as! T
    }
}
