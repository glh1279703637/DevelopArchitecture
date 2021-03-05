//
//  JAppViewExtend.swift
//  DeveloperArchitecture
//
//  Created by Jeffrey on 2020/10/10.
//  Copyright © 2020 Jeffery. All rights reserved.
//

import Foundation
import UIKit
import WebKit

private var ktextFieldMaxLengthKey = "ktextFieldMaxLengthKey"
private var ktextFieldInsertLengthKey = "ktextFieldInsertLengthKey"
private var ktextFieldInsertTextInputType = "ktextFieldInsertTextInputType"

struct kTextfinput_Type: OptionSet {
    let rawValue: Int
    
    static let kAllInputChar_Tag        = kTextfinput_Type(rawValue: 1 << 0) //支持所有字符
    static let kAllDigital_Tag          = kTextfinput_Type(rawValue: 1 << 1)//数字
    static let kAllLetter_Tag           = kTextfinput_Type(rawValue: 1 << 2)//字母
    static let kAllChinese_Tag          = kTextfinput_Type(rawValue: 1 << 3)//汉字
    static let kAllInputPunctuation_Tag = kTextfinput_Type(rawValue: 1 << 4)//标点字符，除了特殊无法存储字符
    static let kAllNoEmoticons_Tag      = kTextfinput_Type(rawValue: 1 << 5)//除表情符号所有字符
}
protocol JResponderDelegate {
    //解决数字键盘无返回按钮的问题
    func funj_addNumberInputKeyAccesssoryTitleView()
    
    func funj_setTextFieldMaxLength(maxLength : Int , type : [kTextfinput_Type])
}
protocol JViewDelegate{
    func funj_addCornerLayer(_ fillet : JFilletValue?) -> Self
    func funj_addCornerRadius(_ radius : CGFloat) -> Self
}
protocol JLabelDelegate {
    func funj_updateAttributedText(_ title : String) -> NSMutableAttributedString?
}

protocol JTextFieldDelegate {
    func funj_add(_ delegate : UITextFieldDelegate , tag : Int) -> UITextField
    func funj_add(_ keyboardType : UIKeyboardType , returnKeyType : UIReturnKeyType )  -> UITextField
}

protocol JButtonDelegate {
    // 设置
    func funj_add(bgImageOrColor :[Any]? , isImage : Bool) -> UIButton
    //修改button的样式 是否需要点击高亮 是否需要点击时selected变化
    func funj_add(autoSelect isDefalutNeedToSelectChange : Bool ) -> UIButton
    
    func funj_add(t prohibitTime : TimeInterval , e enable :Bool) -> UIButton
    
    func funj_addblock(block : kclickCallBack?) -> UIButton
    
    func funj_add(normalDarkImage : String) -> UIButton
    
    func funj_add(targe : Any, action :String , tag : Int) -> UIButton
    
    func funj_updateContentImage(layout : JButtonContentImageLayout , spacing : CGFloat) -> UIButton
    
    func funj_updateContentImage(layout : JButtonContentImageLayout ,a align1 : JAlignValue) -> UIButton
}

protocol JWKWebviewDelegate {
    func funj_addScriptMessageHandler(strongSelf : WKScriptMessageHandler , nameArr : [String])
    
    func funj_removeScriptMessageHandler( nameArr : [String])
    
    func funj_deallocWebView()
}
/// /// ///  /// /// /// /// //////////////////    /////////  ////////////   /////////   ////////////

