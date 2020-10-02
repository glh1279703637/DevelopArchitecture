//
//  JConstantHelp.swift
//  DeveloperArchitecture
//
//  Created by Jeffrey on 2020/9/25.
//

import Foundation
import UIKit

//是否为中文模式
let kisZhHans = NSLocale.preferredLanguages[0].hasPrefix("zh-Han")

// 是否是ipad 模式
let kIS_IPAD = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad

@available(iOS 14.0, *)
let kisMAC = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.mac

let kappVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
let kappBuildCode = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String


func kLocalStr(_ str:String) -> String {
    return NSLocalizedString(str, comment: "")
}
//对参数进行base64加密过
//func kLocalStre(str:String) -> String {
//    let name = NSLocalizedString(str, comment: "")
//    let result = JDESBase64.funj_decryptionFromBase64(:name c:"DevelopArchitecture")
//    return result
//}

//是否为深色模式
let kcurrentUserInterfaceStyleModel = { () -> NSInteger in
    var model = 0
    if #available(iOS 12.0, *) {
//        model = JAppViewTools.funj_getTopViewcontroller().userInterfaceStyle
    }
    return model
}
    
//颜色 hex 16进制
func kARGBHex (_ rgb:UInt,_ alpha:CGFloat) ->UIColor {
    return UIColor(red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0, green: CGFloat((rgb & 0xFF00) >> 8) / 255.0,  blue: CGFloat(rgb & 0xFF) / 255.0, alpha: alpha)
}


func kRGB (red:CGFloat,green:CGFloat,blue:CGFloat)  -> UIColor {
    return UIColor.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
}
let krandomColor = kRGB(red: CGFloat(arc4random() % 255), green: CGFloat(arc4random() % 255), blue: CGFloat(arc4random() % 255))

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
        if kcurrentUserInterfaceStyleModel() == UIUserInterfaceStyle.dark.rawValue {
            color = dark
        }
    }
    return color;
}

let KSafeAreaInsets = {() -> UIEdgeInsets in
    var e = UIEdgeInsets.zero
    if #available(iOS 11.0, *) {
        e = UIApplication.shared.windows.first?.safeAreaInsets ?? e
    }
    e.top = max(UIApplication.shared.statusBarFrame.height, e.top)
    return e
}

let KStatusBarHeight = KSafeAreaInsets().top

let KFilletSubHeight = KSafeAreaInsets().bottom

#if TARGET_OS_MACCATALYST
let KWindowSceneSize = { () ->CGSize in
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
let KWidth = kwindowSceneSize.width
let KHeight = kwindowSceneSize.height
#else
let KWidth = UIScreen.main.bounds.width
let KHeight = UIScreen.main.bounds.height
#endif

let KNavigationBarHeight = (Double(UIDevice.current.systemVersion)! >= 12.0 && kIS_IPAD) ? CGFloat(50.0) : CGFloat(44.0)
let KNavigationBarBottom = (KNavigationBarHeight+KStatusBarHeight)

func kWidth(_ x:CGFloat) -> CGFloat {
    return x * KWidth / 375.0
}
let KHeight64 = (KHeight - KNavigationBarBottom)
let KWidthM = (kIS_IPAD ? 375.0 : KWidth)
let KWidthD = (kIS_IPAD ? (KWidth - KWidthM - 0.5) : KWidth)
let KWidthMin = min(KWidth, KHeight)
let KHeightMax = max(KWidth, KHeight)

let KTabbarHeight = (KFilletSubHeight+50.0)


//图片宽高比例
func kImageViewHeight(_ width:CGFloat) -> CGFloat {
    return width * 9 / 16
}
//数字 大于某值是使用w表示
func kNUMBERS(_ num:CGFloat) -> String {
    return String( num > 10000 ? "\(Int(num/10000))w+" : num > 1000 ? "\(Int(num/1000))k+" :"\(Int(num))")
}

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

let FONT_SIZE20 = kisZhHans ?  UIFont.systemFont(ofSize: 20):UIFont.systemFont(ofSize: 18 )
let FONT_SIZE18 = kisZhHans ? UIFont.systemFont(ofSize: 18 ):UIFont.systemFont(ofSize: 16 )
let FONT_SIZE17 = kisZhHans ? UIFont.systemFont(ofSize: 17 ):UIFont.systemFont(ofSize: 15 )
let FONT_SIZE16 = kisZhHans ? UIFont.systemFont(ofSize: 16 ):UIFont.systemFont(ofSize: 14 )
let FONT_SIZE15 = kisZhHans ? UIFont.systemFont(ofSize: 15 ):UIFont.systemFont(ofSize: 13 )
let FONT_SIZE14 = kisZhHans ? UIFont.systemFont(ofSize: 14 ):UIFont.systemFont(ofSize: 12 )
let FONT_SIZE13 = kisZhHans ? UIFont.systemFont(ofSize: 13 ):UIFont.systemFont(ofSize: 12 )
let FONT_SIZE12 = kisZhHans ? UIFont.systemFont(ofSize: 12 ):UIFont.systemFont(ofSize: 12 )
let FONT_SIZE11 = kisZhHans ? UIFont.systemFont(ofSize: 11 ):UIFont.systemFont(ofSize: 11 )
let FONT_SIZE10 = kisZhHans ? UIFont.systemFont(ofSize: 10 ):UIFont.systemFont(ofSize: 10 )

let FONT_BOLDSIZE20 = kisZhHans ? UIFont.boldSystemFont(ofSize: 20 ):UIFont.systemFont(ofSize: 18 )
let FONT_BOLDSIZE17 = kisZhHans ? UIFont.boldSystemFont(ofSize: 17 ):UIFont.systemFont(ofSize: 15 )
let FONT_BOLDSIZE16 = kisZhHans ? UIFont.boldSystemFont(ofSize: 16 ):UIFont.systemFont(ofSize: 14 )
let FONT_BOLDSIZE15 = kisZhHans ? UIFont.boldSystemFont(ofSize: 15 ):UIFont.systemFont(ofSize: 13 )
let FONT_BOLDSIZE14 = kisZhHans ? UIFont.boldSystemFont(ofSize: 14 ):UIFont.systemFont(ofSize: 12 )
let FONT_BOLDSIZE13 = kisZhHans ? UIFont.boldSystemFont(ofSize: 13 ):UIFont.systemFont(ofSize: 12 )
let FONT_BOLDSIZE12 = kisZhHans ? UIFont.boldSystemFont(ofSize: 12 ):UIFont.systemFont(ofSize: 11 )
let FONT_BOLDSIZE11 = kisZhHans ? UIFont.boldSystemFont(ofSize: 11 ):UIFont.systemFont(ofSize: 10 )
let FONT_BOLDSIZE10 = kisZhHans ? UIFont.boldSystemFont(ofSize: 10 ):UIFont.systemFont(ofSize: 9 )

#if DEBUG
func Cprint(_ str:String)  {
//    print("\(#file) . \(#function) :[\(#line)] \(str)")
    print(str)
}
#else
func Cprint(str:String)  {}
#endif
