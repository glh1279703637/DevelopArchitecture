//
//  JBaseViewController.swift
//  DeveloperArchitecture
//
//  Created by Jeffrey on 2020/9/30.
//  Copyright © 2020 Jeffery. All rights reserved.
//

import UIKit
typealias ksetBaseVC = ((_ vc : UIViewController) ->())
typealias ksetPopverBaseVC = ((_ vc : UIViewController , _ isPresentView : inout Bool) ->())

enum SHOWMODELTYPE {
    case kCURRENTISNONE //无
    case kCURRENTISPUSH // nav push
    case kCURRENTISPRENTVIEW //present
    case kCURRENTISSHOWDETAIL // split detail
    case kCURRENTISPOPOVER // pop
}

public class JBaseViewController : UIViewController ,UIPopoverPresentationControllerDelegate {
    //用于传数据所用
    lazy var m_dataString : String = { return "" }()
    lazy var m_dataArray : [Any] = { return [] }()
    lazy var m_dataDic : [String:Any] = { return [:] }()
    
    lazy var m_mbProgressHUD : JProgressHUD = {
        let mbProgressHUD = JProgressHUD(frame : CGRectZero)
        return mbProgressHUD
    }()
    
    //当前是否通过 presentViewController 显示的VC  default is no
    var m_currentShowVCModel : SHOWMODELTYPE?
    
    //当前是否需要通过手势返回上层的界面 default is yes
    var m_currentPushIsNeedinteractivePopGestureRecognizer : Bool?
    
    // 界面跳转push 或者present 时动画跳转
    var m_pushOrPresentAnimateClass : JBaseTransition.Type?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        funj_reloadBaseConfig()
    }
    
    func funj_addBackButton(image : String?) -> UIButton{
        let backBt = UIButton(i: CGRect(x: 0, y: kStatusBarHeight, width: 50, height: 44), title: nil, textFC: JTextFC())
            .funj_add(bgImageOrColor: image != nil ? [image as Any] : ["backBt"], isImage: true)
            .funj_add(targe: self, action: "funj_clickBackButton:", tag: 8800)
        self.view.addSubview(backBt)
        return backBt
    }
}
extension JBaseViewController {
    func funj_showProgressView() {
        m_mbProgressHUD.funj_showProgressView(nil)
    }
    func funj_closeProgressView() {
        m_mbProgressHUD.funj_stopProgressView()
    }
    func funj_setBaseControllerData(_ data : Any?){
        if let data = data as? String {
            m_dataString += data
        }else if let data = data as? [Any] {
            m_dataArray += data as [Any]
        }else if let data = data as? [String : Any]  {
            data.forEach {[weak self] (k,v) in
                self?.m_dataDic[k] = v
            }
        }
    }
    func funj_setPresentIsPoperView(_ controller : UIViewController,size : CGSize ,target : UIView?) {
        controller.modalPresentationStyle = .popover//配置推送类型
        controller.preferredContentSize = size //设置弹出视图大小必须好推送类型相
        let pover = controller.popoverPresentationController
        if target != nil {
            pover?.sourceRect = target!.bounds
            pover?.sourceView = target
        } else {
            var views = self.view
            if self.navigationController != nil && self.navigationController?.view != nil {
                views = self.navigationController?.view
            }
            pover?.sourceRect = views!.bounds //弹出视图显示位置
            pover?.sourceView = views //设置目标视图，这两个是必须设置的。
            pover?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        }
        if let nav = controller as? UINavigationController {
            pover?.delegate = nav.viewControllers.last as? UIPopoverPresentationControllerDelegate
        } else {
            pover?.delegate = controller as? UIPopoverPresentationControllerDelegate
        }
    }
    func funj_getPresentVC(className : UIViewController.Type , title : String? = nil , data : Any? = nil , isNav : Bool = false, callback : ksetBaseVC? = nil) -> UIViewController? {
        if JHttpReqHelp.funj_checkNetworkType() == false { return nil}
        let controller = className.init() as UIViewController
        controller.title = title
        if let controller = controller as? JBaseViewController {
            controller.funj_setBaseControllerData(data)
            controller.m_currentShowVCModel = .kCURRENTISPRENTVIEW
        }
        controller.modalTransitionStyle = .crossDissolve
        var nav : JBaseNavigationVC? = nil
        if isNav {
            nav = JBaseNavigationVC(rootViewController: controller)
            nav?.modalPresentationStyle = .fullScreen
        } else {
            controller.modalPresentationStyle = .fullScreen
        }
        callback?(controller)
        self.present((isNav ? nav! : controller), animated: true, completion: nil)
        return controller }
    