extension UIResponder :JResponderDelegate{
    //解决数字键盘无返回按钮的问题
    func funj_addNumberInputKeyAccesssoryTitleView() {
        let inputAccessoryView = UIView(i: CGRect(x: 0, y: 0, width: kWidth, height: 50), bg: kARGBHex(0xD1D4D9, 1))
        let sumBt = UIButton(i:CGRect(x: kWidth - 120 , y: 0, width: 120 , height: 50), title: kLocalStr("Confirm"), textFC: JTextFC(f: kFont_Size17, c: kColor_Orange))
            .funj_updateContentImage(layout: .kRIGHT_CONTENTIMAGE, a: JAlignValue(h: 0, s: 0, f: 20))
            .funj_addblock { (button) in
                JAppViewTools.funj_getKeyWindow()?.endEditing(true)
            }
        inputAccessoryView.addSubview(sumBt)
        (self as? UITextField)?.inputAccessoryView = inputAccessoryView
        (self as? UITextView)?.inputAccessoryView = inputAccessoryView
    }
    func funj_setTextFieldMaxLength(maxLength : Int , type : [kTextfinput_Type]) {
        let weakTV = self as? UITextView ; let weakTF = self as? UITextField
        if (weakTV == nil && weakTF == nil) || type.count <= 0  { return }
        let notiName = weakTF != nil ? UITextField.textDidChangeNotification : UITextView.textDidChangeNotification
        NotificationCenter.default.addObserver(self, selector: #selector(funj_TextFiledEditChangedToSubLength(_ :)), name: notiName, object: nil)
        weakTF?.m_TextFieldInsertTextInputType = type
        weakTV?.m_TextFieldInsertTextInputType = type
        
        let maxLength1 = maxLength > 0 ? maxLength : 1000
        weakTF?.m_TextFieldMaxLengthKey = maxLength1
        weakTV?.m_TextFieldMaxLengthKey = maxLength1
    }
    @objc func funj_TextFiledEditChangedToSubLength(_ noti : NSNotification){
        let weakTV = self as? UITextView ; let weakTF = self as? UITextField
        let typeArr = weakTF?.m_TextFieldInsertTextInputType ?? weakTV?.m_TextFieldInsertTextInputType
        if typeArr == nil { return }
        var toBeString = weakTV?.text ?? weakTF?.text
        
        var regexStr = ""
        
        for type in typeArr! {
            switch type {
            case .kAllDigital_Tag:
                regexStr += "0-9"
            case .kAllLetter_Tag:
                regexStr += "a-zA-Z"
            case .kAllChinese_Tag:
                regexStr += "\\u4E00-\\u9FC2"
            case .kAllInputPunctuation_Tag:
                regexStr += ".,~`!@#$%^&*\\(\\)|\\{\\}\\[\\];:'\"/\\\\_"
            case .kAllNoEmoticons_Tag:
                regexStr += "\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n"
            default: break
            }
        }
        if regexStr.count > 0 {
            regexStr = "[^\(regexStr)]"
            let regex = try! NSRegularExpression(pattern: regexStr, options: .caseInsensitive)
            toBeString = regex.stringByReplacingMatches(in: toBeString!, options: [], range: NSRange(location: 0, length: toBeString!.count), withTemplate: "")
        }
        let numbers = weakTV?.m_TextFieldMaxLengthKey ?? weakTF?.m_TextFieldMaxLengthKey
        if numbers ?? 0 <= 0 {
            weakTF?.text = toBeString; return
        }
        let lang = UIApplication.shared.textInputMode?.primaryLanguage
        if lang?.hasPrefix("zh-Han") == true { //简体中文输入，包括简体拼音，健体五笔，简体手写
            let selectedRange = (weakTV?.markedTextRange ?? weakTF?.markedTextRange) ?? UITextRange()
            let position = weakTV?.position(from: selectedRange.start, offset: 0) ?? weakTF?.position(from: selectedRange.start, offset: 0)
            if position == nil {//没有高亮选择的字，则对已输入的文字进行字数统计和限制
                let localIndex = (weakTV?.m_TextFieldInsertLengthKey ?? weakTF?.m_TextFieldInsertLengthKey) ?? 0
                if toBeString!.count > numbers! {
                    if localIndex < 0 {
                        let firstStr = (toBeString as NSString?)?.substring(to: abs(localIndex))
                        let endStr = (toBeString as NSString?)?.substring(with: NSRange(location: toBeString!.count - (numbers! - abs(localIndex)), length: numbers! - abs(localIndex)))
                        weakTF?.text = (firstStr ?? "") + (endStr ?? "")
                        weakTV?.text = (firstStr ?? "") + (endStr ?? "")
                    } else {
                        let endStr = (toBeString as NSString?)?.substring(with: NSRange(location: localIndex, length: numbers! - localIndex))
                        let firstStr = (toBeString as NSString?)?.substring(to: localIndex)
                        weakTF?.text = (firstStr ?? "") + (endStr ?? "")
                        weakTV?.text = (firstStr ?? "") + (endStr ?? "")
                    }
                } else {
                    weakTF?.text = toBeString ?? ""
                    weakTV?.text = toBeString ?? ""
                }
            } else if weakTF?.beginningOfDocument != nil || weakTV?.beginningOfDocument != nil { //有高亮选择的字符串，则暂不对文字进行统计和限制
                guard let localIndex = weakTF?.offset(from: (weakTF?.beginningOfDocument)!, to: position!) ?? weakTV?.offset(from: (weakTV?.beginningOfDocument)!, to: position!) else { return }
                weakTV?.m_TextFieldInsertLengthKey = localIndex * (localIndex == numbers ? 1 : -1)
                weakTF?.m_TextFieldInsertLengthKey = localIndex * (localIndex == numbers ? 1 : -1)
            }
        }else{
            if toBeString!.count > numbers! && (weakTF?.selectedTextRange?.start != nil || weakTV?.selectedTextRange?.start != nil) {
                guard let localIndex = weakTF?.offset(from: (weakTF?.beginningOfDocument)!, to: (weakTF?.selectedTextRange?.start)!) ?? weakTV?.offset(from: (weakTV?.beginningOfDocument)!, to: (weakTV?.selectedTextRange?.start)!) else { return }
                if localIndex < toBeString!.count {
                    let firstStr = (toBeString as NSString?)?.substring(to: localIndex - 1)
                    let endStr = (toBeString as NSString?)?.substring(with: NSRange(location: toBeString!.count - (numbers! - localIndex + 1), length: numbers! - localIndex + 1))
                    weakTF?.text = (firstStr ?? "") + (endStr ?? "")
                    weakTV?.text = (firstStr ?? "") + (endStr ?? "")
                } else {
                    var maxLength = numbers! - localIndex
                    maxLength = maxLength < 0 ? 0 : maxLength
                    var endStr : String? = nil
                    if localIndex + maxLength < toBeString!.count {
                        endStr = (toBeString as NSString?)?.substring(with: NSRange(location: localIndex, length: maxLength))
                    }
                    let firstStr = (toBeString as NSString?)?.substring(to: numbers!)
                    weakTF?.text = (firstStr ?? "") + (endStr ?? "")
                    weakTV?.text = (firstStr ?? "") + (endStr ?? "")
                }
            }else {
                weakTF?.text = toBeString
                weakTV?.text = toBeString
            }
        }
    }
}

extension UIView {
    var origin : CGPoint {
        get{ return self.frame.origin }
        set { self.frame.origin = newValue}
    }
    var size : CGSize {
        get{ return self.frame.size }
        set { self.frame.size = newValue}
    }
    var height : CGFloat {
        get{ return self.frame.size.height }
        set { self.frame.size.height = newValue}
    }
    var width : CGFloat {
        get{ return self.frame.size.width }
        set { self.frame.size.width = newValue}
    }
    var left : CGFloat {
        get{ return self.frame.origin.x }
        set { self.frame.origin = CGPoint(x: newValue, y: self.frame.origin.y)}
    }
    var right : CGFloat {
        get{ return self.frame.origin.x + self.frame.size.width }
    }
    var top : CGFloat {
        get{ return self.frame.origin.y }
        set { self.frame.origin = CGPoint(x: self.frame.origin.x, y: newValue)}
    }
    var bottom : CGFloat {
        get{ return self.frame.origin.y + self.frame.size.height }
    }
}
extension UIView  : JViewDelegate{
    convenience init(i frame : CGRect ,bg bgColor : UIColor){
        self.init(frame: frame)
        self.backgroundColor = bgColor
    }
    func funj_addCornerLayer(_ fillet : JFilletValue?) -> Self{
        if fillet == nil || self.isKind(of: UIView.self) == false { return self }
        self.layer.borderWidth = fillet!.m_borderWidth
        self.layer.cornerRadius = fillet!.m_cornerRadius
        self.layer.borderColor = fillet!.m_borderColor?.cgColor
        if fillet!.m_cornerRadius >= 1.0 {
            self.layer.masksToBounds = true
        }
        return self
    }
    func funj_addCornerRadius(_ radius : CGFloat) -> Self {
        return self.funj_addCornerLayer(JFilletValue(w: 0, r: radius, c: nil))
    }
    func  funj_addGradientLayer(_ isX : Bool ,colorArr :[CGColor] ,locations: [NSNumber]) -> CAGradientLayer{
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: (isX == true ? 1 : 0) * 1, y: (isX == false ? 1 : 0) * 1)
        gradientLayer.colors = colorArr
        gradientLayer.locations = locations
        self.layer.insertSublayer(gradientLayer, at: 0)
        return gradientLayer
    }
}
extension UILabel : JLabelDelegate{
    convenience init(i frame : CGRect ,title : String? = nil,textFC : JTextFC? ){
        self.init(frame:frame)
        self.font = textFC?.m_TextFont ?? kFont_Size13
        self.textColor = textFC?.m_TextColor ?? kColor_Text_Black
        self.textAlignment = textFC?.m_alignment ?? .left
        self.numberOfLines = 0
        self.text = title
        self.backgroundColor = .clear
    }
    func funj_updateAttributedText(_ title : String) -> NSMutableAttributedString? {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        paragraphStyle.alignment = self.textAlignment
        paragraphStyle.paragraphSpacing = 5
        if self.numberOfLines != 0 {
            paragraphStyle.lineBreakMode = .byTruncatingTail
        }
        let attri = NSMutableAttributedString(string: title, attributes: [
            NSAttributedString.Key.font : self.font ?? kFont_Size13,
            NSAttributedString.Key.foregroundColor : self.textColor ?? kColor_Text_Black,
            NSAttributedString.Key.paragraphStyle:paragraphStyle])
        self.attributedText = attri
        return attri
    }
}

