//
//  JAppViewTools.h
//  DevelopArchitecture
//
//  Created by Jeffrey on 15/9/6.
//  Copyright (c) 2015年 Jeffrey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
 #import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>
#import "JAppUtility.h"


//视图圆角构造方法
typedef struct FilletValue{
    CGFloat borderWidth;
    CGFloat cornerRadius;
    __unsafe_unretained UIColor *borderColor;
}FilletValue;

FilletValue JFilletMake(CGFloat borderWidth,CGFloat cornerRadius,UIColor *borderColor);

typedef struct TextFontAndColor{
    __unsafe_unretained UIFont *textFont;
    __unsafe_unretained UIColor *textColor;
    __unsafe_unretained UIColor *selectTextColor;
    NSTextAlignment alignment;
}TextFC;
TextFC JTextFCZero(void);
TextFC JTextFCMake(UIFont *textFont,UIColor *textColor);
TextFC JTextFCMaked(UIFont *textFont,UIColor *textColor,UIColor *selectTextColor);
TextFC JTextFCMakeAlign(UIFont *textFont,UIColor *textColor,NSTextAlignment alignment);



typedef void (^alertBlockCallback)(id strongSelf, NSInteger index);

@interface JAppViewTools : NSObject
//显示toast文字
+ (void)funj_showTextToast:(UIView *)containerview message:(NSString *)msgtxt;

//显示toast文字
//动画完成后，执行 [target method] 方法
+ (void)funj_showTextToast:(UIView *)containerview message:(NSString *)msgtxt complete:(void (^)(void))complete time:(CGFloat)time;

//显示只带有一个ok按钮的提示框
+ (void)funj_showAlertBlock:(id)delegate :(NSString *)msgtxt;
+ (void)funj_showAlertBlocks:(id)delegate :(NSString *)title :(NSString *)msgtxt :(alertBlockCallback)callback;
+ (UIAlertController*)funj_showAlertBlock:(id)delegate :(NSString *)title :(NSString *)msgtxt :(NSArray*)button :(alertBlockCallback)callback;
+(void)funj_showSheetBlock:(id)target :(UIView*)sourceView :(NSString*)title :(NSArray *)buttonArr block:(alertBlockCallback)callback ;
//获取最顶层vc
+(UIViewController*)funj_getTopViewcontroller;
+(UIView*)funj_getKeyWindow;
@end


/// JButton.h

typedef void (^clickCallBack)(UIButton*button);
@interface JButton : UIButton
@property(nonatomic,assign)BOOL m_isNeedSelectHightColor; //是否需要改变点老击背影颜色
@property(nonatomic,assign)BOOL m_isDefalutNeedToSelectChange; //是否需要改变点击后状态
-(void)funj_resetProhibitActionTime:(CGFloat)time e:(BOOL)enable;// 设置连续事件点击间隔时间 ，防止重复点击，时间内按钮是否可用,YES:enable,NO:noenable
@end

// UIAlertController
@interface JAlertController : UIAlertController
@end

@interface JTextField : UITextField
@property(nonatomic,copy)NSString* textFieldMaxLengthKey;
@property(nonatomic,copy)NSString* textFieldInsertLengthKey;
@property(nonatomic,copy)NSString* textFieldInsertTextInputType;
@end
@interface JTextView : UITextView
@property(nonatomic,copy)NSString* textFieldMaxLengthKey;
@property(nonatomic,copy)NSString* textFieldInsertLengthKey;
@property(nonatomic,copy)NSString* textFieldInsertTextInputType;
@end
//UISearchBar
@protocol JSearchBarDelegate<NSObject>

- (BOOL)funj_searchShouldBeginEditing:(UITextField *)textField;
-(BOOL)funj_search:(UITextField *)textField inRange:(NSRange)range replacementString:(NSString *)string;
-(void)funj_searchReturnButtonClicked:(UITextField*)textField;
-(void)funj_searchCancelButtonClicked:(UITextField *)textField;
-(void)funj_searchDidEndEditing:(UITextField *)textField;
@end
@interface JSearchBar:UIView<UITextFieldDelegate>{
    NSString*_m_searchIcon;
}
@property(nonatomic,strong)UITextField *m_searchTF;
@property(nonatomic,copy)NSString* m_searchIcon;
@property(nonatomic,strong)UIButton *m_cancelButton;
@property(nonatomic,assign)BOOL m_cancelAlreadyShow;

@property(nonatomic,assign)id<JSearchBarDelegate>searchDelegate;
@property(nonatomic,assign)FilletValue m_filletValue;

-(void)funj_reloadSearchState:(BOOL)needIcon :(BOOL)needCancel;
-(void)funj_removeCancelButton;
@end