    func funj_getPushVC(className : UIViewController.Type , title : String? = nil , data : Any? = nil , callback : ksetBaseVC? = nil ) -> UIViewController? {
        if JHttpReqHelp.funj_checkNetworkType() == false { return nil}
        let controller = className.init() as UIViewController
        controller.title = title
        if let controller = controller as? JBaseViewController {
            controller.funj_setBaseControllerData(data)
            controller.m_currentShowVCModel = .kCURRENTISPUSH
        }
        controller.modalTransitionStyle = .crossDissolve

        callback?(controller)
        self.navigationController?.pushViewController(controller, animated: true)
        return controller }

    func func_replacePushVC(className : UIViewController.Type , title : String? = nil , data : Any? = nil , callback : ksetBaseVC? = nil) -> UIViewController? {
        if JHttpReqHelp.funj_checkNetworkType() == false { return nil}
        let nav = self.navigationController
        let controller = className.init() as UIViewController
        controller.title = title
        
        if let controller = controller as? JBaseViewController {
            controller.funj_setBaseControllerData(data)
            controller.m_currentShowVCModel = .kCURRENTISPRENTVIEW
            if let vc = nav?.children.last as? JBaseViewController{
                controller.m_currentShowVCModel = vc.m_currentShowVCModel
                if vc.m_currentShowVCModel == .kCURRENTISPRENTVIEW {
                    controller.modalTransitionStyle = .crossDissolve
                }
            }
        }
        var array = nav?.children
        array?.removeLast()
        array?.append(controller)
        nav?.setViewControllers(array!, animated: false)

        return controller }
    
    func funj_getPopoverVC(className : UIViewController.Type , target : UIView? , data : Any? = nil, isNav : Bool = false, size : CGSize , callback : ksetPopverBaseVC?) -> UIViewController? {
        if JHttpReqHelp.funj_checkNetworkType() == false { return nil}
        let controller = className.init() as UIViewController
        if let controller = controller as? JBaseViewController {
            controller.funj_setBaseControllerData(data)
            controller.m_currentShowVCModel = .kCURRENTISPOPOVER
        }
        var nav : JBaseNavigationVC? = nil
        if isNav {
            nav = JBaseNavigationVC(rootViewController: controller)
        }
        var setPresentView = false
        callback?(controller , &setPresentView)
        if setPresentView == false {
            self.funj_setPresentIsPoperView(( isNav ? nav! : controller ), size: size, target: target)
        } else {
            if isNav {
                nav?.modalPresentationStyle = .fullScreen //配置present类型
            } else {
                controller.modalPresentationStyle = .fullScreen //配置present类型
            }
            (controller as? JBaseViewController)?.m_currentShowVCModel = .kCURRENTISPRENTVIEW
        }
        
        self.present((isNav ? nav! : controller), animated: true, completion: nil)
        return controller }

