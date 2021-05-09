//
//  ConstantHelp.h
//  DevelopArchitecture
//
//  Created by Jeffrey on 15/1/20.
//  Copyright (c) 2015年 Jeffrey. All rights reserved.
//
#import "JBuildConfig.h"

#ifndef DevelopArchitecture_ConstantHelp_h
#define DevelopArchitecture_ConstantHelp_h

#define isZhHans ([[[NSLocale preferredLanguages] objectAtIndex:0] hasPrefix:@"zh-Han"])
//判断是否为iPad
#define IS_IPAD ([[UIDevice currentDevice]userInterfaceIdiom] == UIUserInterfaceIdiomPad)

#define kappVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define kappBuildCode [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

//当前app 的模式 深色模式 还是浅色模式
#define kcurrentUserInterfaceStyleModel ({ NSInteger model = 0; \
    if(@available(iOS 12.0, *)){model = [JAppViewTools funj_getTopViewcontroller].traitCollection.userInterfaceStyle;}\
    (model);})

#define UIColorFromARGB(rgbValue,alphaValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000)>>16))/255.0 green:((float)((rgbValue & 0xFF00)>>8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue]

#define RGB(x,y,z,a) [UIColor colorWithRed:x/255.0 green:y/255.0 blue:z/255.0 alpha:a]
#define krandomColor RGB((arc4random()%255), (arc4random()%255), (arc4random()%255), 1)

#define kColor_Dark(x,y) ({ UIColor *color= x;\
    if(@available(iOS 13.0, *)){\
        color= [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) { if(traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark){return y;}else{return x;}}]; \
    }else if(@available(iOS 12.0, *)){\
      if(kcurrentUserInterfaceStyleModel == UIUserInterfaceStyleDark){color = y;} \
    }(color);})



#define LocalStr(x) NSLocalizedString((x), nil)
#define LocalStrx(x,y) [NSString stringWithFormat:@"%@%@",NSLocalizedString((x), nil),y]
#define LocalStry(x,y) [NSString stringWithFormat:@"%@%@",x,NSLocalizedString((y), nil)]
//对参数进行base64加密过
#define LocalStre(x) ({\
    NSString*name = NSLocalizedString((x), nil);\
    NSString*result =[JDESBase64 funj_decryptionFromBase64:name :@"DevelopArchitecture"];\
    (result);\
})

#define kSafeAreaInsets ({\
   UIEdgeInsets e = UIEdgeInsetsZero;\
   if (@available(iOS 11.0, *)) {\
       e = [[UIApplication sharedApplication].windows firstObject].safeAreaInsets;\
   }\
   e.top = MAX(CGRectGetHeight([UIApplication sharedApplication].statusBarFrame),e.top);\
   (e);})

#define kStatusBarHeight kSafeAreaInsets.top
#define kFilletSubHeight kSafeAreaInsets.bottom  // iphonex 底部高度

#if TARGET_OS_MACCATALYST
  #define windowSceneSize ({ \
    CGSize size = CGSizeMake(1050.0, 797.0); \
    for(UIWindowScene *windowScene in [UIApplication sharedApplication].connectedScenes){ \
        if(windowScene.activationState == UISceneActivationStateForegroundActive || [[UIApplication sharedApplication].connectedScenes count] == 1){ \
            UIWindow*window = windowScene.windows.firstObject; \
            size = window.bounds.size; \
    } } (size);})

  #define kWidth windowSceneSize.width
  #define kHeight windowSceneSize.height
#else

  #define kWidth    [UIScreen mainScreen].bounds.size.width
  #define kHeight   ([UIScreen mainScreen].bounds.size.height - kFilletSubHeight)

#endif


#define kNavigationBarHeight (([[[UIDevice currentDevice] systemVersion] floatValue]>=12.0 && IS_IPAD) ? 50.f : 44.f)  // 导航栏高度
#define kNavigationBarBottom (kNavigationBarHeight+kStatusBarHeight)

//#define kWidth(x) (x) * kWidth / 375.f
#define kHeight64   (kHeight - kNavigationBarBottom)
#define kWidthD   (IS_IPAD ? (kWidth - 375.f - 0.5f) : kWidth)
#define kWidthM   (IS_IPAD ? 375.f : kWidth)
#define kWidthMin    MIN(kWidth,kHeight)
#define kHeightMax    MAX(kWidth,kHeight)


#define kTabbarHeight (kFilletSubHeight+50.f)

//图片宽高比例
#define kImageViewHeight(x) ((x)*9.0/16)
//数字 大于某值是使用w表示
#define kNUMBERS(x) [NSString stringWithFormat:([x intValue]>=10000?@"%.1fw+":@"%.0f"),([x intValue]>=10000?[x intValue]/10000.0:[x intValue])]


//弱引用/强引用
#define LRWeakSelf(type)  __weak typeof(type) weak##type = type;
#define LRStrongSelf(type)  __strong typeof(type) type = weak##type;

