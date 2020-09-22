//
//  JAppViewExtend.h
//  DevelopArchitecture
//
//  Created by Jeffrey on 16/7/21.
//  Copyright © 2016年 Jeffrey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JAppViewTools.h"
#import <WebKit/WebKit.h>




@interface JAppViewExtend : NSObject

@end

typedef NS_ENUM(NSInteger,TEXTFINPUT_TYPE) {
    kALLINPUTCHAR_TAG                 = 1 << 0,//支持所有字符
    kALLDIGITAL_TAG                   = 1 << 1, //数字
    kALLLETTER_TAG                    = 1 << 2, //字母
    kALLCHINESE_TAG                   = 1 << 3,//汉字
    kALLINPUTPUNCTUATION_TAG          = 1 << 4,//标点字符，除了特殊无法存储字符
    kALLNOEMOTICONS_TAG               = 1 << 5, //除表情符号所有字符
    
};
@interface UIResponder (JBaseResponder)
-(void)funj_addNumberInputKeyAccesssoryTitleView;//解决数字键盘无返回按钮的问题
-(void)funj_setTextFieldMaxLength:(NSInteger)maxLength t:(TEXTFINPUT_TYPE)type;
-(void)funj_setViewShadowLayer;//如果即要圆色又要阴影 则先设置funj_setViewCornerLayer(>0.01,圆角度,阴影颜色），再设置funj_setViewShadowLayer
-(void)funj_setViewCornerRadius:(CGFloat)cornerRadius;
-(void)funj_setViewCornerLayer:(FilletValue)fillet;
-(CAGradientLayer*)funj_setViewGradientLayer:(BOOL)isX :(NSArray<UIColor*>*)colorArr :(NSArray*)locations;
@end

@interface UIView (ViewEx)
@property CGPoint origin;
@property CGSize size;

@property CGFloat height;
@property CGFloat width;

@property CGFloat top;
@property CGFloat left;

@property CGFloat bottom;
@property CGFloat right;
@end


#pragma mark textview
@interface UITextView(JTextView)

//获取TextView控件（自动换行，不出现滚动条）,
+ (UITextView *)funj_getTextView:(CGRect)frame :(TextFC)textFC ;

+ (UITextView *)funj_getTextViewFillet:(CGRect)frame :(TextFC)textFC :(FilletValue)fillet;

+(UITextView *)funj_getLinkAttriTextView:(CGRect)frame :(NSString*)content attr:(NSDictionary<NSAttributedStringKey, id> *)attrs :(NSArray*)selectArr/*@[NSRange]*/ a:(id)target;
@end

#pragma mark label
@interface UILabel(JLabels)
//获取Label控件（自动换行）,
+ (UILabel *)funj_getLabel:(CGRect)frame :(TextFC)textFC;

+ (UILabel *)funj_getLabel:(CGRect)frame :(NSString*)title :(TextFC)textFC;

+ (UILabel *)funj_getOneLabel:(CGRect)frame  :(TextFC)textFC;

-(void)funj_updateAttributedText:(NSString*)title;
@end

#pragma mark button

@interface UIButton(JButtons)
typedef NS_ENUM(NSInteger,ButtonContentImageLayout){
    kLEFT_IMAGECONTENT, // 图文 靠左
    kLEFT_CONTENTIMAGE, // 文图 靠左
    
    kCENTER_IMAGECONTENT, // 图文 靠中间 默认
    kCENTER_CONTENTIMAGE, // 文图 靠中间
    
    kRIGHT_IMAGECONTENT, // 图文 靠右
    kRIGHT_CONTENTIMAGE, // 文图 靠右
    
    kTOP_IMAGECONTENT, // 图文 上下
    kTOP_CONTENTIMAGE, // 文图 上下
    
    kLEFT_CONTENT_RIGHT_IMAGE // 左文 右图 ,中间留白
};
//Button图文排列对齐构造方法
typedef struct AlignSpaceValue{
    CGFloat head;
    CGFloat spacing;
    CGFloat foot;
    
}AlignValue;
AlignValue JAlignMake(CGFloat head,CGFloat spacing,CGFloat foot);

-(void)funj_setBlockToButton:(NSArray*)saveBgImageOrColor :(clickCallBack)block;

//是否需要点击高亮 是否需要点击时selected变化
-(void)funj_updateButtonSelectStyle:(BOOL)isNeedSelectHightColor :(BOOL)isDefalutNeedToSelectChange;
//点击button事件后，还原原来的状态。主要是添加 点击button 图片的变化作用，有点击效果
-(void)funj_resetButtonNormalState;
//图片，文本 排列方式
-(void)funj_updateContentImageLayout:(ButtonContentImageLayout)layout s:(CGFloat)spacing;
-(void)funj_updateContentImageLayout:(ButtonContentImageLayout)layout a:(AlignValue)align;
-(void)funj_addNormalDarkImage:(NSString*)image;