extension UITextField :JTextFieldDelegate{
    var m_TextFieldMaxLengthKey : Int? {
        get { return objc_getAssociatedObject(self, &ktextFieldMaxLengthKey) as? Int }
        set {objc_setAssociatedObject(self, &ktextFieldMaxLengthKey, newValue, .OBJC_ASSOCIATION_ASSIGN)}}
    var m_TextFieldInsertLengthKey : Int? {
        get { return objc_getAssociatedObject(self, &ktextFieldInsertLengthKey) as? Int }
        set {objc_setAssociatedObject(self, &ktextFieldInsertLengthKey, newValue, .OBJC_ASSOCIATION_ASSIGN)}}
    var m_TextFieldInsertTextInputType : [kTextfinput_Type]? {
        get { return objc_getAssociatedObject(self, &ktextFieldInsertTextInputType) as? [kTextfinput_Type] }
        set {objc_setAssociatedObject(self, &ktextFieldInsertTextInputType, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)}}
    
    convenience init(i frame : CGRect ,placeholder : String? ,textFC : JTextFC? ){
        self.init(frame:frame)
        self.font = textFC?.m_TextFont ?? kFont_Size13
        self.textColor = textFC?.m_TextColor ?? kColor_Text_Black
        self.textAlignment = textFC?.m_alignment ?? .left
        self.placeholder = placeholder
        self.backgroundColor = .clear
        if self.textAlignment != .center {
            let defaultView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: frame.size.height))
            defaultView.backgroundColor = UIColor.clear
            self.leftViewMode = .always
            self.leftView = defaultView
        }
    }
    func funj_add(_ delegate : UITextFieldDelegate , tag : Int) -> UITextField {
        self.delegate = delegate
        self.tag = tag
        return self
    }
    func funj_add(_ keyboardType : UIKeyboardType , returnKeyType : UIReturnKeyType )  -> UITextField {
        self.keyboardType = keyboardType
        self.returnKeyType = returnKeyType
        return self
    }
}

