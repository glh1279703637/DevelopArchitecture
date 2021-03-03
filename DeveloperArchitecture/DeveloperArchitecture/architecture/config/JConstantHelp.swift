//
//  JConstantHelp.swift
//  DeveloperArchitecture
//
//  Created by Jeffrey on 2020/9/25.
//

import Foundation
import UIKit

//是否为中文模式
var kisZhHans : Bool { NSLocale.preferredLanguages[0].hasPrefix("zh-Han") }

// 是否是ipad 模式
let kis_IPad = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
let kis_IPad_1 = (kis_IPad ? CGFloat(1.0) : CGFloat(0.0))


@available(iOS 14.0, *)
let kis_Mac = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.mac

let kappVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
let kappBuildCode = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String

func kLocalStr(_ str:String) -> String { return NSLocalizedString(str, comment: "")  }
//对参数进行base64加密过  此两个方法多注意点，原理同样
func kLocalStre(_ str:String) -> String? {
    let name = NSLocalizedString(str, comment: "")
    let result = JCryptHelp.funj_scaCrypt(string: name, cryptType: .DES3, key: "DeveloperArchitecture", encode: false)
    return result
}

//是否为深色模式
var kcurrentUserInterfaceStyleModel : Int {
    var model = 0
    if #available(iOS 12.0, *) {
        model = (JAppViewTools.funj_getTopVC()?.traitCollection.userInterfaceStyle)!.rawValue
    }; return model
}
    
//颜色 hex 16进制
let kARGBHex = { (_ rgb:UInt,_ alpha:CGFloat) ->UIColor in UIColor(red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0, green: CGFloat((rgb & 0xFF00) >> 8) / 255.0,  blue: CGFloat(rgb & 0xFF) / 255.0, alpha: alpha) }

func kRGB (red:CGFloat,green:CGFloat,blue:CGFloat,alpha:CGFloat = 1)  -> UIColor {
    return UIColor.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: alpha)
}
var krandomColor : UIColor { kRGB(red: CGFloat(arc4random() % 255), green: CGFloat(arc4random() % 255), blue: CGFloat(arc4random() % 255))
}
func kColor_Dark(_ nor:UIColor ,_ dark:UIColor) -> UIColor {
    var color = nor;
    if #available(iOS 13.0, *) {
        color = UIColor.init(dynamicProvider: { (traitCollection:UITraitCollection) -> UIColor in
            if traitCollection.userInterfaceStyle == UIUserInterfaceStyle.dark {
                return dark
            }else {
                return nor
            }
        })
    }else if #available(iOS 12.0, *) {
        if kcurrentUserInterfaceStyleModel == UIUserInterfaceStyle.dark.rawValue {
            color = dark
        }
    }
    return color;
}

var kSafeAreaInsets : UIEdgeInsets {
    var e = UIEdgeInsets.zero
    if #available(iOS 11.0, *) {
        e = UIApplication.shared.windows.first?.safeAreaInsets ?? e
    }
    e.top = max(UIApplication.shared.statusBarFrame.height, e.top)
    return e
}

var kStatusBarHeight : CGFloat { kSafeAreaInsets.top }

var kFilletSubHeight : CGFloat { kSafeAreaInsets.bottom }

#if TARGET_OS_MACCATALYST
var kWindowSceneSize : CGSize {
    var size = CGSize.init(width: 1050.0, height: 797.0)
    if #available(iOS 13.0, *) {
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        size = keyWindow?.bounds.size ?? size
    }
    return size 
}
var kWidth :CGFloat { kWindowSceneSize.width }
var kHeight :CGFloat { kWindowSceneSize.height }
#else
var kWidth : CGFloat { UIScreen.main.bounds.width }
var kHeight : CGFloat { UIScreen.main.bounds.height }
#endif

var kNavigationBarHeight : CGFloat { (Double(UIDevice.current.systemVersion) ?? 0 >= 12.0 && kis_IPad) ? CGFloat(50.0) : CGFloat(44.0) }
var kNavigationBarBottom : CGFloat { (kNavigationBarHeight+kStatusBarHeight) }

