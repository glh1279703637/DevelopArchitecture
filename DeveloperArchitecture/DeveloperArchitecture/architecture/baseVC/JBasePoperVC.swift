//
//  JBasePoperVC.swift
//  DeveloperArchitecture
//
//  Created by Jeffrey on 2020/10/30.
//  Copyright © 2020 Jeffery. All rights reserved.
//

import Foundation
import UIKit
extension JBasePoperVC {
    class func funj_getPopoverVCs(sourceVC : UIViewController? = JAppViewTools.funj_getTopVC() , data : Any? = nil , size : CGSize = CGSize(width: KWidthMin - 100, height: KWidthMin - 100), callback : ksetPopverBaseVC? = nil) -> JBasePoperVC? {
        if JHttpReqHelp.funj_checkNetworkType() == false || sourceVC == nil { return nil}
        
        let controller = self.init()

        if let controller = controller as? JBaseViewController {
            controller.funj_setBaseControllerData(data)
            controller.m_currentShowVCModel = .kCURRENTISPRENTVIEW
        }
        var setPresentView = false
        callback?(controller , &setPresentView)
        controller.modalPresentationStyle = .overCurrentContext
        controller.modalTransitionStyle = .crossDissolve
        
        if setPresentView == false {
            var size = size
            size.width = min(size.width, KWidth - 20)
            size.height = min(size.height, KHeight - KStatusBarHeight - 30)
            
            let bgView = controller.m_bgView
            bgView.frame = CGRect(x: (KWidth - size.width)/2, y: (KHeight - size.height) / 2, width: size.width, height: size.height)
            bgView.layer.borderWidth = 0
            bgView.layer.cornerRadius = 10
            bgView.layer.masksToBounds = true
//            bgView.accessibilityFrame = bgView.frame
        }
        sourceVC?.present(controller, animated: true, completion: nil)
        return controller }
}

class JBasePoperVC : JBaseViewController {
    lazy var m_bgView : UIView = {
        let bgView = UIView(CGRect(x: 0, y: 0, width: KWidth, height: KHeight), bg: COLOR_WHITE)
        bgView.funj_whenTouchedDown { (sender) in
            sender.endEditing(true)
        }
        return bgView
    }()
    lazy var m_bgScrollView : UIScrollView = {
        let bgScrollView = UIScrollView(self.m_bgView.bounds, delegate: nil)
        self.m_bgView.addSubview(bgScrollView)
        return bgScrollView
    }()
    
    var m_clickOutRectToBack : Bool  = true
    
    private var m_bgImageView : UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        
        m_bgImageView = UIImageView(blackAlphaFrame: self.view.bounds)
        self.view.addSubview(m_bgImageView!)
        m_bgImageView?.funj_whenTapped { [weak self ] ( _ ) in
            if self?.m_clickOutRectToBack ?? false { self?.funj_clickBackButton() }
        }
        self.view.addSubview(m_bgView)
        
    }
}
