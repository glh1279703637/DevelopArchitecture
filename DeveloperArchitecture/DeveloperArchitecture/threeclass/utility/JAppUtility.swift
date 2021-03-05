//
//  JAppUtility.swift
//  DeveloperArchitecture
//
//  Created by Jeffrey on 2020/9/29.
//  Copyright © 2020 Jeffery. All rights reserved.
//
import UIKit
import Foundation
import CommonCrypto
import WebKit

// MARK: - UIResponder
// TODO: UIResponder
// FIXME: UIResponder
protocol JAppUtilityDelegate {
    //获取temp中basepath 文件夹中的file文件路径
    static func funj_getTempPath(_ basepath : String? , fileName : String?) -> String
    
    //将url转化成标准url
    static func funj_getCompleteWebsiteURL(_ urlStr : String?) -> String?
    
    //判断文件是否存在
    static func funj_isFileExit(_ path : String?) -> Bool
    //创建文件目录
    static func funj_createDirector(_ path : String?)  -> Bool
    
    //获取文本内容的高度，辅助前两个方法，用来返回控件高度 宽度；
    static func funj_getTextW_Height(_ content : String? ,textFont : UIFont? , layoutwidth : CGFloat, layoutheight : CGFloat) -> CGSize
    
    //获得字符串的长度
    static func funj_getTextWidthWithView(_ view : UIView) -> CGFloat
    
    // 通过控件返回控件高度；
    static func funj_getAttriTextHeightWithView(_ view : UIView , maxHeight : CGFloat) -> CGFloat
    
    //图片 压缩算法 上传时候处理
    static func funj_compressImage(_ image : UIImage? , sizeM : CGFloat) -> Data?
    //通过颜色转图片
    static func funj_imageWithColor(_ color : UIColor ,size : CGSize) -> UIImage?
    
    //判断字符串是否为整数类型
    static func funj_isPureInt(_ string : String?) -> Bool
    
    //通过手机号获取 145***124等类型数据
    static func funj_getHiddenMobile(_ mobile : String?) -> String?
    
    //判断手机号码，电话号码函数
    static func funj_isMobileNumber(_ mobileNum : String? ) -> Bool
    
    //判断是字符串是否只含有数字、字母
    static func funj_isCheckNameIsRight(_ name : String?) ->Bool
    
    //邮箱地址的正则表达式
    static func funj_isValidateEmail(_ email : String?) ->Bool
    
    // 验证数据合法性 allName email name mobile code password surePassword answer isAgree
    static func funj_isCheckMobile_Password_CodeIsRight(_ viewVC : UIViewController,data : Dictionary<String,String>) -> Bool
    
    //对象转化成字符串  nssarray->string or....
    static func funj_stringFromObject(_ dict : Dictionary<String,Any>? ) -> String?
    
    //字符串转化成对象  string->nsarray or....
    static func funj_objectFromString(_ string : String?) -> AnyObject?
    
    //获取当前时间
    static func funj_getDateTime(_ formmat : String?) -> String
    
    //获取通过类名获取对象
    static func funj_getObjectWithClass(_ className : AnyClass?) ->AnyObject?
    
    //获取验证码 的时间处理
    static func funj_getTheTimeCountdownWithCode(_ getCodeBt :UIButton , defaultBoardColor: UIColor)
    
    //是否含有表情
    static func funj_stringContainsEmoji(_ string : String?) -> Bool
    
    //汉字转化成拼音
    static func funj_pinyinFromChineseString(_ string : String?) -> String?
    
    //上下震动效果 或者左右 width 左右偏移，height 上下偏移
    static func funj_shakeAnimationForView(_ view : UIView , offset : CGSize )
    
    //color效果 放大缩小
    static func funj_changeColorAnimationForView(_ view : UIView )
    
    //expand效果 放大缩小
    static func funj_expandAnimationForView(_ view : UIView ,e : Double)
    
    //视图进入动画  type:kCATransitionPush  subtype:kCATransitionFromLeft
    static func funj_transitionWithType(_ type : CATransitionType ,subType : CATransitionSubtype? ,view : UIView )
    
    // 去掉HTML标签
    static func funj_filterHTML(_ html : String? ) -> String?
    
    //清除网页cookies
    static func funj_clearWebViewCookies()
    
    //获取字串长度 专在shouldChangeCharactersInRange 使用 textfield texview
    static func funj_getTextFieldLength(TFText : String , range : NSRange , string :String ,maxLength : Int) -> String?
    