let kWidthT = { (_ x : CGFloat) -> CGFloat in x * kWidth / 375.0 }

var kHeight64 : CGFloat { (kHeight - kNavigationBarBottom) }
var kWidthM : CGFloat { (kis_IPad ? 375.0 : kWidth) }
var kWidthD : CGFloat { (kis_IPad ? (kWidth - kWidthM - 0.5) : kWidth) }
var kWidthMin : CGFloat { min(kWidth, kHeight) }
var kHeightMax : CGFloat { max(kWidth, kHeight) }

var kTabbarHeight : CGFloat { (kFilletSubHeight+50.0) }

let CGRectZero = CGRect(x: 0, y: 0, width: 0, height: 0)
let UIEdgeInsetsZero = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

//图片宽高比例
let kImageViewHeight = { (_ width:CGFloat) -> CGFloat in width * 9 / 16 }

//数字 大于某值是使用w表示
let kNUMBERS = { (_ num:CGFloat) -> String in String( num > 10000 ? "\(Int(num/10000))w+" : num > 1000 ? "\(Int(num/1000))k+" :"\(Int(num))") }

//常用颜色 v2
let kColor_Clear = UIColor.clear//无色
let kColor_Blue = kARGBHex(0x3899ff,1)//状态栏的颜色 蓝色

let kColor_White = kARGBHex(0xffffff,1)//白色
let kColor_White_Dark = kColor_Dark(kARGBHex(0xffffff,1),kARGBHex(0x5a5a5a,1))//白色

let kColor_Orange = kARGBHex(0xff8338,1)//橘色
let kColor_Shallow_Orange = kARGBHex(0xFCAA4B,1)//浅橘色
let kColor_Green = kARGBHex(0x33c764,1)//绿色

let kColor_Text_Black = kARGBHex(0x333333,1)//字体黑色
let kColor_Text_Black_Dark = kColor_Dark(kARGBHex(0x333333,1),kARGBHex(0xffffff,1))//字体黑色

let kColor_Text_GRAY = kARGBHex(0x999999,1)//字体灰色
let kColor_Text_GRAY_Dark = kColor_Dark(kARGBHex(0x999999,1),kARGBHex(0xcccccc,1))//字体灰色

let kColor_Bg_Lightgray = kARGBHex(0xf0f1f5,1)//灰色背景色
let kColor_Bg_Lightgray_Dark = kColor_Dark(kARGBHex(0xf0f1f5,1),kARGBHex(0x9e9e9e,1))//灰色背景色

let kColor_Bg_Shallow_Lightgray = kARGBHex(0xf7f7f8,1)//灰色浅背景色
let kColor_Bg_Shallow_Lightgray_Dark =     kColor_Dark(kARGBHex(0xf7f7f8,1),kARGBHex(0x797979,1))//灰色浅背景色

let kColor_Red = kARGBHex(0xf04d4d,1) //红色

let kColor_Bg_Dark = kColor_Dark(kColor_Clear,kARGBHex(0x5a5a5a,1))//dark 深色模式

let kColor_Line_Gray = kARGBHex(0xe1e1e1,1)//线色
let kColor_Line_Gray_Dark = kColor_Dark(kARGBHex(0xe1e1e1,1),kARGBHex(0x9e9e9e,1))//线色


func kfontSize(_ num : CGFloat ,num2 : CGFloat , isBold : Bool = false) -> UIFont {
    if isBold {
        return (kisZhHans ?  UIFont.systemFont(ofSize: num):UIFont.systemFont(ofSize: num2 ) )
    } else {
        return (kisZhHans ? UIFont.boldSystemFont(ofSize: num):UIFont.boldSystemFont(ofSize: num2 ) )
    }
}


