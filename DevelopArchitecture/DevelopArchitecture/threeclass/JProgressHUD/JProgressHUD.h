//
//  JProgressHUD.h
//  DevelopArchitecture
//
//  Created by Jeffrey on 2017/11/17.
//  Copyright © 2017年 Jeffrey. All rights reserved.
//


#import <UIKit/UIKit.h>
@interface JProgressHUD : UIView
-(void)funj_showProgressView;
-(void)funj_showProgressView:(NSString*)title;
-(void)funj_stopProgressAnimate;
@end

typedef void (^completeCallback)(void);
typedef NS_ENUM(NSInteger,MprogressType) {
    kprogressType,
    kprogressType_OnlyText
};
@interface JMProgressHUD : UIView
+(id)share;
-(id)initWithView:(UIView*)superView t:(MprogressType)type;

-(void)funj_reloadSuperView:(UIView*)superView t:(MprogressType)type;

-(void)funj_showProgressViews:(NSString*)title;
-(void)funj_showProgressViews:(NSString*)title t:(CGFloat)time complete:(completeCallback)complete;
-(void)funj_stopProgressAnimate;
@end
