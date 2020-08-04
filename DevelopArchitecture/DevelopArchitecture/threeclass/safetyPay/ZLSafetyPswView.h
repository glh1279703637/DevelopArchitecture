//
//  ZLSafetyPswView.h
//  SafetyPay
//
//  Created by ZL on 2017/4/10.
//  Copyright © 2017年 ZL. All rights reserved.
//  加密支付页面

#import <UIKit/UIKit.h>

@protocol ZLSafetyPswViewDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField;
@end

@interface ZLSafetyPswView : UIView

@property(nonatomic,weak) id<ZLSafetyPswViewDelegate>delegate;
// 密码输入文本框
@property (nonatomic, strong) UITextField *pswTextField;
/**
 *  清除密码
 */
- (void)clearUpPassword;

/**
 * 用户输入密码返回
 */
@property (nonatomic, copy) void(^passwordDidChangeBlock)(NSString *password);

+(NSInteger)canInputPayPassword;
+(void)setLastErrorPayPasswordCount:(BOOL)iserror;

@end