extension UITextView {
    var m_TextFieldMaxLengthKey : Int? {
        get { return objc_getAssociatedObject(self, &ktextFieldMaxLengthKey) as? Int }
        set {objc_setAssociatedObject(self, &ktextFieldMaxLengthKey, newValue, .OBJC_ASSOCIATION_ASSIGN)}}
    var m_TextFieldInsertLengthKey : Int? {
        get { return objc_getAssociatedObject(self, &ktextFieldInsertLengthKey) as? Int }
        set {objc_setAssociatedObject(self, &ktextFieldInsertLengthKey, newValue, .OBJC_ASSOCIATION_ASSIGN)}}
    var m_TextFieldInsertTextInputType : [kTextfinput_Type]? {
        get { return objc_getAssociatedObject(self, &ktextFieldInsertTextInputType) as? [kTextfinput_Type] }
        set {objc_setAssociatedObject(self, &ktextFieldInsertTextInputType, newValue, .OBJC_ASSOCIATION_ASSIGN)}}
    
    convenience init(i frame : CGRect ,textFC : JTextFC? ){
        self.init(frame:frame)
        self.font = textFC?.m_TextFont ?? kFont_Size13
        self.textColor = textFC?.m_TextColor ?? kColor_Text_Black
        self.textAlignment = textFC?.m_alignment ?? .left
        self.backgroundColor = .clear
    }
    convenience init(i_linkAttri linkAttriWithframe : CGRect ,content : String? ,attrs : Dictionary<NSAttributedString.Key,AnyObject> , selectArr : [NSRange] , target : AnyObject){
        self.init(frame: linkAttriWithframe)
        self.isScrollEnabled = false
        self.isEditable = false
        let attri = NSMutableAttributedString(string: content!, attributes: attrs)
        self.attributedText = attri
        self.textAlignment = .center
        
        var index = 0
        for range in selectArr {
            attri.addAttributes([NSAttributedString.Key.foregroundColor : kColor_Orange], range: range)
            let startPosition = self.position(from: self.beginningOfDocument, offset: range.location)
            let endPosition = self.position(from: self.beginningOfDocument, offset: range.location+range.length)
            if startPosition != nil && endPosition != nil {
                let textRange = self.textRange(from: startPosition!, to: endPosition!)
                if textRange != nil {
                    var frame = self.firstRect(for: textRange!)
                    frame.origin.y -= 5;frame.size.height += 10
                    let actionBt = UIButton(frame: frame)
//                  actionBt.addTarget(target, action: #selector(funj_selectLinkAttriToCallback(_ :)), for: .touchUpInside)
                    actionBt.addTarget(target, action: NSSelectorFromString("funj_selectLinkAttriToCallback:"), for: .touchUpInside)

                    actionBt.tag = 10100 + index
                    self.addSubview(actionBt)

                    index = index + 1
                }
            }
        }
        self.attributedText = attri
        self.textAlignment = .center
    }
}

