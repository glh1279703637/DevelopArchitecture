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

#define COLOR_DARK(x,y) ({ UIColor *color= x;\
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

#define KSafeAreaInsets ({\
   UIEdgeInsets e = UIEdgeInsetsZero;\
   if (@available(iOS 11.0, *)) {\
       e = [[UIApplication sharedApplication].windows firstObject].safeAreaInsets;\
   }\
   e.top = MAX(CGRectGetHeight([UIApplication sharedApplication].statusBarFrame),e.top);\
   (e);})

#define KStatusBarHeight KSafeAreaInsets.top
#define KFilletSubHeight KSafeAreaInsets.bottom  // iphonex 底部高度

#if TARGET_OS_MACCATALYST
  #define windowSceneSize ({ \
    CGSize size = CGSizeMake(1050.0, 797.0); \
    for(UIWindowScene *windowScene in [UIApplication sharedApplication].connectedScenes){ \
        if(windowScene.activationState == UISceneActivationStateForegroundActive || [[UIApplication sharedApplication].connectedScenes count] == 1){ \
            UIWindow*window = windowScene.windows.firstObject; \
            size = window.bounds.size; \
    } } (size);})

  #define KWidth windowSceneSize.width
  #define KHeight windowSceneSize.height
#else

  #define KWidth    [UIScreen mainScreen].bounds.size.width
  #define KHeight   ([UIScreen mainScreen].bounds.size.height - KFilletSubHeight)

#endif


#define KNavigationBarHeight (([[[UIDevice currentDevice] systemVersion] floatValue]>=12.0 && IS_IPAD) ? 50.f : 44.f)  // 导航栏高度
#define KNavigationBarBottom (KNavigationBarHeight+KStatusBarHeight)

#define kWidth(x) (x)*KWidth/375.f
#define KHeight64   (KHeight-KNavigationBarBottom)
#define KWidthD   (IS_IPAD ? (KWidth - 375.f - 0.5f) : KWidth)
#define KWidthM   (IS_IPAD ? 375.f : KWidth)
#define KWidthMin    MIN(KWidth,KHeight)
#define KHeightMax    MAX(KWidth,KHeight)


#define KTabbarHeight (KFilletSubHeight+50.f)

//图片宽高比例
#define kImageViewHeight(x) ((x)*9.0/16)
//数字 大于某值是使用w表示
#define kNUMBERS(x) [NSString stringWithFormat:([x intValue]>=10000?@"%.1fw+":@"%.0f"),([x intValue]>=10000?[x intValue]/10000.0:[x intValue])]


//弱引用/强引用
#define LRWeakSelf(type)  __weak typeof(type) weak##type = type;
#define LRStrongSelf(type)  __strong typeof(type) type = weak##type;

//常用颜色 v2
#define COLOR_CREAR                        [UIColor clearColor]//无色
#define COLOR_BLUE                          UIColorFromARGB(0x3899ff,1)//状态栏的颜色 蓝色
#define COLOR_WHITE                         UIColorFromARGB(0xffffff,1)//白色
#define COLOR_WHITE_DARK                    COLOR_DARK(UIColorFromARGB(0xffffff,1),UIColorFromARGB(0x5a5a5a,1))//白色
#define COLOR_ORANGE                        UIColorFromARGB(0xff8338,1)//橘色
#define COLOR_SHALLOW_ORANGE                UIColorFromARGB(0xFCAA4B,1)//浅橘色
#define COLOR_GREEN                         UIColorFromARGB(0x33c764,1)//绿色
#define COLOR_TEXT_BLACK                    UIColorFromARGB(0x333333,1)//字体黑色
#define COLOR_TEXT_BLACK_DARK               COLOR_DARK(UIColorFromARGB(0x333333,1),UIColorFromARGB(0xffffff,1))//字体黑色
#define COLOR_TEXT_GRAY                     UIColorFromARGB(0x999999,1)//字体灰色
#define COLOR_TEXT_GRAY_DARK                COLOR_DARK(UIColorFromARGB(0x999999,1),UIColorFromARGB(0xcccccc,1))//字体灰色
#define COLOR_BG_LIGHTGRAY                  UIColorFromARGB(0xf0f1f5,1)//灰色背景色
#define COLOR_BG_LIGHTGRAY_DARK             COLOR_DARK(UIColorFromARGB(0xf0f1f5,1),UIColorFromARGB(0x9e9e9e,1))//灰色背景色
#define COLOR_BG_SHALLOW_LIGHTGRAY          UIColorFromARGB(0xf7f7f8,1)//灰色浅背景色
#define COLOR_BG_SHALLOW_LIGHTGRAY_DARK     COLOR_DARK(UIColorFromARGB(0xf7f7f8,1),UIColorFromARGB(0x797979,1))//灰色浅背景色
#define COLOR_RED                           UIColorFromARGB(0xf04d4d,1) //红色

