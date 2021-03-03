//
//  JBaseViewController.m
//  DevelopArchitecture
//
//  Created by Jeffrey on 15/6/19.
//  Copyright (c) 2015年 Jeffrey. All rights reserved.
//

#import "JBaseViewController.h"
#import "JProgressHUD.h"
#import "JBaseNavigationVC.h"
#import <objc/runtime.h>

@interface JBaseViewController ()<UIViewControllerTransitioningDelegate>
@property(nonatomic,strong)JProgressHUD *m_mbProgressHUD;
//@property(nonatomic,assign)BOOL  isNeedDissVC; //主要作用是由于WKWebView 调用相册中浏览cloud 时，然后直接取消后对应的view出现basevc 也会跟着消失 可选，只wekbview 需要导入图片时需要启用此两方法

@end

@implementation JBaseViewController
-(id)init{
    if(self=[super init]){
        _m_currentShowVCModel=kCURRENTISNONE;
        _m_currentPushIsNeedinteractivePopGestureRecognizer=YES;
        //        _isNeedDissVC = YES;
    }
    return self;
}
maddProperyValue(m_dataArray, NSMutableArray)
maddProperyValue(m_dataDic, NSMutableDictionary)
maddProperyValue(m_dataString, NSMutableString)
maddProperyValue(m_mbProgressHUD, JProgressHUD)

-(void)setM_pushOrPresentAnimateClass:(NSString *)m_pushOrPresentAnimateClass{
    _m_pushOrPresentAnimateClass = m_pushOrPresentAnimateClass;
    self.transitioningDelegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;//可以解决ios7.0的上移的问题
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    
    if(self.m_currentShowVCModel != kCURRENTISSHOWDETAIL){
        JBaseNavigationVC *nav = (JBaseNavigationVC*)self.navigationController;
        NSString *icon =   @"backBt" ;
        if(nav && [nav isKindOfClass:[JBaseNavigationVC class]] && nav.m_currentNavColor == kCURRENTISWHITENAV_TAG){
            icon = @"backBt2";
        }
        UIBarButtonItem *backBt =[UIBarButtonItem funj_getNavPublicButton:self  title:nil  action:@"funj_clickBackButton:" image:icon  :^(UIButton *button) {
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        }];
        self.navigationItem.leftBarButtonItems = @[backBt];
    }
    self.view.backgroundColor=kColor_White_Dark;
    [self setNeedsStatusBarAppearanceUpdate];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(funj_keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];

}
-(UIButton*)funj_addBackButton:(NSString*)backImage{
    UIButton *backBt =[UIButton funj_getButtons:CGRectMake(0, kStatusBarHeight, 50, 44) :nil  :JTextFCZero() :@[backImage?backImage:@"backBt"] :self  :@"funj_clickBackButton:" :8800 :nil];
    [self.view addSubview:backBt];
    return backBt;
}

-(void)viewWillDisappear:(BOOL)animated{
    [[SDImageCache sharedImageCache] clearMemory];//可有可无
    [self funj_closeLoadingProgressView];
    [super viewWillDisappear:animated];
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}
//设置是否隐藏
- (BOOL)prefersStatusBarHidden {
    return NO;
}
//设置隐藏动画
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationNone;
}
- (BOOL)shouldAutorotate{
    return YES;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}
-(void) funj_showProgressViewType:(NSInteger) type{
    //    NSArray *array= @[LocalStr(@"Data loading..."),LocalStr(@"Data requesting..."),LocalStr(@"Data deleting..."),
    //                      LocalStr(@"Data processing..."),LocalStr(@"Removing..."),LocalStr(@"Data committing..."),
    //                      LocalStr(@"Creating..."),LocalStr(@"Modifying..."),LocalStr(@"Searching..."),
    //                      LocalStr(@"Uploading..."),LocalStr(@"Logining..."),LocalStr(@"Registing...")];
    //    [self funj_showProgressView:array[type]];
    [self.m_mbProgressHUD funj_showProgressView];
}
-(void) funj_showProgressView:(NSString*) hintString{
    [self.m_mbProgressHUD funj_showProgressView:hintString];
}