//获取button 控件
+(UIButton*)funj_getButton:(CGRect)frame :(NSString*)title :(TextFC)textFC :(NSArray*)bgImageOrColor :(id)delegate :(NSString*)action :(NSInteger)tags;

+(UIButton*)funj_getButtonBlock:(CGRect)frame :(NSString*)title :(TextFC)textFC :(NSArray*)bgImageOrColor :(NSInteger)tags :(clickCallBack)block;

+(UIButton*)funj_getButtons:(CGRect)frame :(NSString*)title :(TextFC)textFC :(NSArray*)image :(id)delegate :(NSString*)action :(NSInteger)tags :(clickCallBack)setButton;

+(UIButton*)funj_getButtonBlocks:(CGRect)frame :(NSString*)title :(TextFC)textFC :(NSArray*)image :(NSInteger)tags :(clickCallBack)setButton :(clickCallBack)block;

+(UIButton*)funj_getButtonFillet:(CGRect)frame :(NSString*)title :(TextFC)textFC :(NSArray*)bgImageOrColor :(id)delegate :(NSString*)action :(NSInteger)tags :(FilletValue)fillet;//圆角

+(UIButton*)funj_getButtonBlockFillet:(CGRect)frame :(NSString*)title :(TextFC)textFC :(NSArray*)bgImageOrColor :(NSInteger)tags :(FilletValue)fillet :(clickCallBack)block ;//圆角
@end


#pragma mark navigationitem
@interface UIBarButtonItem(JBarButtonItem)
//获取公用的nav 按钮
+ (UIBarButtonItem *)funj_getNavPublicButton:(id)target icon:(NSString*)icon action:(NSString*)action;

+ (UIBarButtonItem *)funj_getNavPublicButton:(id)target title:(NSString*)title action:(NSString*)action image:(NSString*)image :(clickCallBack)setButton;
@end


#pragma mark view
@interface UIView(Jview)
//  获取view
+(UIView*)funj_getView:(CGRect)frame :(UIColor*)bgColor;

+(UIView*)funj_getViewFillet:(CGRect)frame :(UIColor*)bgColor :(FilletValue)fillet;
@end



#pragma mark textfiled
@interface UITextField(JTextField)
//获取textfield
+(UITextField*)funj_getTextField:(CGRect)frame :(NSString*)placeholder :(TextFC)textFC :(id)delegate :(NSInteger)tag;

+(UITextField*)funj_getTextField:(CGRect)frame :(NSString*)placeholder :(TextFC)textFC :(id)delegate :(NSInteger)tag :(UIKeyboardType)keyboardType :(UIReturnKeyType)returnKeyType;

+(UITextField*)funj_getTextFieldFillet:(CGRect)frame :(NSString*)placeholder :(TextFC)textFC :(id)delegate :(NSInteger)tag :(FilletValue)fillet;

+(UITextField*)funj_getTextFieldFillet:(CGRect)frame :(NSString*)placeholder :(TextFC)textFC :(id)delegate :(NSInteger)tag :(FilletValue)fillet :(UIKeyboardType)keyboardType :(UIReturnKeyType)returnKeyType;
@end


#pragma mark imageview
@interface UIImageView(JImageView)
//获取图片
+(UIImageView*)funj_getImageView:(CGRect)frame image:(NSString*)image;

+(UIImageView*)funj_getImageViewFillet:(CGRect)frame image:(NSString*)image :(FilletValue)fillet;//圆角图片

+(UIImageView*)funj_getImageView:(CGRect)frame bgColor:(UIColor*)bgColor;

+(UIImageView*)funj_getLineImageView:(CGRect)frame;
+(UIImageView*)funj_getBlackAlphaView:(CGRect)frame;
@end


//获取uiscrollview
@interface UIScrollView(JScrollView)
+ (UIScrollView*)funj_getScrollView:(CGRect)frame :(id)delegate ;
@end

@interface WKWebView(JWKWebView)
-(void)funj_removeScriptMessageHandler:(NSArray*)names;
-(void)funj_addScriptMessageHandler:(id<WKScriptMessageHandler>)strongSelf :(NSArray*)names;
+ (WKWebView*)funj_getWKWebView:(CGRect)frame :(id)delegate :(NSString*)url;
+ (WKWebView*)funj_getWKWebView:(CGRect)frame :(id)delegate :(NSString*)url :(void (^)(WKWebViewConfiguration *config))configCallback;
+(void)funj_deallocWebView:(WKWebView*)webView;
@end





