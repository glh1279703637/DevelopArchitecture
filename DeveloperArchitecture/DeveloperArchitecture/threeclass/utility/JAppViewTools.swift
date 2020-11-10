//
//  JAppViewTools.swift
//  DeveloperArchitecture
//
//  Created by Jeffrey on 2020/10/10.
//  Copyright © 2020 Jeffery. All rights reserved.
//

import Foundation
import UIKit
//视图圆角构造方法
struct JFilletValue {
    var m_borderWidth : CGFloat = 0.0
    var m_cornerRadius : CGFloat = 0.0
    var m_borderColor : UIColor?
    
    init(w : CGFloat ,r : CGFloat , c : UIColor?) {
        m_borderWidth = w
        m_cornerRadius = r
        m_borderColor = c
    }
}
struct JTextFC {
    var m_textFont : UIFont
    var m_textColor : UIColor
    var m_selectTextColor : UIColor?
    var m_alignment : NSTextAlignment = .left
    init(){ self.init(f: FONT_SIZE13, c: COLOR_TEXT_BLACK) }
    init(f : UIFont , c : UIColor){
        m_textFont = f
        m_textColor = c
    }
    init(f : UIFont , c : UIColor ,sc : UIColor) {
        self.init(f: f, c: c)
        m_selectTextColor = sc
    }
    init(f : UIFont , c : UIColor ,a : NSTextAlignment) {
        self.init(f: f, c: c)
        m_alignment = a
    }
}
enum JButtonContentImageLayout {
    case kLEFT_IMAGECONTENT // 图文 靠左
    case kLEFT_CONTENTIMAGE // 文图 靠左
    
    case kCENTER_IMAGECONTENT // 图文 靠中间 默认
    case kCENTER_CONTENTIMAGE // 文图 靠中间
    
    case kRIGHT_IMAGECONTENT // 图文 靠右
    case kRIGHT_CONTENTIMAGE // 文图 靠右
    
    case kTOP_IMAGECONTENT // 图文 上下
    case kTOP_CONTENTIMAGE // 文图 上下
    
    case kLEFT_CONTENT_RIGHT_IMAGE // 左文 右图 ,中间留白
}
//Button图文排列对齐构造方法
struct JAlignValue{
    var m_head : CGFloat
    var m_spacing : CGFloat
    var m_foot : CGFloat
    init(h : CGFloat , s : CGFloat , f : CGFloat) {
        m_head = h
        m_spacing = s
        m_foot = f
    }
}

typealias kclickCallBack = ((_ button : UIButton) -> ())
typealias kalertBlockCallback = ((_ index :Int) -> ())
typealias kcompleteCallback = (() -> ())

private var kbuttonAttribute = "kbuttonAttribute"

class ButtonAttribute : NSObject {
    var m_addProhibitActionTime : TimeInterval = 2.0 // 设置连续事件点击间隔时间 ，防止重复点击
    var m_addProhibitActionTimeIsEnable : Bool = true // 设置连续事件点击 防止重复点击,YES:enable,NO:noenable
    var m_saveBgColor : [UIColor]?
    var m_clickBackCallback : kclickCallBack?
    var m_isCanAction : Bool = false
    var m_isDefalutNeedToSelectChange : Bool = true //是否需要改变点击后状态
    var m_upSelectTime : TimeInterval = 0.0 //上次选择时间
    var m_saveNormalDarkImage : UIImage? //正常图片 深色模式
    var m_saveDarkImage : UIImage?
}

//class JButton : UIButton {
extension UIButton {
    var m_attribute : ButtonAttribute?{
        var attribute = objc_getAssociatedObject(self, &kbuttonAttribute)
        if attribute == nil {
            attribute = ButtonAttribute()
            objc_setAssociatedObject(self, &kbuttonAttribute, attribute, .OBJC_ASSOCIATION_RETAIN)
        }
        return attribute as? ButtonAttribute
    }

