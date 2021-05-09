//
//  JMainViewController.m
//  DevelopArchitecture
//
//  Created by Jeffrey on 15/6/19.
//  Copyright (c) 2015年 Jeffrey. All rights reserved.
//

#import "JMainViewController.h"
#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>
#import "UIView+WebCache.h"
#import "JProgressHUD.h"
#import "JQRScanCodeVC.h"
#import "JPhotosPreviewsVC.h"
#import <AuthenticationServices/AuthenticationServices.h>
#import <UserNotifications/UserNotifications.h>
#import "JNetworkPingManager.h"
#import "NSObject+YYModel.h"
#import "JFileManageHelp.h"

static JMainViewController *mainVC=nil;
@interface JMainViewController ()<PHPickerViewControllerDelegate>

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

    UIButton *buttonBt =[UIButton funj_getButtonBlock:CGRectMake(50, 80, 80, 50) t:@"点击" fc:JTextFCMake(kFont_Size15, kColor_Orange) bg:@[kColor_Blue] tag:0 c:^(UIButton *button) {
//        self.m_currentIsLoadMultPhoto = YES;
//        self.m_currentCanSelectMaxImageCount = 10;
//        self.m_cropFrame = CGRectMake((kWidth/2/2), kHeight/2/2, kWidth/2, kHeight/2);
//        [self funj_editPortraitImageView:button];
        
//    [[[JHttpReqHelp share] funj_requestToServer:nil url:@"mobile/login" v:@{@"account":@"15911111111",@"password":@"111111"}]
//            funj_addSuccess:^(id viewController, NSArray *dataArr, NSDictionary *dataDic) {
//
//            NSLog(@"-- -- ");
//        }];
        [[[JHttpReqHelp share] funj_requestToServer:nil url:@"mobile/login" v:@{@"account":@"15911111111",@"password":@"111111"}]
            funj_addModleClass:@"JUserInfoModel" c:^(id viewController, NSArray *dataArr, id dataModel) {
                
        }];
            
        
        NSLog(@"-- ");

    }];
    [self.view addSubview:buttonBt];
}
@end