//常用颜色 v2
#define kColor_Clear                        [UIColor clearColor]//无色
#define kColor_Blue                          UIColorFromARGB(0x3899ff,1)//状态栏的颜色 蓝色
#define kColor_White                         UIColorFromARGB(0xffffff,1)//白色
#define kColor_White_Dark                    kColor_Dark(UIColorFromARGB(0xffffff,1),UIColorFromARGB(0x5a5a5a,1))//白色
#define kColor_Orange                        UIColorFromARGB(0xff8338,1)//橘色
#define kColor_Shallow_Orange                UIColorFromARGB(0xFCAA4B,1)//浅橘色
#define kColor_Green                         UIColorFromARGB(0x33c764,1)//绿色
#define kColor_Text_Black                    UIColorFromARGB(0x333333,1)//字体黑色
#define kColor_Text_Black_Dark               kColor_Dark(UIColorFromARGB(0x333333,1),UIColorFromARGB(0xffffff,1))//字体黑色
#define kColor_Text_Gray                     UIColorFromARGB(0x999999,1)//字体灰色
#define kColor_Text_Gray_Dark                kColor_Dark(UIColorFromARGB(0x999999,1),UIColorFromARGB(0xcccccc,1))//字体灰色
#define kColor_Bg_LightGray                  UIColorFromARGB(0xf0f1f5,1)//灰色背景色
#define kColor_Bg_LightGray_Dark             kColor_Dark(UIColorFromARGB(0xf0f1f5,1),UIColorFromARGB(0x9e9e9e,1))//灰色背景色
#define kColor_Bg_Shallow_LightGray          UIColorFromARGB(0xf7f7f8,1)//灰色浅背景色
#define kColor_Bg_Shallow_LightGray_Dark     kColor_Dark(UIColorFromARGB(0xf7f7f8,1),UIColorFromARGB(0x797979,1))//灰色浅背景色
#define kColor_RED                           UIColorFromARGB(0xf04d4d,1) //红色

#define kColor_Bg_Dark                       kColor_Dark(kColor_Clear,UIColorFromARGB(0x5a5a5a,1))//dark 深色模式

#define kColor_Line_Gray                     UIColorFromARGB(0xe1e1e1,1)//线色
#define kColor_Line_Gray_Dark                kColor_Dark(UIColorFromARGB(0xe1e1e1,1),UIColorFromARGB(0x9e9e9e,1))//线色


//常用字号大小


#define kFont_Size20        isZhHans?[UIFont systemFontOfSize:20]:[UIFont systemFontOfSize:18]
#define kFont_Size18        isZhHans?[UIFont systemFontOfSize:18]:[UIFont systemFontOfSize:16]
#define kFont_Size17        isZhHans?[UIFont systemFontOfSize:17]:[UIFont systemFontOfSize:15]
#define kFont_Size16        isZhHans?[UIFont systemFontOfSize:16]:[UIFont systemFontOfSize:14]
#define kFont_Size15        isZhHans?[UIFont systemFontOfSize:15]:[UIFont systemFontOfSize:13]
#define kFont_Size14        isZhHans?[UIFont systemFontOfSize:14]:[UIFont systemFontOfSize:12]
#define kFont_Size13        isZhHans?[UIFont systemFontOfSize:13]:[UIFont systemFontOfSize:12]
#define kFont_Size12        isZhHans?[UIFont systemFontOfSize:12]:[UIFont systemFontOfSize:12]
#define kFont_Size11        isZhHans?[UIFont systemFontOfSize:11]:[UIFont systemFontOfSize:11]
#define kFont_Size10        isZhHans?[UIFont systemFontOfSize:10]:[UIFont systemFontOfSize:10]

#define kFont_BoldSize20        isZhHans?[UIFont boldSystemFontOfSize:20]:[UIFont systemFontOfSize:18]
#define kFont_BoldSize17        isZhHans?[UIFont boldSystemFontOfSize:17]:[UIFont systemFontOfSize:15]
#define kFont_BoldSize16        isZhHans?[UIFont boldSystemFontOfSize:16]:[UIFont systemFontOfSize:14]
#define kFont_BoldSize15        isZhHans?[UIFont boldSystemFontOfSize:15]:[UIFont systemFontOfSize:13]
#define kFont_BoldSize14        isZhHans?[UIFont boldSystemFontOfSize:14]:[UIFont systemFontOfSize:12]
#define kFont_BoldSize13        isZhHans?[UIFont boldSystemFontOfSize:13]:[UIFont systemFontOfSize:12]
#define kFont_BoldSize12        isZhHans?[UIFont boldSystemFontOfSize:12]:[UIFont systemFontOfSize:11]
#define kFont_BoldSize11        isZhHans?[UIFont boldSystemFontOfSize:11]:[UIFont systemFontOfSize:10]
#define kFont_BoldSize10        isZhHans?[UIFont boldSystemFontOfSize:10]:[UIFont systemFontOfSize:9]




#endif

#define maddProperyValue(m_dataArr,class)  \
-(class*)m_dataArr{\
    if(!_##m_dataArr){ \
    _##m_dataArr =[[class alloc]init];\
}\
return _##m_dataArr;}

#define maddShareValue(shareObj,class)  \
   +(instancetype)share{ \
      if(!shareObj) shareObj =[[class alloc]init];\
      return shareObj;}


#define addConfigSumBit(selfs,superView,left,top,width,title,cornerRadius,tag)({\
    UIButton *sumBt=[UIButton funj_getButton:CGRectMake(left, top, width,45) t:title fc:JTextFCMake(kFont_Size17, kColor_White) bg:@[kColor_White] d:selfs  a:@"funj_selectSumbitTo:" tag:tag]; \
    [(JButton*)sumBt funj_resetProhibitActionTime:2 e:NO];\
    [superView addSubview:sumBt]; \
    [sumBt funj_setViewCornerLayer:JFilletMake(0, cornerRadius, kColor_White)]; \
    sumBt.layer.shadowColor = kColor_Blue.CGColor; \
    [sumBt funj_setViewGradientLayer:YES bg:@[kColor_Orange,kColor_Shallow_Orange] location:@[@0.4, @1]]; \
    (sumBt);})



#ifdef DEBUG
    #define CLog(fmt, ...) NSLog((@"%s [Line: %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
    #define CLogwt(tag, fmt, ...) NSLog((@"[%@](%d) " fmt), tag, __LINE__, ##__VA_ARGS__)
#else
    #define CLog(fmt, ...)
    #define CLogwt(tag, fmt, ...)
#endif