    open override var isSelected: Bool {
        get {return super.isSelected}
        set {super.isSelected = newValue
            if let m_saveBgImageOrColor = m_attribute?.m_saveBgColor {
                if m_saveBgImageOrColor.count >= 2 {
                    if newValue == false{ self.backgroundColor = m_saveBgImageOrColor[0] }
                    else {self.backgroundColor = m_saveBgImageOrColor[1] }}}}
    }
    func funj_saveBgColor(_ saveBgColor : [Any]?) -> UIButton {
        if saveBgColor == nil || saveBgColor!.count <= 0 {m_attribute?.m_saveBgColor = nil }
        else if saveBgColor![0] is UIColor {
            m_attribute?.m_saveBgColor = saveBgColor as? [UIColor]
        }
        return self
    }
    private func funj_isCanPerformSelector() -> Bool {
        if m_attribute?.m_addProhibitActionTime ?? 0 <= 0 {return true}
        let now = NSDate().timeIntervalSince1970
        if now - m_attribute!.m_upSelectTime >= m_attribute!.m_addProhibitActionTime {
            m_attribute?.m_upSelectTime = now
            return true
        }
        return false
    }
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        m_attribute?.m_isCanAction = self.funj_isCanPerformSelector()
        if m_attribute?.m_isCanAction == false { return }
        JAppUtility.funj_expandAnimationForView(self, e: 0.03)
    }
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if m_attribute?.m_isCanAction == false { return }
        if m_attribute?.m_isDefalutNeedToSelectChange != true {self.isSelected = !self.isSelected}
        if m_attribute?.m_clickBackCallback != nil { m_attribute?.m_clickBackCallback?(self) }
        if m_attribute?.m_addProhibitActionTimeIsEnable == false {
            self.isEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now()+1) {self.isEnabled = true}
        }}
    open override var isHighlighted: Bool{
        get{ let isHighlighte = super.isHighlighted
            if m_attribute?.m_addProhibitActionTime ?? 0 <= 0  { return isHighlighte }
            if m_attribute?.m_isCanAction == true { return isHighlighte }
            return false}
        set { super.isHighlighted = newValue }
    }
    open override func sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        if m_attribute?.m_isCanAction == false { return }
        super.sendAction(action, to: target, for: event)
    }
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if m_attribute?.m_saveDarkImage == nil  || m_attribute?.m_saveNormalDarkImage == nil { return }
        if kcurrentUserInterfaceStyleModel == 2 {self.setImage(m_attribute?.m_saveDarkImage, for: .normal)
        }else {self.setImage(m_attribute?.m_saveNormalDarkImage, for: .normal)}
    }
}

@objc protocol JSearchBarDelegate : NSObjectProtocol {
    @objc optional func funj_searchShouldBeginEditing(_ textField : UITextField) -> Bool
    @objc optional func funj_search(_ textField : UITextField ,range : NSRange , string : String) -> Bool
    @objc optional func funj_searchReturnButtonClicked(_ textField : UITextField) -> Bool
    @objc optional func funj_searchCancelButtonClicked(_ textField : UITextField)
    @objc optional func funj_searchDidEndEditing(_ textField : UITextField)
}