extension UIImageView {
    convenience init(i frame : CGRect ,image : String?){
        self.init(frame:frame)
        if image != nil {
            self.image = UIImage(named: image!)
        }
    }
    convenience init(i frame : CGRect ,bgColor : UIColor?){
        self.init(frame:frame)
        self.backgroundColor = bgColor
    }
    convenience init(i_line lineframe : CGRect){
        self.init(frame:lineframe)
        self.backgroundColor = kARGBHex(0xE1E1E1, 1)
    }
    convenience init(i_blackAlpha blackAlphaFrame: CGRect){
        self.init(frame:blackAlphaFrame)
        self.backgroundColor = kColor_Text_Black_Dark
        self.alpha = 0.3
        self.isUserInteractionEnabled = true
    }
}

extension UIButton : JButtonDelegate{
    convenience init(i frame : CGRect ,title : String? ,textFC : JTextFC){
        self.init(frame:frame)
        if title != nil {
            self.setTitle(title, for: .normal)
        }
        self.setTitleColor(textFC.m_TextColor ,for: .normal)
        if textFC.m_selectTextColor != nil {
            self.setTitleColor(textFC.m_TextColor ,for: .highlighted)
            self.setTitleColor(textFC.m_TextColor ,for: .selected)
        }
        self.titleLabel?.font = textFC.m_TextFont
    }
    // 设置
    func funj_add(bgImageOrColor :[Any]? , isImage : Bool) -> UIButton {
        if bgImageOrColor != nil && bgImageOrColor!.count >= 1 {
            let imageStr = bgImageOrColor![0]
            if imageStr is String {
                let image = UIImage(named: imageStr as! String)
                if isImage {
                    self.setImage(image, for: .normal)
                } else {
                    self.setBackgroundImage(image, for: .normal)
                }
            } else if imageStr is UIColor {
                self.backgroundColor = bgImageOrColor![0] as? UIColor
            }
            if bgImageOrColor!.count >= 2 {
                let imageStr = bgImageOrColor![1]
                if imageStr is String {
                    let image = UIImage(named: imageStr as! String)
                    if isImage {
                        self.setImage(image, for: .selected)
                        self.setImage(image, for: .highlighted)
                    } else {
                        self.setBackgroundImage(image, for: .selected)
                        self.setBackgroundImage(image, for: .highlighted)
                    }
                }
            }
        }
        _ = funj_saveBgColor(bgImageOrColor)
        return self
    }
    //修改button的样式 是否需要点击高亮 是否需要点击时selected变化
    func funj_add(autoSelect isDefalutNeedToSelectChange : Bool ) -> UIButton {
        m_attribute?.m_isDefalutNeedToSelectChange = isDefalutNeedToSelectChange
        return self
    }
    func funj_add(t prohibitTime : TimeInterval , e enable :Bool) -> UIButton {
        m_attribute?.m_addProhibitActionTime = prohibitTime
        m_attribute?.m_addProhibitActionTimeIsEnable = enable
        return self
    }
    func funj_addblock(block : kclickCallBack?) -> UIButton {
        m_attribute?.m_clickBackCallback = block
        return self
    }
    func funj_add(normalDarkImage : String) -> UIButton {
        m_attribute?.m_saveDarkImage = UIImage(named: normalDarkImage)
        m_attribute?.m_saveNormalDarkImage = self.image(for: .normal)
        if kcurrentUserInterfaceStyleModel == 2 {
            self.setImage(m_attribute?.m_saveDarkImage, for: .normal)
        }
        return self
    }
    func funj_add(targe : Any, action :String , tag : Int) -> UIButton {
        self.addTarget(targe, action: NSSelectorFromString(action), for: .touchUpInside)
        self.tag = tag
        return self
    }
    func funj_updateContentImage(layout : JButtonContentImageLayout , spacing : CGFloat) -> UIButton {
        return funj_updateContentImage(layout: layout, a: JAlignValue(h: 0, s: spacing, f: 0))
    }
    func funj_updateContentImage(layout : JButtonContentImageLayout ,a align1 : JAlignValue) -> UIButton {
        var align = align1
        var textWidth = JAppUtility.funj_getTextWidthWithView(self)
        let selfWidth = self.width
        let imageWidth = self.imageView?.width ?? 0
        
        let selfHeight = self.height
        let imageHeight = self.imageView?.height ?? 0
        self.contentHorizontalAlignment = .left
        
        switch layout {
        case .kLEFT_IMAGECONTENT:// 图文 靠左
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: align.m_head, bottom: 0, right: 0)
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: align.m_spacing + align.m_head, bottom: 0, right: -align.m_spacing + align.m_foot)
        case .kLEFT_CONTENTIMAGE:// 文图 靠左
            textWidth = min(textWidth, selfWidth - imageWidth - align.m_spacing - align.m_head - align.m_foot)
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth+align.m_head, bottom: 0, right: imageWidth+align.m_foot)
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: textWidth+align.m_spacing+align.m_head, bottom: 0, right: -align.m_spacing+align.m_foot)
        case .kCENTER_IMAGECONTENT:// 图文 靠中间 默认
            align.m_head = min(align.m_foot, align.m_head) ;align.m_foot = align.m_head
            textWidth = min(textWidth, selfWidth - imageWidth-align.m_spacing-align.m_head*2)
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: max((selfWidth-imageWidth-textWidth-align.m_spacing)/2, align.m_head) , bottom: 0, right: 0)
            self.titleEdgeInsets = UIEdgeInsets(top: 0,  left: max((selfWidth-imageWidth-textWidth-align.m_spacing)/2, align.m_head)+align.m_spacing , bottom: 0, right: align.m_foot)
        case .kCENTER_CONTENTIMAGE:// 文图 靠中间
            align.m_head  = min(align.m_foot, align.m_head); align.m_foot = align.m_head
            textWidth = min(textWidth, selfWidth - imageWidth-align.m_spacing-align.m_head*2)
            self.titleEdgeInsets = UIEdgeInsets(top: 0,  left: max((selfWidth-imageWidth-textWidth-align.m_spacing)/2, align.m_head)-imageWidth , bottom: 0, right: imageWidth+align.m_spacing+align.m_foot)
            self.imageEdgeInsets = UIEdgeInsets(top : 0, left: max((selfWidth-imageWidth-textWidth-align.m_spacing)/2, align.m_head)+align.m_spacing+textWidth , bottom:0, right:0);
        case .kRIGHT_IMAGECONTENT:// 图文 靠右
            textWidth = min(textWidth, selfWidth - imageWidth-align.m_spacing-align.m_foot-align.m_head)
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: selfWidth-align.m_foot-align.m_spacing-textWidth-imageWidth, bottom: 0, right: 0)
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: selfWidth-textWidth-align.m_foot-imageWidth, bottom: 0, right: align.m_foot-1)
        case .kRIGHT_CONTENTIMAGE:// 文图 靠右
            textWidth = min(textWidth, selfWidth - imageWidth-align.m_spacing-align.m_foot-align.m_head)//上左下右
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: selfWidth-textWidth-align.m_foot-imageWidth*2-align.m_spacing, bottom: 0, right: 0)
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: selfWidth-imageWidth-align.m_foot, bottom: 0, right: align.m_foot)
        case .kTOP_IMAGECONTENT:// 图文 上下
            align.m_head = min(align.m_foot, align.m_head) ;align.m_foot = align.m_head
            textWidth = min(textWidth, selfWidth - align.m_foot - align.m_head)
            
            self.contentVerticalAlignment = .top;
            let textHeight = JAppUtility.funj_getTextW_Height(self.titleLabel?.text, textFont: self.titleLabel?.font, layoutwidth: self.width , layoutheight : self.titleLabel?.numberOfLines == 0 ? selfHeight - imageHeight : 30 ).height
            self.imageEdgeInsets = UIEdgeInsets(top: (selfHeight-imageHeight-textHeight)/2-align.m_spacing/2, left: (selfWidth-imageWidth)/2-2, bottom: 0, right: 0);
            self.titleEdgeInsets = UIEdgeInsets(top: (selfHeight - imageHeight - textHeight)/2 + imageHeight + align.m_spacing/2,left : (selfWidth - textWidth)/2 - imageWidth, bottom : 0, right: 0);
        case .kTOP_CONTENTIMAGE:// 文图 上下
            align.m_head = min(align.m_foot, align.m_head) ;align.m_foot = align.m_head
            textWidth = min(textWidth, selfWidth - align.m_foot-align.m_head)
            
            self.contentVerticalAlignment = .top;
            let textHeight = JAppUtility.funj_getTextW_Height(self.titleLabel?.text, textFont: self.titleLabel?.font, layoutwidth: self.width , layoutheight : self.titleLabel?.numberOfLines == 0 ? selfHeight - imageHeight : 30 ).height
            self.titleEdgeInsets = UIEdgeInsets(top: (selfHeight - imageHeight - textHeight) / 2 - align.m_spacing / 2, left: (selfWidth - textWidth) / 2 - imageWidth - 2, bottom: 0, right: 0);
            self.imageEdgeInsets = UIEdgeInsets(top: (selfHeight - imageHeight - textHeight) / 2 + imageHeight+align.m_spacing / 2, left: (selfWidth - textWidth) / 2 - imageWidth, bottom: 0, right: 0)
        case .kLEFT_CONTENT_RIGHT_IMAGE:// 左文 右图
            self.contentHorizontalAlignment = .left;
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth + align.m_head, bottom: 0, right: imageWidth + align.m_foot);
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: selfWidth - imageWidth - align.m_foot, bottom: 0, right: -(selfWidth - imageWidth + align.m_foot));
        }
        return self
    }
}

