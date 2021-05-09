//
//  JBaseViewController.h
//  DevelopArchitecture
//
//  Created by Jeffrey on 15/6/19.
//  Copyright (c) 2015年 Jeffrey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JConstantHelp.h"
#import "JAppViewExtend.h"
#import "JWhenTappedView.h"
#import "JReloadImageView.h"
#import "JBaseNavigationVC.h"
#import "JHttpReqHelp.h"
#import "JLoginUserModel.h"


typedef NS_ENUM(NSInteger,SHOWMODELTYPE){
    kCURRENTISNONE,
    kCURRENTISPUSH,
    kCURRENTISPRENTVIEW,
    kCURRENTISSHOWDETAIL,
    kCURRENTISPOPOVER
};
 
@class JBaseViewController;
typedef void (^setBaseVC) (JBaseViewController *vc);
typedef void (^setPopverBaseVC) (JBaseViewController *vc,int * isPresentView);

@interface JBaseViewController : UIViewController<UIPopoverPresentationControllerDelegate>
//用于传数据所用
@property(nonatomic,strong)NSMutableString *m_dataString;
@property(nonatomic,strong)NSMutableArray *m_dataArray;
@property(nonatomic,strong)NSMutableDictionary *m_dataDic;

//当前是否通过 presentViewController 显示的VC  default is no
@property(nonatomic,assign)SHOWMODELTYPE m_currentShowVCModel;

//当前是否需要通过手势返回上层的界面 default is yes
@property(nonatomic,assign)BOOL m_currentPushIsNeedinteractivePopGestureRecognizer;
// 界面跳转push 或者present 时动画跳转
@property(nonatomic,copy)NSString *m_pushOrPresentAnimateClass;

-(UIButton*)funj_addBackButton:(NSString*)backImage;
@end


@interface UIViewController(JBaseViewController)
-(void)funj_showProgressViewType:(NSInteger) type;
-(void)funj_showProgressView:(NSString*) hintString;

- (void)funj_closeLoadingProgressView;

-(void)funj_setBaseControllerData:(id)data;

-(void)funj_setPresentIsPoperView:(UIViewController*)controller size:(CGSize)size t:(UIView*)target;

//将data 转换成m_datastring ,m_dataarray ,m_datadic的方法
-(JBaseViewController*)funj_getPresentVCWithController:(NSString*)className t:(NSString*)title d:(id)data isNav:(BOOL)isNav;
-(JBaseViewController*)funj_getPresentCallbackVCWithController:(NSString*)className t:(NSString*)title d:(id)data isNav:(BOOL)isNav set:(setBaseVC)callback;

-(JBaseViewController*)funj_getPushVCWithController:(NSString*)className t:(NSString*)title d:(id)data;
-(JBaseViewController*)funj_getPushCallbackVCWithController:(NSString*)className t:(NSString*)title d:(id)data set:(setBaseVC)callback;

-(JBaseViewController*)funj_replacePushCallbackVCWithController:(NSString*)className t:(NSString*)title d:(id)data set:(setBaseVC)callback;

-(JBaseViewController*)funj_getShowSplitDetailVC:(NSString *)className t:(NSString*)title  d:(id)data isNav:(BOOL)isNav;
-(JBaseViewController*)funj_getShowSplitDetailVC:(NSString *)className t:(NSString*)title  d:(id)data isNav:(BOOL)isNav set:(setBaseVC)callback;

-(JBaseViewController*)funj_getPopoverVC:(NSString *)className target:(UIView*)target  d:(id)data size:(CGSize)size isNav:(BOOL)isNav set:(setPopverBaseVC)callback;

-(void)funj_clickBackButton:(UIButton*)sender;
@end