class JSearchBar : UIView, UITextFieldDelegate {
    var m_searchTF : UITextField?
    var m_searchIcon : String = "main_search_n"
    var m_cancelButton : UIButton?
    var m_cancelAlreadyShow : Bool = false
    var m_searchDelegate : JSearchBarDelegate?
    var m_filletValue : JFilletValue{
        set{_ = self.m_searchTF?.funj_addCornerLayer(newValue)}
        get{ return JFilletValue(w: 0, r: 0, c: nil)}
    }
    override init(frame : CGRect) {
        super.init(frame: frame)
        m_searchTF = UITextField(frame: CGRect(x: 2, y: 2, width: frame.size.width - 4, height: frame.size.height - 4))
        self.addSubview(m_searchTF!)
        m_searchTF?.delegate = self
        m_searchTF?.clearButtonMode = .whileEditing
        m_searchTF?.placeholder = kLocalStr("Enter search content")
        m_searchTF?.returnKeyType = .search
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented")}

    func funj_reloadSearchState(needIcon : Bool , needCancel : Bool){
        if needIcon {
            let searchImageView = UIImageView(image: UIImage(named: self.m_searchIcon))
            searchImageView.frame = CGRect(x: 0, y: 0, width: 30, height: 15)
            searchImageView.contentMode = .center
            self.m_searchTF?.leftViewMode = .always
            let bgView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 15))
            bgView .addSubview(searchImageView)
            self.m_searchTF?.leftView = bgView
        }
        if needCancel {
            m_cancelButton = UIButton(frame: CGRect(x: self.frame.size.width - 60, y: 0, width: 60, height: self.frame.size.height))
            m_cancelButton?.setTitleColor(COLOR_BLUE, for: .normal)
            m_cancelButton?.setTitle(kLocalStr("Cancel"), for: .normal)
            m_cancelButton?.titleLabel?.adjustsFontSizeToFitWidth = true
            m_cancelButton?.addTarget(self, action: #selector(self.funj_searchCancelButtonClicked(_:)), for:.touchUpInside)
            m_cancelButton?.backgroundColor = COLOR_WHITE_DARK
            m_cancelButton?.isHidden = !m_cancelAlreadyShow
            self.addSubview(m_cancelButton!)
        }
    }
    @objc func funj_searchCancelButtonClicked(_ sender : UIButton){
        if sender.titleLabel?.text == kLocalStr("Cancel") {
            self.m_searchTF?.text = ""
        }
        self.m_searchDelegate?.funj_searchCancelButtonClicked?(self.m_searchTF!)
    }
    func funj_removeCancelButton (){
        m_cancelButton?.removeFromSuperview()
        m_searchTF?.frame = CGRect(x: 2, y: 2, width: self.frame.size.width - 4, height: self.frame.size.height-4)
        m_cancelButton = nil
    }
    func funj_changeCancelButton(isShow : Bool){
        if isShow == false { self.endEditing(true) }
        if m_cancelButton == nil { return }
        self.m_cancelButton?.isHidden = self.m_cancelAlreadyShow ? false : !isShow
        UIView.animate(withDuration: 0.2) {
            let frame = self.m_searchTF?.frame ?? CGRect(x: 0, y: 0, width: 0, height: 0)
            self.m_searchTF?.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: self.frame.size.width - ((frame.size.width + 4) * (isShow ? 1 : 0)), height: frame.size.height)
        }
    }
    override func layoutSubviews() {
        let cancelBt = self.m_cancelButton != nil && self.m_cancelButton?.isHidden == false
        let width = cancelBt ? self.m_cancelButton?.frame.size.width ?? 0 : 0
        m_searchTF?.frame = CGRect(x: 2,y: 2,width: self.frame.width - 4 - width , height: self.frame.size.height - 4)
        m_cancelButton?.frame = CGRect(x: self.width - (self.m_cancelButton?.width ?? 0) - 2, y: 0, width: self.m_cancelButton?.width ?? 0, height: self.height)
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        funj_changeCancelButton(isShow: true)
        if let ishas =  self.m_searchDelegate?.funj_searchShouldBeginEditing?(textField) {
            return ishas
        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        funj_changeCancelButton(isShow: true)
        if let ishas  = self.m_searchDelegate?.funj_search?(textField, range: range, string: string) {
            return ishas
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        funj_changeCancelButton(isShow: false)
        if let ishas  = self.m_searchDelegate?.funj_searchReturnButtonClicked?(textField) {
            return ishas
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        funj_changeCancelButton(isShow: false)
        self.m_searchDelegate?.funj_searchDidEndEditing?(textField)
    }
}
class JAlertController :UIAlertController {
    override var shouldAutorotate: Bool {
        return false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = COLOR_WHITE_DARK
        _ = self.view.funj_addCornerRadius(15)
    }
}

class JAppViewTools : NSObject {
    class func funj_getTopVC() -> UIViewController? {
        var showViewApplication : AnyObject? = UIApplication.shared.delegate?.window??.rootViewController
        #if TARGET_OS_MACCATALYST
        for windowScene in UIApplication.shared.connectedScenes {
            if windowScene.activationState == .foregroundActive {
                let window = (windowScene as! UIWindowScene).windows.first
                showViewApplication = window?.rootViewController
        }}
        #else
        if #available(iOS 13.0, *) {
            for windowScene in UIApplication.shared.connectedScenes {
                if windowScene.activationState == .foregroundActive {
                    let window = (windowScene as! UIWindowScene).windows.first
                    showViewApplication = window?.rootViewController
        }}}
        #endif
        var countIndex = 0
        while showViewApplication?.presentedViewController != nil {
            showViewApplication = showViewApplication?.presentedViewController
            if showViewApplication is UINavigationController {
                let nav = showViewApplication as? UINavigationController
                if nav?.viewControllers.count ?? 0 > 0 {
                    showViewApplication = nav?.viewControllers.last
            }}
            countIndex += 1
            if countIndex  > 7 { break }
        }
        return showViewApplication as? UIViewController
    }
    class func funj_getKeyWindow() -> UIView? {
        #if TARGET_OS_MACCATALYST
        for windowScene in UIApplication.shared.connectedScenes {
            if windowScene.activationState == .foregroundActive {
                return (windowScene as! UIWindowScene).windows.first
        }}
        #else
        if #available(iOS 13.0, *) {
            for windowScene in UIApplication.shared.connectedScenes {
                if windowScene.activationState == .foregroundActive {
                    return (windowScene as! UIWindowScene).windows.first
        }}}
        return UIApplication.shared.keyWindow
        #endif
    }

    //显示toast文字
    class func funj_showTextToast(_ superView : UIView? ,message : String , time : TimeInterval){
        self.funj_showTextToast(superView, message: message,time: 2, complete: nil)
    }
    class func funj_showTextToast(_ superView1 : UIView? ,message : String ,time : TimeInterval ,complete : kcompleteCallback? ){
        var superView = superView1
        if superView == nil {
            superView = JAppViewTools.funj_getKeyWindow()
            if superView == nil { return }
        }
        let progressHUD = JMProgressHUD(frame: CGRectZero)
        progressHUD.funj_reloadSuperView(superView: superView!, type: .kprogressType_OnlyText)
        progressHUD.funj_showProgressViews(title: message, t: time, complete: complete)
    }
    class func funj_showAlertBlock(message : String) -> UIAlertController {
        return funj_showAlertBlock(nil, message: message, buttonArr: ["Confirm"], callback: nil)
    }
    class func funj_showAlertBlock(_ title : String? , message : String? ,buttonArr :[String] ,callback :  kalertBlockCallback? ) -> UIAlertController {
        let title1 = title != nil ? title : NSLocalizedString("Info", comment: "Info")
        let alertController = UIAlertController(title: title1, message: message, preferredStyle: .alert)
        for i in 0..<buttonArr.count {
            let action = UIAlertAction(title: buttonArr[i], style: .default) { (action) in
                callback?(i)
            }
            if buttonArr.count == 2 {
                if i == 0 {action.setValue(COLOR_TEXT_GRAY_DARK, forKey: "titleTextColor")}
                else {action.setValue(COLOR_ORANGE, forKey: "titleTextColor")}
            }
            alertController.addAction(action)
        }
        JAppViewTools.funj_getTopVC()?.present(alertController, animated: true, completion: nil)
        return alertController
    }
    class func funj_showSheetBlock(_ sourceView : UIView? ,title : String ,buttonArr : [String] ,callback :  kalertBlockCallback?) {
        let type : UIAlertController.Style  = sourceView != nil ? .actionSheet :(kIS_IPAD ? .alert : .actionSheet)
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: type)
        for i in 0..<buttonArr.count {
            let action = UIAlertAction(title: buttonArr[i], style: .default) { (action) in
                callback?(i)
            }
            alertController.addAction(action)
        }
        let action = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .default) { (action) in
            callback?(buttonArr.count)
        }
        alertController.addAction(action)
        if sourceView != nil {
            alertController.modalPresentationStyle = .popover
            alertController.preferredContentSize = CGSize(width: UIScreen.main.bounds.size.width - 200, height:  UIScreen.main.bounds.size.height - 200) //设置弹出视图大小必须好推送类型相
            let pover = alertController.popoverPresentationController
            pover?.sourceRect = sourceView!.bounds
            pover?.sourceView = sourceView
        }
        JAppViewTools.funj_getTopVC()?.present(alertController, animated: true, completion: nil)
    }
}