    static func funj_checkAppStoreVersion(_ appleId : String?)
    
    /*本地通知 显示结果
     *-- title
     *-- subtitle
     *-- content -- contentRightImage
     */
    static func funj_postLocalNotifation(title:String,subTitle:String,body:String,image:String?)
}

public class JAppUtility : JBaseDataModel , JAppUtilityDelegate{
    //获取temp中basepath 文件夹中的file文件路径
    class func funj_getTempPath(_ basepath : String? , fileName : String?) -> String{
        var temp = NSTemporaryDirectory()
        if basepath != nil {
            temp += basepath!
        }
        if fileName != nil {
            temp += fileName!
        }
        return temp
    }
    //将url转化成标准url
    class func funj_getCompleteWebsiteURL(_ urlStr : String?) -> String? {
        if urlStr == nil || urlStr!.count <= 4 { return nil}
        
        var urlStr1 = (urlStr?.trimmingCharacters(in: CharacterSet.whitespaces))
        let urlStr2 = urlStr1! as NSString
        
        let range = urlStr2.range(of: "://")
        if range.location == NSNotFound {
            urlStr1 = "http://" + urlStr1!
        }
        return urlStr1
    }
    //判断文件是否存在
    class func funj_isFileExit(_ path : String?) -> Bool {
        if path == nil { return false}
        return FileManager.default.fileExists(atPath: path!)
    }
    
    class func funj_createDirector(_ path : String?)  -> Bool{
        if path == nil { return false}
        return  FileManager.default.createFile(atPath: path!, contents: nil, attributes: nil)
    }
    //获取文本内容的高度，辅助前两个方法，用来返回控件高度 宽度；
    class func funj_getTextW_Height(_ content : String? ,textFont : UIFont? , layoutwidth : CGFloat, layoutheight : CGFloat) -> CGSize {
        if content == nil || content!.count <= 0 || textFont == nil { return CGSize(width: 0, height: 0)}
        var textSize = CGSize(width: layoutwidth, height: layoutheight)
        textSize = content?.boundingRect(with: textSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : textFont!], context: nil).size ?? CGSize(width: 0, height: 0)
        