#define COLOR_BG_DARK                       COLOR_DARK(COLOR_CREAR,UIColorFromARGB(0x5a5a5a,1))//dark 深色模式

#define COLOR_LINE_GRAY                     UIColorFromARGB(0xe1e1e1,1)//线色
#define COLOR_LINE_GRAY_DARK                COLOR_DARK(UIColorFromARGB(0xe1e1e1,1),UIColorFromARGB(0x9e9e9e,1))//线色


//常用字号大小


#define PUBLIC_FONT_SIZE20        isZhHans?[UIFont systemFontOfSize:20]:[UIFont systemFontOfSize:18]
#define PUBLIC_FONT_SIZE18        isZhHans?[UIFont systemFontOfSize:18]:[UIFont systemFontOfSize:16]
#define PUBLIC_FONT_SIZE17        isZhHans?[UIFont systemFontOfSize:17]:[UIFont systemFontOfSize:15]
#define PUBLIC_FONT_SIZE16        isZhHans?[UIFont systemFontOfSize:16]:[UIFont systemFontOfSize:14]
#define PUBLIC_FONT_SIZE15        isZhHans?[UIFont systemFontOfSize:15]:[UIFont systemFontOfSize:13]
#define PUBLIC_FONT_SIZE14        isZhHans?[UIFont systemFontOfSize:14]:[UIFont systemFontOfSize:12]
#define PUBLIC_FONT_SIZE13        isZhHans?[UIFont systemFontOfSize:13]:[UIFont systemFontOfSize:12]
#define PUBLIC_FONT_SIZE12        isZhHans?[UIFont systemFontOfSize:12]:[UIFont systemFontOfSize:12]
#define PUBLIC_FONT_SIZE11        isZhHans?[UIFont systemFontOfSize:11]:[UIFont systemFontOfSize:11]
#define PUBLIC_FONT_SIZE10        isZhHans?[UIFont systemFontOfSize:10]:[UIFont systemFontOfSize:10]

#define PUBLIC_FONT_BOLDSIZE20        isZhHans?[UIFont boldSystemFontOfSize:20]:[UIFont systemFontOfSize:18]
#define PUBLIC_FONT_BOLDSIZE17        isZhHans?[UIFont boldSystemFontOfSize:17]:[UIFont systemFontOfSize:15]
#define PUBLIC_FONT_BOLDSIZE16        isZhHans?[UIFont boldSystemFontOfSize:16]:[UIFont systemFontOfSize:14]
#define PUBLIC_FONT_BOLDSIZE15        isZhHans?[UIFont boldSystemFontOfSize:15]:[UIFont systemFontOfSize:13]
#define PUBLIC_FONT_BOLDSIZE14        isZhHans?[UIFont boldSystemFontOfSize:14]:[UIFont systemFontOfSize:12]
#define PUBLIC_FONT_BOLDSIZE13        isZhHans?[UIFont boldSystemFontOfSize:13]:[UIFont systemFontOfSize:12]
#define PUBLIC_FONT_BOLDSIZE12        isZhHans?[UIFont boldSystemFontOfSize:12]:[UIFont systemFontOfSize:11]
#define PUBLIC_FONT_BOLDSIZE11        isZhHans?[UIFont boldSystemFontOfSize:11]:[UIFont systemFontOfSize:10]
#define PUBLIC_FONT_BOLDSIZE10        isZhHans?[UIFont boldSystemFontOfSize:10]:[UIFont systemFontOfSize:9]




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
    UIButton *sumBt=[UIButton funj_getButton:CGRectMake(left, top, width,45) :title :JTextFCMake(PUBLIC_FONT_SIZE17, COLOR_WHITE) :@[COLOR_WHITE] :selfs  :@"funj_selectSumbitTo:" :tag]; \
    [(JButton*)sumBt funj_resetProhibitActionTime:2 e:NO];\
    [superView addSubview:sumBt]; \
    [sumBt funj_setViewCornerLayer:JFilletMake(0, cornerRadius, COLOR_WHITE)]; \
    sumBt.layer.shadowColor = COLOR_BLUE.CGColor; \
    [sumBt funj_setViewGradientLayer:YES :@[COLOR_ORANGE,COLOR_SHALLOW_ORANGE] :@[@0.4, @1]]; \
    (sumBt);})



#ifdef DEBUG
    #define CLog(fmt, ...) NSLog((@"%s [Line: %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
    #define CLogwt(tag, fmt, ...) NSLog((@"[%@](%d) " fmt), tag, __LINE__, ##__VA_ARGS__)
#else
    #define CLog(fmt, ...)
    #define CLogwt(tag, fmt, ...)
#endif