- (void)funj_closeLoadingProgressView{
    [self.m_mbProgressHUD funj_stopProgressAnimate];
}
#pragma mark keyboard action
- (void)funj_keyboardWillChangeFrame:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame   = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect beginFrame = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = (UIViewAnimationCurve)[userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    void(^animations)(void) = ^{
        [self funj_willShowKeyboardFromFrame:beginFrame toFrame:endFrame];
    };
    [UIView animateWithDuration:duration delay:0.0f options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:animations completion:nil];
}
- (void)funj_willShowKeyboardFromFrame:(CGRect)beginFrame toFrame:(CGRect)toFrame{ }
-(void)funj_setBaseControllerData:(id)data{
    if(data){
        if([data isKindOfClass:[NSString class]]){
            [self.m_dataString appendString:data];
        }else if([data isKindOfClass:[NSArray class]]){
            [self.m_dataArray addObjectsFromArray:data];
        }else if([data isKindOfClass:[NSDictionary class]]){
            [self.m_dataDic addEntriesFromDictionary:data];
        }
    }
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller traitCollection:(UITraitCollection *)traitCollection{
    return UIModalPresentationNone;
}
// Called on the delegate when the popover controller will dismiss the popover. Return NO to prevent the
// dismissal of the view.
- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    return YES;
}
-(BOOL)presentationControllerShouldDismiss:(UIPresentationController *)presentationController API_AVAILABLE(ios(13.0)){
     return YES;
}
-(void)funj_backViewController{
    if(self.m_currentShowVCModel == kCURRENTISPUSH){
        [self.navigationController popViewControllerAnimated:YES];
    }else if(self.m_currentShowVCModel == kCURRENTISPRENTVIEW){
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if(self.m_currentShowVCModel == kCURRENTISSHOWDETAIL){
        
    }else if(self.m_currentShowVCModel == kCURRENTISPOPOVER){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
//#pragma mark 主要作用是由于WKWebView 调用相册中浏览cloud 时，然后直接取消后对应的view出现basevc 也会跟着消失 可选，只wekbview 需要导入图片时需要启用此两方法
//- (void)presentViewController:(UIViewController *)viewControllerToPresent animated: (BOOL)flag completion:(void (^ __nullable)(void))completion{
//    [super presentViewController:viewControllerToPresent animated:flag completion:completion];
//    self.isNeedDissVC = YES;
//    if(@available(iOS 12.0,*)){}else{
//        if([viewControllerToPresent isKindOfClass:NSClassFromString(@"UIDocumentPickerViewController")]){
//            self.isNeedDissVC = NO;
//        }
//    }
//}
//-(void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion{
//    if(self.isNeedDissVC)[super dismissViewControllerAnimated:flag completion:completion];
//    self.isNeedDissVC = YES;
//}
#pragma mark present viewcontroller
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    JBaseViewController *vc = (JBaseViewController*)self;
    if(vc.m_pushOrPresentAnimateClass){
        return [[NSClassFromString(vc.m_pushOrPresentAnimateClass) alloc]init];
    }
    return nil;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    JBaseViewController *vc = (JBaseViewController*)self;
    if(vc.m_pushOrPresentAnimateClass){
        return [[NSClassFromString(vc.m_pushOrPresentAnimateClass) alloc]init];
    }
    return nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[SDImageCache sharedImageCache] clearMemory];//可有可无
}
@end

@implementation UIViewController(JBaseViewController)
-(void) funj_showProgressViewType:(NSInteger) type{}
-(void) funj_showProgressView:(NSString*) hintString{}
- (void)funj_closeLoadingProgressView{}
-(void)funj_setBaseControllerData:(id)data{ }


-(JBaseViewController*)funj_getPresentVCWithController:(NSString*)className title:(NSString*)title :(id)data :(BOOL)isNav{
    JBaseViewController *controller=[self funj_getPresentCallbackVCWithController:className title:title :data :isNav :nil];
    return controller;
}
-(JBaseViewController*)funj_getPresentCallbackVCWithController:(NSString*)className title:(NSString*)title :(id)data :(BOOL)isNav :(setBaseVC)callback{
    if(![JHttpReqHelp funj_checkNetworkType])return nil;
    JBaseViewController *controller=[[NSClassFromString(className) alloc]init];
    if(!controller)return nil;
    controller.title=title;
    if([controller isKindOfClass:[JBaseViewController class]]){
        
        [controller funj_setBaseControllerData:data];
        controller.m_currentShowVCModel=kCURRENTISPRENTVIEW;
    }
    controller.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    
    JBaseNavigationVC *nav =nil;
    if(isNav){
        nav =[[JBaseNavigationVC alloc]initWithRootViewController:controller];
        nav.modalPresentationStyle = UIModalPresentationFullScreen;//配置present类型
    }else{
        controller.modalPresentationStyle = UIModalPresentationFullScreen;//配置present类型
    }
    if(callback)callback(controller);
    [self presentViewController:isNav?nav:controller animated:YES completion:nil];
    
    return controller;
}

-(JBaseViewController*)funj_getPushVCWithController:(NSString*)className title:(NSString*)title :(id)data{
    JBaseViewController *controller=[self funj_getPushCallbackVCWithController:className title:title :data :nil];
    return controller;
}
-(JBaseViewController*)funj_getPushCallbackVCWithController:(NSString*)className title:(NSString*)title :(id)datas :(setBaseVC)callback{
    if(![JHttpReqHelp funj_checkNetworkType])return nil;
    JBaseViewController *controller=[[NSClassFromString(className) alloc]init];
    controller.title=title;
    if([controller isKindOfClass:[JBaseViewController class]]){
        [controller funj_setBaseControllerData:datas];
        controller.m_currentShowVCModel=kCURRENTISPUSH;
    }
    if(callback)callback(controller);
    
    [self.navigationController pushViewController:controller animated:YES];
    return controller;
}

-(JBaseViewController*)funj_replacePushCallbackVCWithController:(NSString*)className title:(NSString*)title :(id)data :(setBaseVC)callback{
    if(![JHttpReqHelp funj_checkNetworkType])return nil;
    UINavigationController *vcs = [self isKindOfClass:[UINavigationController class]] ? (UINavigationController*)self : self.navigationController;
    NSMutableArray *array =[[NSMutableArray alloc]initWithArray:vcs.childViewControllers];
    JBaseViewController *controller=[[NSClassFromString(className) alloc]init];
    if(!controller)return nil;
    controller.title=title;
    JBaseViewController *vc = [array lastObject];
    if([controller isKindOfClass:[JBaseViewController class]]){
        [controller funj_setBaseControllerData:data];
        controller.m_currentShowVCModel=kCURRENTISPUSH;
        
        if([vc isKindOfClass:[JBaseViewController class]]){
            controller.m_currentShowVCModel = vc.m_currentShowVCModel;
            if(vc.m_currentShowVCModel == kCURRENTISPRENTVIEW){
                controller.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
            }
        }
    }
    [array removeLastObject];
    [array addObject:controller];
    if(callback)callback(controller);
    
    [vcs setViewControllers:array animated:NO];
    return controller;
}
-(JBaseViewController*)funj_getShowSplitDetailVC:(NSString *)className title:(NSString*)title  :(id)data :(BOOL)isNav{
    JBaseViewController *controller =[self funj_getShowSplitDetailVC:className title:title :data :isNav :nil];
    return controller;
}
-(JBaseViewController*)funj_getShowSplitDetailVC:(NSString *)className title:(NSString*)title  :(id)data :(BOOL)isNav :(setBaseVC)callback{
    if(![JHttpReqHelp funj_checkNetworkType])return nil;
    JBaseViewController *controller=[[NSClassFromString(className) alloc]init];
    if(!controller)return nil;
    controller.title=title;
    if([controller isKindOfClass:[JBaseViewController class]]){
        [controller funj_setBaseControllerData:data];
        controller.m_currentShowVCModel=IS_IPAD?kCURRENTISSHOWDETAIL:kCURRENTISPRENTVIEW;
    }
    JBaseNavigationVC *nav =nil;
    if(isNav){
        nav =[[JBaseNavigationVC alloc]initWithRootViewController:controller];
    }
    if(callback)callback(controller);
    if(IS_IPAD) [self.splitViewController showDetailViewController:isNav?nav:controller sender:nil];
    else {
        controller.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
        if(isNav) nav.modalPresentationStyle = UIModalPresentationFullScreen;//配置present类型
        else controller.modalPresentationStyle = UIModalPresentationFullScreen;//配置present类型
        [self presentViewController:isNav?nav:controller animated:YES completion:nil];
    }
    return controller;
}
-(JBaseViewController*)funj_getPopoverVC:(NSString *)className :(UIView*)target  :(id)data :(CGSize)size  :(BOOL)isNav :(setPopverBaseVC)callback{
    if(![JHttpReqHelp funj_checkNetworkType])return nil;
    JBaseViewController *controller=[[NSClassFromString(className) alloc]init];
    if(!controller)return nil;
    if([controller isKindOfClass:[JBaseViewController class]]){
        [controller funj_setBaseControllerData:data];
        controller.m_currentShowVCModel=kCURRENTISPOPOVER;
    }
    JBaseNavigationVC *nav =nil;
    if(isNav){
        nav =[[JBaseNavigationVC alloc]initWithRootViewController:controller];
    }
    int setPrentView = 0;
    if(callback)callback(controller,&setPrentView);
    if(!setPrentView){
        [self funj_setPresentIsPoperView:isNav?nav:controller :size :target];
    }else{
        if(isNav) nav.modalPresentationStyle = UIModalPresentationFullScreen;//配置present类型
        else controller.modalPresentationStyle = UIModalPresentationFullScreen;//配置present类型

        if([controller isKindOfClass:[JBaseViewController class]]){
            controller.m_currentShowVCModel=kCURRENTISPRENTVIEW;
        }
    }
    
    [self presentViewController:isNav?nav:controller animated:YES completion:nil];//弹出视图

    return controller;
    
}
-(void)funj_setPresentIsPoperView:(UIViewController*)controller :(CGSize)size :(UIView*)target{
    controller.modalPresentationStyle = UIModalPresentationPopover;//配置推送类型
    controller.preferredContentSize = size;//设置弹出视图大小必须好推送类型相
    UIPopoverPresentationController *pover = controller.popoverPresentationController;
    if(target){
        [pover setSourceRect:target.bounds];//弹出视图显示位置
        [pover setSourceView:target];//设置目标视图，这两个是必须设置的。
    }else{
        UIView *views = self.view;
        if(self.navigationController && self.navigationController.view){
            views = self.navigationController.view;
        }
        [pover setSourceRect:views.bounds];//弹出视图显示位置
        [pover setSourceView:views];//设置目标视图，这两个是必须设置的。
        [pover setPermittedArrowDirections:0];
    }
     pover.delegate = [controller isKindOfClass:[UINavigationController class]]?([[(UINavigationController*)controller childViewControllers]lastObject]) : controller;

}
-(void)funj_clickBackButton:(UIButton*)sender{
    [[JAppViewTools funj_getKeyWindow] endEditing:YES];
    UIViewController * presentedVC = self.presentedViewController;
    while (presentedVC.presentedViewController) {
        presentedVC = presentedVC.presentedViewController;
    }
    [self funj_closeLoadingProgressView];
    if(!presentedVC){
        [self funj_backViewController];
    }else{
        [self funj_disMissViewController:presentedVC];
    }
}
-(void)funj_disMissViewController:(UIViewController*)presentedVC{
    if(!([presentedVC isEqual:self] || [presentedVC isEqual:self.navigationController])){
        UIViewController *presentingVC = presentedVC.presentingViewController;
        LRWeakSelf(presentingVC);
        LRWeakSelf(self);
        [presentedVC dismissViewControllerAnimated:NO  completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                LRStrongSelf(self);
                LRStrongSelf(presentingVC);
                [self funj_disMissViewController:presentingVC];
            });
        }];
    }else{
        [self funj_backViewController];
    }
}
-(void)funj_backViewController{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