extension UIScrollView {
    convenience init(i frame : CGRect ,delegate : UIScrollViewDelegate?){
        self.init(frame:frame)
        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
        }
        self.delegate = delegate
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
    }
}

extension WKWebView : JWKWebviewDelegate{
    convenience init(i frame : CGRect ,delegate : AnyObject? ,url :String?,callback configCallback : ((_ config : WKWebViewConfiguration)->())? = nil ){
        let config = WKWebViewConfiguration()
        
        let jScript = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'); document.getElementsByTagName('head')[0].appendChild(meta);" //禁止缩放
        
        let wkUScript = WKUserScript(source: jScript, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let wkUController = WKUserContentController()
        wkUController.addUserScript(wkUScript)
        
        config.userContentController = wkUController
        config.allowsInlineMediaPlayback = true
        config.allowsAirPlayForMediaPlayback = true
        configCallback?(config)
        
        self.init(frame : frame , configuration : config)
        self.isOpaque = false //不设置这个值 页面背景始终是白色 设置webview clearColor时使用
        self.backgroundColor = kColor_White_Dark
        self.navigationDelegate = delegate as? WKNavigationDelegate
        self.scrollView.delegate = delegate as? UIScrollViewDelegate
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.showsHorizontalScrollIndicator = false
        let url1 = JAppUtility.funj_getCompleteWebsiteURL(url)
        if url1 != nil {
            guard let urlS = URL(string: url1!) else {return }
            let request = URLRequest(url: urlS)
            self.load(request)
        }
    }
    func funj_addScriptMessageHandler(strongSelf : WKScriptMessageHandler , nameArr : [String]){
        funj_removeScriptMessageHandler(nameArr: nameArr)
        for name in nameArr {
            self.configuration.userContentController.add(strongSelf, name: name)
        }}
    func funj_removeScriptMessageHandler( nameArr : [String]){
        for name in nameArr {
            self.configuration.userContentController.removeScriptMessageHandler(forName: name)
        }}
    func funj_deallocWebView(){
        if self.isLoading == true { self.stopLoading()}
        let wkUController = self.configuration.userContentController
        wkUController.removeAllUserScripts()
        self.navigationDelegate = nil
        self.scrollView.delegate = nil
        self.uiDelegate = nil
    }
}

extension UIBarButtonItem {
    convenience init(i title :String? = nil ,image : String? ,setButton setButtonCallback : kclickCallBack? = nil ,callback :kclickCallBack?) {
        let imageArr = image != nil ? [image!] : nil
        let backButton = UIButton(i: CGRect(x: 0, y: 0, width: 44, height: kNavigationBarHeight), title: title, textFC: JTextFC(f: kFont_Size14, c: kARGBHex(0x333333, 1.0)))
            .funj_add(bgImageOrColor:imageArr , isImage: true)
            .funj_addblock(block: callback)
        setButtonCallback?(backButton)
        self.init(customView : backButton)
    }
    convenience init(i title :String? = nil ,image : String? ,setButton setButtonCallback : kclickCallBack? = nil ,target :Any ,action : String) {
        let imageArr = image != nil ? [image!] : nil
        let backButton = UIButton(i: CGRect(x: 0, y: 0, width: 44, height: kNavigationBarHeight), title: title, textFC: JTextFC(f: kFont_Size14, c: kARGBHex(0x333333, 1.0)))
            .funj_add(bgImageOrColor:imageArr , isImage: true)
            .funj_add(targe: target, action: action, tag: 0)
        setButtonCallback?(backButton)
        self.init(customView : backButton)
    }
}