        return textSize
    }
    //获得字符串的长度
    class func funj_getTextWidthWithView(_ view : UIView) -> CGFloat {
        var textSize = CGSize(width: CGFloat(MAXFLOAT), height: view.bounds.height)
        
        var font:UIFont = UIFont.systemFont(ofSize: 14)
        var title:String = ""
        if view.classForCoder == UIButton.classForCoder() {
            font = (view as! UIButton).titleLabel?.font ?? font
            title = (view as! UIButton).titleLabel?.text ?? title
        }else if view.classForCoder == UILabel.classForCoder() || view.classForCoder == UITextView.classForCoder() || view.classForCoder == UITextField.classForCoder() {
            font = (view as! UILabel).font ?? font
            title = (view as! UILabel).text ?? title
        }
        
        textSize = funj_getTextW_Height(title, textFont: font, layoutwidth: CGFloat(MAXFLOAT), layoutheight: view.bounds.height)
        return textSize.width
    }
    // 通过控件返回控件高度；
    class func funj_getAttriTextHeightWithView(_ view : UIView , maxHeight : CGFloat) -> CGFloat {
        var textSize = CGSize(width: view.bounds.width, height: CGFloat(MAXFLOAT))
        var attri : NSMutableAttributedString?
        var isNeedRemove = false
        if view.classForCoder == UIButton.classForCoder() {
            attri = (view as! UIButton).titleLabel?.attributedText as? NSMutableAttributedString
            isNeedRemove = (view as! UIButton).titleLabel?.numberOfLines == 0
        }else if view.classForCoder == UILabel.classForCoder() || view.classForCoder == UITextView.classForCoder() || view.classForCoder == UITextField.classForCoder() {
            attri = (view as! UILabel).attributedText as? NSMutableAttributedString
            isNeedRemove = ((view.classForCoder == UILabel.classForCoder() && (view as! UILabel).numberOfLines == 0) || view.classForCoder == UITextView.classForCoder())
        }
        if isNeedRemove {
            if attri?.classForCoder == NSMutableAttributedString.classForCoder() {
                attri = NSMutableAttributedString(attributedString: attri!)
            }
            attri?.removeAttribute(NSAttributedString.Key.paragraphStyle, range: NSMakeRange(0, attri?.length ?? 0))
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 5
            attri?.addAttributes([NSAttributedString.Key.paragraphStyle:paragraphStyle], range: NSMakeRange(0, attri?.length ?? 0))
        }
        textSize = attri?.boundingRect(with: textSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil).size ?? CGSize(width: 0, height: 0)
        return min(textSize.height + 3, maxHeight ==  -1 ? CGFloat(MAXFLOAT) : maxHeight)
    }
    //图片 压缩算法 上传时候处理
    class func funj_compressImage(_ image : UIImage? , sizeM : CGFloat) -> Data?{
        // Compress by quality
        if image == nil { return nil}
        var sizeM = sizeM
        if sizeM == -1 { sizeM = 0.4 + kis_IPad_1 * 0.3}
        let maxLength = 1024 * 1024 * sizeM
        
        var compression : CGFloat = 1
        var data = image?.jpegData(compressionQuality: compression)
        if CGFloat(data?.count ?? 0) < maxLength { return data}
        
        var max : CGFloat = 1 ; var min : CGFloat = 0
        for _ in 0..<6 {
            compression = max + min
            data = image?.jpegData(compressionQuality: compression)
            
            if CGFloat(data?.count ?? 0) > maxLength * 0.8 {
                min = compression
            } else if CGFloat(data?.count ?? 0) > maxLength {
                max = compression
            } else { break}
        }
        if CGFloat(data?.count ?? 0) < maxLength || data == nil { return data }
        var resultImage = UIImage.init(data: data!)
        if resultImage == nil { return nil}
        var lastDataLength  = 0
        while CGFloat(data?.count ?? 0) > maxLength && data?.count ?? 0 != lastDataLength {
            lastDataLength = data?.count ?? 0
            let radio = Float(maxLength) / Float(data?.count ?? 1)
            let size = CGSize(width: resultImage!.size.width * CGFloat(sqrtf(radio)) , height: resultImage!.size.height * CGFloat(sqrtf(radio)))
            
            UIGraphicsBeginImageContext(size)
            resultImage?.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            resultImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            data = image?.jpegData(compressionQuality: compression)
        }
        Cprint("After compressing size loop, image size = \(data?.count ?? 0 / 1024) KB")
        return data
    }
    class func funj_imageWithColor(_ color : UIColor ,size : CGSize) -> UIImage?{
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    //判断字符串是否为整数类型
    class func funj_isPureInt(_ string : String?) -> Bool {
        if string == nil {return false}
        let scan: Scanner = Scanner(string: string!)
        var val:Int = 0
        return scan.scanInt(&val) && scan.isAtEnd
    }
    //通过手机号获取 145***124等类型数据
    class func funj_getHiddenMobile(_ mobile : String?) -> String?{
        if mobile == nil || mobile!.count <= 0 {return nil}
        let width = min(mobile!.count, 3)
        let mobileStr = mobile! as NSString
        let str = "\(mobileStr.substring(to: width))***\(mobileStr.substring(from: width))"
        return str
    }
    //判断手机号码，电话号码函数
    class func funj_isMobileNumber(_ mobileNum : String? ) -> Bool {
        if mobileNum == nil { return false}
        let mobile = "^1[0-9][0-9]\\d{8}$"
        let regexMobile = NSPredicate(format: "SELF MATCHES \(mobile)")
        if regexMobile.evaluate(with: mobileNum!) {return true}
        return false
    }
    //判断是字符串是否只含有数字、字母
    class func funj_isCheckNameIsRight(_ name : String?) ->Bool {
        if name == nil {return false}
        let mobile = "([0-9a-zA-Z]){6,17}";//只有数据字母
        let regexMobile = NSPredicate(format: "SELF MATCHES \(mobile)")
        if regexMobile.evaluate(with: name!) {return true}
        return false
    }
    //邮箱地址的正则表达式
    class func funj_isValidateEmail(_ email : String?) ->Bool {
        if email == nil { return false}
        let mobile = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";//只有数据字母
        let regexMobile = NSPredicate(format: "SELF MATCHES \(mobile)")
        if regexMobile.evaluate(with: email!) {return true}
        return false
    }
    // 验证数据合法性 allName email name mobile code password surePassword answer isAgree
    class func funj_isCheckMobile_Password_CodeIsRight(_ viewVC : UIViewController,data : Dictionary<String,String>) -> Bool{
        let allName = data["allName"]
        let email = data["email"]
        let name = data["name"]
        let mobile = data["mobile"]
        let oldMobile = data["oldMobile"]
        let code = data["code"]
        let oldCode = data["oldCode"]
        let password = data["password"]
        let surePassword = data["surePassword"]
        let answer = data["answer"]
        let isAgree = data["isAgree"]
        var title:String?;
        
        if allName != nil && JAppUtility.funj_isCheckNameIsRight(allName) && allName!.contains("@") {
            title = kLocalStr("Please input account with 6-17 letters and numbers")
        }

        if allName != nil && JAppUtility.funj_isValidateEmail(allName!)  && title == nil {
            title = kLocalStr("Please input correct email");
        }
        if name != nil && (JAppUtility.funj_isCheckNameIsRight(name) == false || JAppUtility.funj_isPureInt(name!)) && title == nil {
            title = kLocalStr("Please input account with 6-17 letters and numbers")
        }
        if email != nil &&  JAppUtility.funj_isValidateEmail(email)  && title == nil {
            title = kLocalStr("Please input correct email")
        }
        if oldMobile != nil  && oldMobile!.count<=0 {
            title = kLocalStr("Mobile is required")
            if oldMobile != nil || code != nil { title = kLocalStr("Original") + title!  }
        }
        if oldMobile != nil  && JAppUtility.funj_isMobileNumber(oldMobile) &&  title == nil {
            title = kLocalStr("Please input correct Original mobile")
        }
        if mobile != nil  && mobile!.count <= 0   && title == nil {
            title = kLocalStr("Mobile is required")
            if oldMobile != nil || code != nil {
                title = kLocalStr("New") + title!
            }
        }
        if mobile != nil && JAppUtility.funj_isMobileNumber(mobile) && title == nil {
            title = kLocalStr("Please input correct mobile")
            if oldMobile != nil || code != nil {
                title = kLocalStr("Please input correct New mobile")
            }
        }
        if mobile != nil  && oldMobile != nil  && title == nil {
            title = kLocalStr("Old and new mobile cannot be the same");
        }
        if oldCode != nil  &&  (JAppUtility.funj_isPureInt(oldMobile) && oldCode!.count==6) == false && title == nil{
            title = kLocalStr("Please input correct verification number")
            if oldMobile != nil || code != nil {
                title = kLocalStr("Please input correct Original verification number")
            }
        }
        if code != nil  &&  (JAppUtility.funj_isPureInt(code) && code!.count==6) == false && title == nil{
            title = kLocalStr("Please input correct verification number")
            if oldMobile != nil || code != nil {
                title = kLocalStr("Please input correct New verification number")
            }
        }
        if password != nil && (password!.count < 6 || password!.count > 16) && title == nil {
            title = kLocalStr("Please input password between 6 and 16 bits");
        }
        if surePassword != nil && surePassword != password && title == nil {
            title = kLocalStr("Password is not consistent");
        }
        if answer != nil && answer!.count <= 0  && title == nil {
            title = kLocalStr("Please input the answer");
        }
        if isAgree != nil && isAgree != "1"  && title == nil{
            title = kLocalStr("Please click to confirm the user agreement");
        }
        if title != nil {
//            if viewVC != nil {JAppViewTools.funj_showAlertBlock(viewVC,)}
            return false
        }

        return true;
    }
    //对象转化成字符串  nssarray->string or....
    class func funj_stringFromObject(_ dict : Dictionary<String,Any>? ) -> String? {
        if dict == nil { return nil }
        var jsonString : String? = nil
        let jsonData = try? JSONSerialization.data(withJSONObject: dict!, options: JSONSerialization.WritingOptions.prettyPrinted)
        if jsonData != nil {
            jsonString = String(data: jsonData!, encoding: .utf8)
        }
        return jsonString
    }
    //字符串转化成对象  string->nsarray or....
    class func funj_objectFromString(_ string : String?) -> AnyObject? {
        if string == nil || string?.count == 0 { return nil}
        let data = string?.data(using: .utf8)
        let object = try? JSONSerialization.jsonObject(with: data!, options:[ .allowFragments , .mutableLeaves , .mutableContainers])
        return object as AnyObject
    }
    //获取当前时间
    class func funj_getDateTime(_ formmat : String?) -> String{
        let currentDate : Date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = formmat ?? "yyyyMMddHHmmss"
        return formatter.string(from: currentDate)
    }
    //获取通过类名获取对象
    class func funj_getObjectWithClass(_ className : AnyClass?) ->AnyObject? {
        if let className = className as? NSObject.Type {
            let object = className.init()
            return object
        }
        return nil
    }

//    class func funj_getObjectWithClass(_ className : String? , type : NSInteger) ->AnyObject? {
//        if className == nil { return nil}
//        var preStr = Bundle.main.infoDictionary?["CFBundleExecutable"] as? String
//        preStr = preStr?.replacingOccurrences(of: "-", with: "_")
////        let vcClass = NSClassFromString(preStr! + "." + className) as! JBaseView.Type
//        let vcClass: AnyClass? = NSClassFromString(preStr! + "." + className!)
//        var object : AnyObject? = nil
//
//        if vcClass != nil {
//            if type == 0 { object = vcClass?.alloc() as! JBaseViewController}
//            else if type == 1 { object = vcClass?.alloc() as! JBaseView}
//            else if type == 2 { object = vcClass?.alloc() as! JBaseDataModel}
//        }
//
//        return object
//    }
    //获取验证码 的时间处理
    class func funj_getTheTimeCountdownWithCode(_ getCodeBt :UIButton , defaultBoardColor: UIColor) {
        getCodeBt.isUserInteractionEnabled  = false
        getCodeBt.isSelected = true
        getCodeBt.layer.borderColor = kColor_Line_Gray_Dark.cgColor
        
        var timeout = 60 //倒计时时间
        let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())
        timer.schedule(deadline: DispatchTime.now(), repeating: .seconds(1), leeway: .milliseconds(10))
        timer.setEventHandler {[weak getCodeBt] in
            DispatchQueue.main.sync { [weak getCodeBt] in
                if timeout <= 0 {
                    getCodeBt?.setTitle(kLocalStr("Get verification code"), for: .normal)
                    getCodeBt?.isUserInteractionEnabled = true
                    getCodeBt?.isSelected = false
                    getCodeBt?.layer.borderColor = defaultBoardColor.cgColor
                    timer.cancel()
                }else {
                    let strTime = String(format: "%02d", timeout)
                    getCodeBt?.setTitle(strTime, for: .normal)
                }
                timeout -= 1
            }
        }
        timer.resume()
    }
    //是否含有表情
    class func funj_stringContainsEmoji(_ string : String?) -> Bool{
        if string == nil { return false}
        let regex = try? NSRegularExpression.init(pattern: "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]", options: .caseInsensitive)
        let modifiedString = regex?.stringByReplacingMatches(in: string! , options: [], range: NSMakeRange(0, string!.count), withTemplate: "")
        return modifiedString?.count != string?.count
    }
    //汉字转化成拼音
    class func funj_pinyinFromChineseString(_ string : String?) -> String?{
        if string == nil { return nil}
        CFStringTransform((string as! CFMutableString), nil, kCFStringTransformToLatin, false)
        let mutablestr = string?.folding(options: .diacriticInsensitive, locale: Locale.current)
        
        return mutablestr?.replacingOccurrences(of: " ", with: "")
    }
    //上下震动效果 或者左右 width 左右偏移，height 上下偏移
    class func funj_shakeAnimationForView(_ view : UIView , offset : CGSize ){
        let viewLayer = view.layer
        let postion = viewLayer.position
        let left = CGPoint(x: postion.x - offset.width, y: postion.y - offset.height)
        let right = CGPoint(x: postion.x + offset.width, y: postion.y + offset.height)
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.fromValue = NSValue(cgPoint: left)
        animation.toValue = NSValue(cgPoint: right)
        animation.autoreverses =  true
        animation.duration = 0.08
        animation.repeatCount = 3
        
        viewLayer.add(animation, forKey: nil)
    }
    //color效果 放大缩小
    class func funj_changeColorAnimationForView(_ view : UIView ){
        let viewLayer = view.layer
        let animation = CABasicAnimation(keyPath: "backgroundColor")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.fromValue = kRGB(red: 230, green: 230, blue: 230, alpha: 0.5)
        animation.toValue = kRGB(red: 200, green: 200, blue: 200, alpha: 0.8)
        animation.autoreverses =  true
        animation.duration = 0.05
        animation.repeatCount = 1
        viewLayer.add(animation, forKey: nil)
    }
    //expand效果 放大缩小
    class func funj_expandAnimationForView(_ view : UIView ,e : Double){
        let viewLayer = view.layer
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.fromValue = NSNumber.init(floatLiteral: 1.0 - e)
        animation.toValue = NSNumber.init(floatLiteral: 1.0 + e)
        animation.autoreverses =  true
        animation.duration = 0.03
        animation.repeatCount = 1
        viewLayer.add(animation, forKey: nil)
    }
    //视图进入动画  type:kCATransitionPush  subtype:kCATransitionFromLeft
    class func funj_transitionWithType(_ type : CATransitionType ,subType : CATransitionSubtype? ,view : UIView ){
        let animation = CATransition()
        animation.duration = 0.4
        animation.type = type
        if subType != nil {
            animation.subtype = subType!
        }
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.layer.add(animation, forKey: "animation")
    }
    // 去掉HTML标签
    class func funj_filterHTML(_ html : String? ) -> String?{
        if html == nil || html!.count <= 0 { return nil}
        var htmls = html
        let scanner = Scanner(string: htmls!)
        var str:NSString? = NSString()
        while scanner.isAtEnd == false {
            scanner.scanString("<", into: nil)
            scanner.scanString(">", into: &str)
            if str != nil {
                htmls = htmls?.replacingOccurrences(of: (str! as String) , with: "")
            }
        }
        return htmls
    }
    //清除网页cookies
    class func funj_clearWebViewCookies(){
        let websiteDataTypes = WKWebsiteDataStore.allWebsiteDataTypes()
        let date = Date.init(timeIntervalSince1970: 0)
        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes, modifiedSince: date) {}
    }
    //获取字串长度 专在shouldChangeCharactersInRange 使用 textfield texview
    class func funj_getTextFieldLength(TFText : String , range : NSRange , string :String ,maxLength : Int) -> String? {
        if TFText.count + string.count > maxLength {
            var insertLenght = maxLength - TFText.count
            insertLenght = insertLenght <= 0 ? 0 : insertLenght
            
            let firstLenght = range.location < TFText.count ? range.location : TFText.count
            let endLength = maxLength - range.location - insertLenght
            
            let textStr = "\((TFText as NSString) .substring(with: NSMakeRange(0, firstLenght)))\(((string as NSString) .substring(with: NSMakeRange(0, insertLenght))))\(((TFText as NSString) .substring(with: NSMakeRange(range.location, endLength))))"
            return textStr
        }
        return nil
    }
    class func funj_checkAppStoreVersion(_ appleId : String?){
        if appleId == nil || appleId!.count <= 0 { return }
//        guard let url = URL(string: "http://itunes.apple.com/lookup?id=\(appleId)") else { return }
//        let request = URLRequest.init(url: url)
//        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
//            if error != nil || data == nil { return}
//            let receiDic = try? JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as! Dictionary<String, Any>
//            let resultCount : Int = receiDic?["resultCount"] as! Int
//
//            if resultCount  <= 0 {return}
//            let localVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"]
//            let results = receiDic?["results"]
//            for dic in results {
//                let newVersion = dic["version"]
//
//            }
//
//
//        }
    }
    
    /*本地通知 显示结果
     *-- title
     *-- subtitle
     *-- content -- contentRightImage
     */
    class func funj_postLocalNotifation(title:String,subTitle:String,body:String,image:String?){
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subTitle
        content.body = body
        content.badge = NSNumber(value: UIApplication.shared.applicationIconBadgeNumber)
        content.sound = UNNotificationSound.default
        
        let imageFile = Bundle.main.path(forResource: image, ofType: "png")
        if imageFile?.count ?? 0 > 0 {
            let imageAttachment = try? UNNotificationAttachment(identifier: "imageAttachment", url: URL(fileURLWithPath: imageFile!), options: nil)
            if imageAttachment != nil {
                content.attachments = [imageAttachment!]
            }
        }
        //第三步：通知触发机制。（重复提醒，时间间隔要大于60s）
        let trigger1 = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                   
        //第四步：创建UNNotificationRequest通知请求对象
        let request = UNNotificationRequest(identifier: "RequestIdentifier", content: content, trigger: trigger1)
            
        //第五步：将通知加到通知中心
        UNUserNotificationCenter.current().add(request) { (error) in
            print("Error :\(String(describing: error))")
        }
    }
}