    @objc func funj_clickBackButton(_ sender : UIButton? = nil ){
        JAppViewTools.funj_getKeyWindow()?.endEditing(true)
        var presentedVC = self.presentedViewController
        while presentedVC?.presentedViewController != nil {
            presentedVC = presentedVC?.presentedViewController
        }
        self.funj_closeProgressView()
        if presentedVC == nil {
            self.funj_backViewController()
        }else {
            self.funj_disMissViewController(presentedVC)
        }
    }
    func funj_backViewController() {
        if(self.m_currentShowVCModel == .kCURRENTISPUSH){
            self.navigationController?.popViewController(animated: true)
        }else if(self.m_currentShowVCModel == .kCURRENTISPRENTVIEW){
            self.dismiss(animated: true, completion: nil)
        }else if(self.m_currentShowVCModel == .kCURRENTISSHOWDETAIL){
            
        }else if(self.m_currentShowVCModel == .kCURRENTISPOPOVER){
            self.dismiss(animated: true, completion: nil)
        }
    }
    func funj_disMissViewController(_ presentedVC : UIViewController?) {
        if (presentedVC == self || presentedVC == self.navigationController ) == false {
            if let presentingVC = presentedVC?.presentingViewController {
                presentedVC?.dismiss(animated: false, completion: { [weak  self , presentingVC] in
                    self?.funj_disMissViewController(presentingVC)
                })
            }
        }
    }
}
extension JBaseViewController {
     func funj_reloadBaseConfig() {
//        self.edgesForExtendedLayout = UIRectEdgeNone ////可以解决ios7.0的上移的问题
//        self.extendedLayoutIncludesOpaqueBars = false //根view在bar不透明情况下，是否允许延伸(YES：允许延伸)
        self.modalPresentationCapturesStatusBarAppearance = false
        
        if self.m_currentShowVCModel != .kCURRENTISSHOWDETAIL {
            let nav = self.navigationController as? JBaseNavigationVC
            var icon = "backBt"
            if nav != nil && nav!.m_currentNavColor == .kCURRENTISWHITENAV_Tag {
                icon = "backBt2"
            }

            let backBt = UIBarButtonItem(i: nil, image: icon, setButton: { (button) in
                button.contentHorizontalAlignment = .left
            }, target: self, action: "funj_clickBackButton:")
            self.navigationItem.leftBarButtonItems = [backBt]
        }
        self.view.backgroundColor = kColor_White_Dark
        self.setNeedsStatusBarAppearanceUpdate()

//        NotificationCenter.default.addObserver(self, selector: #selector(funj_keyboardWillChangeFrame(_ :)), name: UITextView.textDidChangeNotification  , object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(funj_keyboardWillChangeFrame(_ :)), name: UITextField.textDidChangeNotification  , object: nil)

    }
    public override var prefersStatusBarHidden: Bool { //设置是否隐藏
        return false
    }
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    public override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .none
    }
    public override var shouldAutorotate: Bool {
        return true
    }
    public override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        return .portrait
    }
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
}
extension JBaseViewController { // 配置getpopver 方法，如果没有targerview 情况下会出现异常
    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    public func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    // Called on the delegate when the popover controller will dismiss the popover. Return NO to prevent the
    // dismissal of the view.
    public func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
    public func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return true
    }
}
extension JBaseViewController {
    // MARK: mark keyboard action 键盘处理
    @objc func funj_keyboardWillChangeFrame(_ noti : NSNotification) {
        if let userInfo = noti.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let beginFrame = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            
            if beginFrame == nil || endFrame == nil { return }
            
            UIView.animate(withDuration: duration, delay: TimeInterval(0), options: animationCurve) {
                self.funj_willShowKeyboardFromFrame(beginFrame!, to: endFrame!)
            } completion: { _ in }
        }
    }
    func funj_willShowKeyboardFromFrame(_ beginFrame : CGRect , to endFrame : CGRect) {}
    
}



extension UIViewController {
//    @objc func funj_showProgressView() {}
//    @objc func funj_closeProgressView() {}
//    @objc func funj_setBaseControllerData(_ data : Any?){}
//    @objc func funj_setPresentIsPoperView(_ controller : UIViewController,size : CGSize ,target : UIView?)  {}

//    @objc func funj_getPresentVC(className : UIViewController.Type , title : String? = nil , data : Any? = nil , isNav : Bool = false, callback : ksetBaseVC? = nil) -> UIViewController? { return self}
//    @objc func funj_getPushVC(className : UIViewController.Type , title : String? = nil , data : Any? = nil , callback : ksetBaseVC? = nil ) -> UIViewController? { return self}
//
//    @objc func func_replacePushVC(className : UIViewController.Type , title : String? = nil , data : Any? = nil , callback : ksetBaseVC? = nil) -> UIViewController? { return self}
//
//    @objc func funj_getPopoverVC(className : UIViewController.Type , target : UIView? , data : Any? = nil, isNav : Bool = false, size : CGSize , callback : ksetPopverBaseVC?) -> UIViewController? { return self}
    
//    func funj_addVCCallback(_ callback : ksetBaseVC) -> UIViewController { return self}
}
