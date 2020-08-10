//
//  JMainViewController.m
//  DevelopArchitecture
//
//  Created by Jeffrey on 15/6/19.
//  Copyright (c) 2015年 Jeffrey. All rights reserved.
//

#import "JMainViewController.h"
#import <Photos/Photos.h>
#import "UIView+WebCache.h"
#import "JProgressHUD.h"
#import "JQRScanCodeVC.h"
#import "JPhotosPreviewsVC.h"
#import <AuthenticationServices/AuthenticationServices.h>
#import <UserNotifications/UserNotifications.h>

static JMainViewController *mainVC=nil;
@interface JMainViewController ()

@end

@implementation JMainViewController
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self=[super initWithCoder: aDecoder]){
        mainVC=self;
    }
    return self;
}
-(id)init{
    if(self=[super init]){
        
    }
    return self;
}
+(id)shareMainVC{
    if(!mainVC){
        mainVC=[[JMainViewController alloc]init];
    }
    return mainVC;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=COLOR_WHITE;

    UIButton *buttonBt =[UIButton funj_getButtonBlock:CGRectMake(50, 80, 80, 50) :@"点击" :JTextFCMake(PUBLIC_FONT_SIZE15, COLOR_ORANGE) :@[COLOR_BLUE] :0 :^(UIButton *button) {
//        self.m_currentIsLoadMultPhoto = YES;
//        self.m_currentCanSelectMaxImageCount = 10;
//        self.m_cropFrame = CGRectMake((KWidth/2/2), KHeight/2/2, KWidth/2, KHeight/2);
//        [self funj_editPortraitImageView:button];
        
        [self funj_getPresentVCWithController:@"JQRScanCodeVC" title:nil  :nil :NO];
        
        
    }];
    [self.view addSubview:buttonBt];

//    UIButton *keyBt =[UIButton funj_getButtonBlock:CGRectMake(200, 80, 80, 50) :LocalStr(@"Skip") :JTextFCMake(PUBLIC_FONT_SIZE15, COLOR_WHITE) :@[COLOR_BLUE] :0 :^(UIButton *button) {
//        if(self.navigationController){
//            JBaseViewController *vc =[[JBaseViewController alloc]init];
//            vc.m_currentShowVCModel = kCURRENTISPUSH;
//            vc.m_pushOrPresentAnimateClass = @"JBaseTransition";
//            [self.navigationController pushViewController:vc  animated:YES];
//        }else{
//            JBaseViewController *vc =[[JBaseViewController alloc]init];
//            vc.m_currentShowVCModel = kCURRENTISPRENTVIEW;
//            vc.m_pushOrPresentAnimateClass = @"JBaseTransition";
//            JBaseNavigationVC *nav =[[JBaseNavigationVC alloc]initWithRootViewController:vc];
//            nav.modalPresentationStyle = UIModalPresentationFullScreen;//配置present类型
//            [self presentViewController:nav  animated:YES completion:nil];
//        }
//    }];
//    [self.view addSubview:keyBt];
//
//    [keyBt funj_setViewShadowLayer];
//
//    {
//        for(int i=0;i<9;i++){
//            UIButton *addButton =[UIButton funj_getButtonBlocks:CGRectMake(20+210*(i%4), KHeight/2+(i/4)*80, 200, 70) :@"容容容" :JTextFCMake(PUBLIC_FONT_SIZE15, COLOR_WHITE) :@[@"aaaa"] :0 :^(id strongSelf,UIButton*button) {
//                button.alpha = 0.8;
//                button.backgroundColor =COLOR_BLUE;
//                button.imageView.backgroundColor = COLOR_ORANGE;
//            } :^(UIButton *button) { }];
//            [self.view insertSubview:addButton atIndex:0];
//            [addButton funj_updateContentImageLayout:i  a:JAlignMake(10, 5, 10)];
//            if(i <4)[addButton funj_setViewShadowLayer];
//
//            UIImageView *line = [UIImageView funj_getLineImageView:CGRectMake(0, addButton.height/2, addButton.width, 1)]; //-
//            [addButton addSubview:line];
//            UIImageView *line2 = [UIImageView funj_getLineImageView:CGRectMake(addButton.width/2, 0, 1, addButton.height)]; //|
//            [addButton addSubview:line2];
//            line.alpha = line2.alpha = 0.4;
//
//        }
//    }
//    [self funj_reloadBaseViewParameter:CGRectZero :CGRectMake(0, 0, KWidth, KHeight64) :YES];
//    [self funj_reloadTableViewToSolveData:^(BOOL isHead, BOOL isSearch, NSInteger page) {
//        NSLog(@"-- -- %zd",page);
//        if(page >5){
//            [self.m_tableView setM_currentPageType:2];
//        }
//    }];
//    [self.m_tableView funj_addFooterWithCallback:^(NSInteger page) {
//
//    }];
}
@end

