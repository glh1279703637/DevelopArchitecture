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
let kIS_IPAD = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
let kIS_IPAD_1 = (kIS_IPAD ? CGFloat(1.0) : CGFloat(0.0))


@available(iOS 14.0, *)
let kisMAC = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.mac

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
func kCOLOR_DARK(_ nor:UIColor ,_ dark:UIColor) -> UIColor {
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

var KSafeAreaInsets : UIEdgeInsets {
    var e = UIEdgeInsets.zero
    if #available(iOS 11.0, *) {
        e = UIApplication.shared.windows.first?.safeAreaInsets ?? e
    }
    e.top = max(UIApplication.shared.statusBarFrame.height, e.top)
    return e
}

var KStatusBarHeight : CGFloat { KSafeAreaInsets.top }

var KFilletSubHeight : CGFloat { KSafeAreaInsets.bottom }

#if TARGET_OS_MACCATALYST
var KWindowSceneSize : CGSize {
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
var KWidth :CGFloat { KWindowSceneSize.width }
var KHeight :CGFloat { KWindowSceneSize.height }
#else
var KWidth : CGFloat { UIScreen.main.bounds.width }
var KHeight : CGFloat { UIScreen.main.bounds.height }
#endif

var KNavigationBarHeight : CGFloat { (Double(UIDevice.current.systemVersion) ?? 0 >= 12.0 && kIS_IPAD) ? CGFloat(50.0) : CGFloat(44.0) }
var KNavigationBarBottom : CGFloat { (KNavigationBarHeight+KStatusBarHeight) }

let KWidthT = { (_ x : CGFloat) -> CGFloat in x * KWidth / 375.0 }

var KHeight64 : CGFloat { (KHeight - KNavigationBarBottom) }
var KWidthM : CGFloat { (kIS_IPAD ? 375.0 : KWidth) }
var KWidthD : CGFloat { (kIS_IPAD ? (KWidth - KWidthM - 0.5) : KWidth) }
var KWidthMin : CGFloat { min(KWidth, KHeight) }
var KHeightMax : CGFloat { max(KWidth, KHeight) }

var KTabbarHeight : CGFloat { (KFilletSubHeight+50.0) }

let CGRectZero = CGRect(x: 0, y: 0, width: 0, height: 0)
let UIEdgeInsetsZero = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

//图片宽高比例
let kImageViewHeight = { (_ width:CGFloat) -> CGFloat in width * 9 / 16 }

//数字 大于某值是使用w表示
let kNUMBERS = { (_ num:CGFloat) -> String in String( num > 10000 ? "\(Int(num/10000))w+" : num > 1000 ? "\(Int(num/1000))k+" :"\(Int(num))") }

//常用颜色 v2
let COLOR_CREAR = UIColor.clear//无色
let COLOR_BLUE = kARGBHex(0x3899ff,1)//状态栏的颜色 蓝色

let COLOR_WHITE = kARGBHex(0xffffff,1)//白色
let COLOR_WHITE_DARK = kCOLOR_DARK(kARGBHex(0xffffff,1),kARGBHex(0x5a5a5a,1))//白色

let COLOR_ORANGE = kARGBHex(0xff8338,1)//橘色
let COLOR_SHALLOW_ORANGE = kARGBHex(0xFCAA4B,1)//浅橘色
let COLOR_GREEN = kARGBHex(0x33c764,1)//绿色

let COLOR_TEXT_BLACK = kARGBHex(0x333333,1)//字体黑色
let COLOR_TEXT_BLACK_DARK = kCOLOR_DARK(kARGBHex(0x333333,1),kARGBHex(0xffffff,1))//字体黑色

let COLOR_TEXT_GRAY = kARGBHex(0x999999,1)//字体灰色
let COLOR_TEXT_GRAY_DARK = kCOLOR_DARK(kARGBHex(0x999999,1),kARGBHex(0xcccccc,1))//字体灰色

let COLOR_BG_LIGHTGRAY = kARGBHex(0xf0f1f5,1)//灰色背景色
let COLOR_BG_LIGHTGRAY_DARK = kCOLOR_DARK(kARGBHex(0xf0f1f5,1),kARGBHex(0x9e9e9e,1))//灰色背景色

let COLOR_BG_SHALLOW_LIGHTGRAY = kARGBHex(0xf7f7f8,1)//灰色浅背景色
let COLOR_BG_SHALLOW_LIGHTGRAY_DARK =     kCOLOR_DARK(kARGBHex(0xf7f7f8,1),kARGBHex(0x797979,1))//灰色浅背景色

let COLOR_RED = kARGBHex(0xf04d4d,1) //红色

let COLOR_BG_DARK = kCOLOR_DARK(COLOR_CREAR,kARGBHex(0x5a5a5a,1))//dark 深色模式

let COLOR_LINE_GRAY = kARGBHex(0xe1e1e1,1)//线色
let COLOR_LINE_GRAY_DARK = kCOLOR_DARK(kARGBHex(0xe1e1e1,1),kARGBHex(0x9e9e9e,1))//线色


func kfontSize(_ num : CGFloat ,num2 : CGFloat , isBold : Bool = false) -> UIFont {
    if isBold {
        return (kisZhHans ?  UIFont.systemFont(ofSize: num):UIFont.systemFont(ofSize: num2 ) )
    } else {
        return (kisZhHans ? UIFont.boldSystemFont(ofSize: num):UIFont.boldSystemFont(ofSize: num2 ) )
    }
}


var FONT_SIZE20 = kfontSize(20 ,num2 : 18)
var FONT_SIZE18 = kfontSize(18 ,num2 : 16)
var FONT_SIZE17 = kfontSize(17 ,num2 : 15)
var FONT_SIZE16 = kfontSize(16 ,num2 : 15)
var FONT_SIZE15 = kfontSize(15 ,num2 : 13)
var FONT_SIZE14 = kfontSize(14 ,num2 : 12)
var FONT_SIZE13 = kfontSize(13 ,num2 : 12)
var FONT_SIZE12 = kfontSize(12 ,num2 : 12)
var FONT_SIZE11 = kfontSize(11 ,num2 : 11)
var FONT_SIZE10 = kfontSize(10 ,num2 : 10)

var FONT_BOLDSIZE20 = kfontSize(20 ,num2 : 18 ,isBold: true)
var FONT_BOLDSIZE18 = kfontSize(18 ,num2 : 16 ,isBold: true)
var FONT_BOLDSIZE17 = kfontSize(17 ,num2 : 15 ,isBold: true)
var FONT_BOLDSIZE16 = kfontSize(16 ,num2 : 14 ,isBold: true)
var FONT_BOLDSIZE15 = kfontSize(15 ,num2 : 13 ,isBold: true)
var FONT_BOLDSIZE14 = kfontSize(14 ,num2 : 12 ,isBold: true)
var FONT_BOLDSIZE12 = kfontSize(12 ,num2 : 11 ,isBold: true)
var FONT_BOLDSIZE11 = kfontSize(11 ,num2 : 10 ,isBold: true)
var FONT_BOLDSIZE10 = kfontSize(10 ,num2 : 9  ,isBold: true)

#if DEBUG
func Cprint(_ str:String)  {
//    print("\(#file) . \(#function) :[\(#line)] \(str)")
    print(str)
}
#else
func Cprint(str:String)  {}
#endif


let KWidth1 = UIScreen.main.bounds.width
var KWidth2 : CGFloat { UIScreen.main.bounds.width }
var KWidth3 : CGFloat { return UIScreen.main.bounds.width }
let KWidth4 = { () -> CGFloat in  UIScreen.main.bounds.width}
let KWidth5 = { () -> CGFloat in return UIScreen.main.bounds.width}
var KWidth6 :CGFloat = { return  UIScreen.main.bounds.width }()

/*
 //调用方法 print("-- \(KWidth1)-- \(KWidth2)-- \(KWidth3())-- \(KWidth4())-- \(KWidth5)")
 // 其中 KWidth1 ,KWidth6 只获取一次，即使旋转屏幕也不变
 // 其中 KWidth2,KWidth3 ,KWidth4() ,KWidth5() 每次获取，旋转屏幕可变
 //另外：KWidth6 一般加上 lazy 进行 懒加载
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
 * 2.1 不可变 ： let kIS_IPAD = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad

 * 2.2 可变1 ： 只有一行代码实现 ： var kisZhHans : Bool { 【return】 NSLocale.preferredLanguages[0].hasPrefix("zh-Han") }
 * 其中 【return】 可有可无

 * 2.3 可变2 ： 多行代码实现 :
      var KSafeAreaInsets : UIEdgeInsets {
          var e = UIEdgeInsets.zero
          if #available(iOS 11.0, *) {
              e = UIApplication.shared.windows.first?.safeAreaInsets ?? e
          }
          e.top = max(UIApplication.shared.statusBarFrame.height, e.top)
          return e
      }
 */