var kFont_Size20 = kfontSize(20 ,num2 : 18)
var kFont_Size18 = kfontSize(18 ,num2 : 16)
var kFont_Size17 = kfontSize(17 ,num2 : 15)
var kFont_Size16 = kfontSize(16 ,num2 : 15)
var kFont_Size15 = kfontSize(15 ,num2 : 13)
var kFont_Size14 = kfontSize(14 ,num2 : 12)
var kFont_Size13 = kfontSize(13 ,num2 : 12)
var kFont_Size12 = kfontSize(12 ,num2 : 12)
var kFont_Size11 = kfontSize(11 ,num2 : 11)
var kFont_Size10 = kfontSize(10 ,num2 : 10)

var kFont_BoldSize20 = kfontSize(20 ,num2 : 18 ,isBold: true)
var kFont_BoldSize18 = kfontSize(18 ,num2 : 16 ,isBold: true)
var kFont_BoldSize17 = kfontSize(17 ,num2 : 15 ,isBold: true)
var kFont_BoldSize16 = kfontSize(16 ,num2 : 14 ,isBold: true)
var kFont_BoldSize15 = kfontSize(15 ,num2 : 13 ,isBold: true)
var kFont_BoldSize14 = kfontSize(14 ,num2 : 12 ,isBold: true)
var kFont_BoldSize12 = kfontSize(12 ,num2 : 11 ,isBold: true)
var kFont_BoldSize11 = kfontSize(11 ,num2 : 10 ,isBold: true)
var kFont_BoldSize10 = kfontSize(10 ,num2 : 9  ,isBold: true)

#if DEBUG
func Cprint(_ str:String)  {
//    print("\(#file) . \(#function) :[\(#line)] \(str)")
    print(str)
}
#else
func Cprint(str:String)  {}
#endif


let kWidth1 = UIScreen.main.bounds.width
var kWidth2 : CGFloat { UIScreen.main.bounds.width }
var kWidth3 : CGFloat { return UIScreen.main.bounds.width }
let kWidth4 = { () -> CGFloat in  UIScreen.main.bounds.width}
let kWidth5 = { () -> CGFloat in return UIScreen.main.bounds.width}
var kWidth6 :CGFloat = { return  UIScreen.main.bounds.width }()

/*
 //调用方法 print("-- \(kWidth1)-- \(kWidth2)-- \(kWidth3())-- \(kWidth4())-- \(kWidth5)")
 // 其中 kWidth1 ,kWidth6 只获取一次，即使旋转屏幕也不变
 // 其中 kWidth2,kWidth3 ,kWidth4() ,kWidth5() 每次获取，旋转屏幕可变
 //另外：kWidth6 一般加上 lazy 进行 懒加载
 */
 
/*
 宏定义 调用标准
 * 1.还参数进行宏定义 : let , func
 * 1.1 只有一行实现代码 ： let kLocalStr = { (_ str:String) -> String in 【return】  NSLocalizedString(str, comment: "") }
 * 其中 【return】 可有可无
 
 * 1.1.1 只有一行实现代码  但还默认值【alpha:CGFloat = 1】
      func kRGB (red:CGFloat,green:CGFloat,blue:CGFloat,alpha:CGFloat = 1)  -> UIColor {
          return UIColor.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: alpha)
      }
 
 *1.2 多行代码实现 :
     func kLocalStre(str:String) -> String? {
         let name = NSLocalizedString(str, comment: "")
         let result = JCryptHelp.funj_scaCrypt(string: name, cryptType: .DES3, key: "DeveloperArchitecture", encode: false)
         return result
     }
 
 * 2.不带参数进行宏义 ： let  , var
 * 2.1 不可变 ： let kis_IPad = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad

 * 2.2 可变1 ： 只有一行代码实现 ： var kisZhHans : Bool { 【return】 NSLocale.preferredLanguages[0].hasPrefix("zh-Han") }
 * 其中 【return】 可有可无

 * 2.3 可变2 ： 多行代码实现 :
      var kSafeAreaInsets : UIEdgeInsets {
          var e = UIEdgeInsets.zero
          if #available(iOS 11.0, *) {
              e = UIApplication.shared.windows.first?.safeAreaInsets ?? e
          }
          e.top = max(UIApplication.shared.statusBarFrame.height, e.top)
          return e
      }
 */
