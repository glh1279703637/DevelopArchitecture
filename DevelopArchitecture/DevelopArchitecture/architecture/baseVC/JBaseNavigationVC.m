//
//  JBaseNavigationVC.m
//  DevelopArchitecture
//
//  Created by Jeffrey on 15/6/19.
//  Copyright (c) 2015年 Jeffrey. All rights reserved.
//

#import "JBaseNavigationVC.h"
#import "JBaseViewController.h"
#import "JConstantHelp.h"

@interface JBaseNavigationVC ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>
@property(nonatomic,strong)UIImageView *m_barBottomLine;
@end

@implementation JBaseNavigationVC

-(id)initWithRootViewController:(JBaseViewController *)rootViewController{
    if (self = [super initWithRootViewController:rootViewController]) {
        _m_currentNavColor = kCURRENTISWHITENAV_TAG;
    }
    if([rootViewController isKindOfClass:[JBaseViewController class]]){
        if(rootViewController.m_pushOrPresentAnimateClass){
            self.transitioningDelegate = (id<UIViewControllerTransitioningDelegate>)rootViewController;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    //navigation  增加右滑动返回手势
    self.interactivePopGestureRecognizer.delegate = self;
    self.delegate=self;

    UINavigationBar *bar = [UINavigationBar appearance];
    _m_barBottomLine =[UIImageView funj_getImageView:CGRectMake(0, bar.height, bar.width, 1) bgColor:kColor_Blue];
    [bar addSubview:_m_barBottomLine];
 }
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setM_currentNavColor:_m_currentNavColor];
}
-(void)setM_currentNavColor:(currentNavColor)m_currentNavColor{
    _m_currentNavColor = m_currentNavColor;
    UINavigationBar *bar = self.navigationBar;
    if(!bar)return;
    switch (_m_currentNavColor) {
        case kCURRENTISBLUENAV_TAG:{
            [bar setTitleTextAttributes:@{
                                          NSForegroundColorAttributeName : kColor_White,NSFontAttributeName:kFont_BoldSize20}];
            self.navigationBar.barTintColor=kColor_Blue;
            _m_barBottomLine.backgroundColor = kColor_Blue;
        }break;
        case kCURRENTISWHITENAV_TAG:{
            [bar setTitleTextAttributes:@{
                                          NSForegroundColorAttributeName : kColor_Text_Black_Dark,NSFontAttributeName:kFont_BoldSize20}];
            self.navigationBar.barTintColor=kColor_White_Dark;
            _m_barBottomLine.backgroundColor = kColor_Line_Gray_Dark;
        }break;
        case kCURRENTISGRAYNAV_TAG:{
            [self.navigationBar setBackgroundImage:[JAppUtility funj_imageWithColor:kColor_Bg_LightGray_Dark :CGSizeMake(1, 1)] forBarMetrics:UIBarMetricsDefault];
            [self.navigationBar setShadowImage:[JAppUtility funj_imageWithColor:kColor_Bg_LightGray_Dark  :CGSizeMake(1, 1)]];
            [self.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName : kColor_Text_Black,NSFontAttributeName:kFont_BoldSize20}];
            _m_barBottomLine.backgroundColor = kColor_Bg_LightGray_Dark;
        }break;
        default:
            break;
    }
}


- (BOOL)shouldAutorotate{
    return [[self.viewControllers lastObject] shouldAutorotate];
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [[self.viewControllers lastObject] supportedInterfaceOrientations];
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return [[self.viewControllers lastObject] preferredStatusBarStyle];
}
//设置是否隐藏
- (BOOL)prefersStatusBarHidden {
    return [[self.viewControllers lastObject] prefersStatusBarHidden];
}
//设置隐藏动画
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return [[self.viewControllers lastObject]preferredStatusBarUpdateAnimation];
}
 
//over pushviewcontroller
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    // fix 'nested pop animation can result in corrupted navigation bar'
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    [super pushViewController:viewController animated:animated];
}
- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(JBaseViewController *)viewController
                    animated:(BOOL)animated{
    if ([viewController isKindOfClass:[JBaseViewController class]]  && viewController.m_currentPushIsNeedinteractivePopGestureRecognizer) {
        if (viewController == navigationController.viewControllers[0]){
            navigationController.interactivePopGestureRecognizer.enabled = NO;
        }else{
            navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
    }
}

//#pragma mark 主要作用是由于WKWebView 调用相册中浏览cloud 时，然后直接取消后对应的view出现basevc 也会跟着消失 可选，只wekbview 需要导入图片时需要启用此两方法
//-(void)presentViewController:(UIViewController *)viewControllerToPresent animated: (BOOL)flag completion:(void (^ __nullable)(void))completion{
//    [[self.viewControllers lastObject] presentViewController:viewControllerToPresent animated:flag completion:completion];
//}
//-(void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion{
//    [[self.viewControllers lastObject]dismissViewControllerAnimated:flag completion:completion];
//}
#pragma mark push animate
- (nullable id <UIViewControllerAnimatedTransitioning>) navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(JBaseViewController *)toVC{
    if([toVC isKindOfClass:[JBaseViewController class]]  && toVC.m_pushOrPresentAnimateClass) {
        return [[NSClassFromString(toVC.m_pushOrPresentAnimateClass) alloc]init];
    }
    return nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
