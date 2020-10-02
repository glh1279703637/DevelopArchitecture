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

public class JAppUtility : JBaseDataModel {
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
    class func funj_getCompleteWebsiteURL(_ urlStr : String?) -> String? {
        if urlStr == nil { return nil}
        if urlStr!.count <= 4 { return nil}
        
        var urlStr1 = (urlStr?.trimmingCharacters(in: CharacterSet.whitespaces))
        let urlStr2 = urlStr1! as NSString
        
        let range = urlStr2.range(of: "://")
        if range.location == NSNotFound {
            urlStr1 = "http://" + urlStr1!
        }
        return urlStr1
    }
    
    class func funj_isFileExit(_ path : String?) -> Bool {
        if path == nil { return false}
        return FileManager.default.fileExists(atPath: path!)
    }
    
    class func funj_createDirector(_ path : String?)  -> Bool{
        if path == nil { return false}
        return  FileManager.default.createFile(atPath: path!, contents: nil, attributes: nil)
    }
    
    class func funj_md5(_ str:String) -> String{
        let utf8 = str.cString(using: .utf8)
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5(utf8, CC_LONG(utf8!.count - 1), &digest)
        let md5Str = digest.reduce("") { $0 + String(format:"%02X", $1) }
        return md5Str.lowercased()
    }
    
    class func funj_getTextW_Height(_ content : String? ,textFont : UIFont? , layoutwidth : CGFloat, layoutheight : CGFloat) -> CGSize {
        var textSize = CGSize(width: layoutwidth, height: layoutheight)
        
        if content == nil || content!.count <= 0 || textFont == nil { return CGSize(width: 0, height: 0)}
        textSize = content?.boundingRect(with: textSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : textFont!], context: nil).size ?? CGSize(width: 0, height: 0)
        
        return textSize
    }
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
        return textSize.height + 3
    }
    
    class func funj_getDateTime(_ formmat : String?) -> String{
        let currentDate : Date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = formmat ?? "yyyyMMddHHmmss"
        return formatter.string(from: currentDate)
    }
    
    
}

