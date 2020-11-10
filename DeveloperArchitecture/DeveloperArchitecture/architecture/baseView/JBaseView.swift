//
//  JBaseView.swift
//  DeveloperArchitecture
//
//  Created by Jeffrey on 2020/9/30.
//  Copyright © 2020 Jeffery. All rights reserved.
//

import UIKit

public class JBaseView : UIView {
    lazy var m_mbProgressHUD : JProgressHUD = {
        let mbProgressHUD = JProgressHUD(frame : CGRectZero)
        return mbProgressHUD
    }()
    func funj_showProgressView() {
        m_mbProgressHUD.funj_showProgressView(nil)
    }
     func funj_closeProgressView() {
        m_mbProgressHUD.funj_stopProgressView()
    }
}
//extension UIView {
//    func funj_showProgressView() {}
//    func funj_closeProgressView() {}
//}
