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

//    UIButton *buttonBt =[UIButton funj_getButtonBlock:CGRectMake(50, 80, 80, 50) :@"点击" :JTextFCMake(PUBLIC_FONT_SIZE15, COLOR_ORANGE) :@[COLOR_BLUE] :0 :^(UIButton *button) {
//        self.m_currentIsLoadMultPhoto = YES;
//        self.m_currentCanSelectMaxImageCount = 10;
//        self.m_cropFrame = CGRectMake((KWidth/2/2), KHeight/2/2, KWidth/2, KHeight/2);
//        [self funj_editPortraitImageView:button];
//    }];
//    [self.view addSubview:buttonBt];

    UIButton *buttonBt2 = [UIButton funj_getButtons:CGRectMake(100, 100, 100, 30) :@"idididid" :JTextFCMake(PUBLIC_FONT_SIZE14, COLOR_ORANGE) :@[@"main_search_n"] :nil :nil :0 :nil ];
    buttonBt2.backgroundColor = COLOR_BLUE;
    [self.view addSubview:buttonBt2];
    [buttonBt2 funj_updateContentImageLayout:kCENTER_IMAGECONTENT a:JAlignMake(0, 5, 0)];
    
    [buttonBt2 funj_setViewGradientLayer:YES :@[COLOR_RED,COLOR_ORANGE] :@[@(0),@(1)]];

}
- (void)picker:(PHPickerViewController *)picker didFinishPicking:(NSArray<PHPickerResult *> *)results{
    
}
@end

