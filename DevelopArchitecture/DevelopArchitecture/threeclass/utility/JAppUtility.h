//
//  JAppUtility.h
//  DevelopArchitecture
//
//  Created by Jeffrey on 15/9/6.
//  Copyright (c) 2015年 Jeffrey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>
#import <UIKit/UIKit.h>
#import "NSDictionary+JSON.h"

@interface JAppUtility : NSObject



//获取temp中basepath 文件夹中的file文件路径
+(NSString*)funj_getTempPath:(NSString*)basepath :(NSString*)file;
//获取application document路径  file ＝nil 时为docoument
+ (NSString *)funj_getDocumentPathWithFile:(NSString*)file;
//将url转化成标准url
+ (NSString *)funj_getCompleteWebsiteURL:(NSString *)urlStr;
//判断文件是否存在
+ (BOOL)funj_isFileExit:(NSString *)filepath;
+ (BOOL)funj_createDirector:(NSString *)filepath;

//md5加密
+ (NSString *)funj_md5:(NSString *)str;


//获取文本内容的高度，辅助前两个方法，用来返回控件高度；
+ (CGFloat)funj_getTextHeight:(NSString *)content textFont:(UIFont *)font viewWidth:(CGFloat)layoutwidth;
//获得字符串的长度
+(CGFloat) funj_getTextWidth:(NSString *)text textFont:(UIFont *)font;

// 通过控件返回控件高度；
+ (CGFloat)funj_getTextHeightWithView:(UIView*)view m:(CGFloat)maxHeight;
+(CGFloat)funj_getAttriTextHeightWithView:(UIView*)view m:(CGFloat)maxHeight;
//获得字符串的长度
+(CGFloat) funj_getTextWidthWithView:(UIView*)view;

//图片压缩算法
//+ (UIImage *)funj_imageByScalingForSourceImage:(UIImage *)sourceImage targetViewSize:(CGSize)targetViewSize;
//图片 压缩算法 上传时候处理
+(NSData *)funj_compressImageWithMaxLength:(UIImage*)image :(CGFloat)sizeM;

//+ (UIImage*)funj_imageFromScreenShotView:(UIView*)view :(NSArray*)removeViews :(CGRect)shotRect;
//颜色生成图片
+(UIImage *)funj_imageWithColor:(UIColor *)color :(CGSize)size;

////颜色转成16进制
//+ (NSString *) funj_hexFromUIColor: (UIColor*) color;
//
//// 颜色转换三：iOS中十六进制的颜色（以#开头）转换为UIColor
//+ (UIColor *) funj_colorWithHexString: (NSString *)color;

//判断字符串是否为整数类型
+(BOOL)funj_isPureInt:(NSString *)string;
//通过手机号获取 145***124等类型数据
+(NSString*)funj_getHiddenMobile:(NSString*)mobile;
//判断手机号码，电话号码函数
+(BOOL)funj_isMobileNumber:(NSString*)mobileNum;
//判断是字符串是否只含有数字、字母
+(BOOL)funj_isCheckNameIsRight:(NSString*)name;
//邮箱地址的正则表达式
+ (BOOL)funj_isValidateEmail:(NSString *)email;
// 验证数据合法性 allName email name mobile code password surePassword answer isAgree
+(BOOL)funj_isCheckMobile_Password_CodeIsRight:(UIViewController*)viewController :(NSDictionary*)data;

//对象转化成字符串  nssarray->string or....
+(NSString*)funj_stringFromObject:(id)object;
//字符串转化成对象  string->nsarray or....
+(id)funj_objectFromString:(NSString*)jsonString;

//获取当前时间
+(NSString*)funj_getDateTime:(NSString*)formatter;

//通过字符串获取一个类对象 @"UIImage"->image对象
+(id)getObjectWithClass:(NSString*)className;
//获取验证码 的时间处理
+(void)funj_getTheTimeCountdownWithCode:(UIButton*)getCodeBt :(UIColor*)defaultBoardColor;

//表情处理
+ (BOOL)funj_stringContainsEmoji:(NSString *)string;
//是否包含有非字符串
+ (BOOL)funj_stringContainsNonChar:(NSString *)string;
//汉字转化成拼音
+ (NSString *)funj_pinyinFromChineseString:(NSString *)string;

//上下震动效果 或者左右 width 左右偏移，height 上下偏移
+ (void)funj_shakeAnimationForView:(UIView *)view :(CGSize)offset;
//color效果 放大缩小
+ (void)funj_changeColorAnimationForView:(UIView *)view;
//expand效果 放大缩小
+ (void)funj_expandAnimationForView:(UIView *)view;
//视图进入动画  type:kCATransitionPush  subtype:kCATransitionFromLeft
+ (void) funj_transitionWithType:(NSString *) type WithSubtype:(NSString *) subtype ForView : (UIView *) view;

// 去掉HTML标签
+ (NSString *)funj_filterHTML:(NSString *)html;
//清除网页cookies
+(void)funj_clearWebViewCookies;
//获取字串长度 专在shouldChangeCharactersInRange 使用 textfield texview
+(NSString*)funj_getTextFieldLength:(NSString*)textFieldText  :(NSRange)range :(NSString*)string :(NSInteger)maxLength;
+(void)funj_checkAppStoreVersion:(NSString*)appleId;

/*发送本地的通知 显示结果
 *-- title
 *-- subtitle
 *-- content -- contentRightImage
 */
+(void)funj_postLocalNotifation:(NSString*)title s:(NSString*)subtitle b:(NSString*)body i:(NSString*)contentRightImage;

//冒泡排序
-(void)funj_bubbleSortWithArray:(NSMutableArray*)array;
//快速排序
-(void) funj_quickSortArray:(NSMutableArray*)array l:(NSInteger)left r:(NSInteger)right;
//直接选择排序
-(void)funj_selectSortWithArray:(NSMutableArray*)array;
//堆排序
-(void)funj_heapSortWithArray:(NSMutableArray*)array ;
//插入排序
-(void)funj_insertSortWithArray:(NSMutableArray*)array ;
//归并排序 有问题
-(void)funj_mergeSortWithArray:(NSMutableArray*)array l:(NSInteger)left r:(NSInteger)right ;
//基数排序
- (void)funj_radixAscendingOrderSort:(NSMutableArray *)ascendingArr ;
@end

