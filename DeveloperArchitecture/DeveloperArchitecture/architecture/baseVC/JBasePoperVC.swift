//
//  JBasePoperVC.swift
//  DeveloperArchitecture
//
//  Created by Jeffrey on 2020/10/30.
//  Copyright © 2020 Jeffery. All rights reserved.
//

import Foundation
import UIKit

protocol JBasePoperVCExtApi {
    static func funj_getPopoverVCs(sourceVC : UIViewController? , data : Any? , size : CGSize, callback : ksetPopverBaseVC? ) -> JBasePoperVC?
}

extension JBasePoperVC : JBasePoperVCExtApi{
    class func funj_getPopoverVCs(sourceVC : UIViewController? = JAppViewTools.funj_getTopVC() , data : Any? = nil , size : CGSize = CGSize(width: kWidthMin - 100, height: kWidthMin - 100), callback : ksetPopverBaseVC? = nil) -> JBasePoperVC? {
        if JHttpReqHelp.funj_checkNetworkType() == false || sourceVC == nil { return nil}
        
        let controller = self.init()

        controller.funj_setBaseControllerData(data)
        controller.m_currentShowVCModel = .kcurrentIsPopover
        
        var setPresentView = false
        callback?(controller , &setPresentView)
        controller.modalPresentationStyle = .overCurrentContext
        controller.modalTransitionStyle = .crossDissolve
        
        if setPresentView == false {
            var size = size
            size.width = min(size.width, kWidth - 20)
            size.height = min(size.height, kHeight - kStatusBarHeight - 30)
            
            let bgView = controller.m_BgView
            bgView.frame = CGRect(x: (kWidth - size.width)/2, y: (kHeight - size.height) / 2, width: size.width, height: size.height)
            bgView.layer.borderWidth = 0
            bgView.layer.cornerRadius = 10
            bgView.layer.masksToBounds = true
//            bgView.accessibilityFrame = bgView.frame
        } else {
            controller.m_currentShowVCModel = .kcurrentIsprentview
        }
        sourceVC?.present(controller, animated: true, completion: nil)
        return controller }
}

class JBasePoperVC : JBaseViewController {
    lazy var m_BgView : UIView = {
        let bgView = UIView(i: CGRect(x: 0, y: 0, width: kWidth, height: kHeight), bg: kColor_White)
        bgView.funj_whenTouchedDown { (sender) in
            sender.endEditing(true)
        }
        return bgView
    }()
    lazy var m_BgScrollView : UIScrollView = {
        let bgScrollView = UIScrollView(i: self.m_BgView.bounds, delegate: nil)
        self.m_BgView.addSubview(bgScrollView)
        return bgScrollView
    }()
    
    var m_clickOutRectToBack : Bool  = true
    
    private var m_BgImageView : UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        
        m_BgImageView = UIImageView(i_blackAlpha: self.view.bounds)
        self.view.addSubview(m_BgImageView!)
        m_BgImageView?.funj_whenTapped { [weak self ] ( _ ) in
            if self?.m_clickOutRectToBack ?? false { self?.funj_clickBackButton() }
        }
        self.view.addSubview(m_BgView)
        
    }
}
