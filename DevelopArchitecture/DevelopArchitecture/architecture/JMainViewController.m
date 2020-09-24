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

    UIButton *buttonBt =[UIButton funj_getButtonBlock:CGRectMake(50, 80, 80, 50) :@"点击" :JTextFCMake(PUBLIC_FONT_SIZE15, COLOR_ORANGE) :@[COLOR_BLUE] :0 :^(UIButton *button) {
        self.m_currentIsLoadMultPhoto = YES;
        self.m_currentCanSelectMaxImageCount = 10;
        self.m_cropFrame = CGRectMake((KWidth/2/2), KHeight/2/2, KWidth/2, KHeight/2);
        [self funj_editPortraitImageView:button];
        
//        if (@available(iOS 14, *)) {
        NSLog(@"-- -- %@",self);
//            [[PHPhotoLibrary sharedPhotoLibrary] presentLimitedLibraryPickerFromViewController:self];
//        } else {
//            // Fallback on earlier versions
//        }

//        [self funj_getPresentVCWithController:@"JQRScanCodeVC" title:nil  :nil :NO];
        
//        PHPickerConfiguration *configuration = [[PHPickerConfiguration alloc] init];
//        configuration.filter = [PHPickerFilter videosFilter]; // 可配置查询用户相册中文件的类型，支持三种
//      configuration.selectionLimit = 0; // 默认为1，为0时表示可多选。
//
//        PHPickerViewController *picker = [[PHPickerViewController alloc] initWithConfiguration:configuration];
//        picker.delegate = self;
//        // picker vc，在选完图片后需要在回调中手动 dismiss
//      [self presentViewController:picker animated:YES completion:^{
//
//        }];
    }];
    [self.view addSubview:buttonBt];
    
    LRWeakSelf(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        LRStrongSelf(self);
        UILabel *titleLabel =[UILabel funj_getLabel:CGRectMake(0, 330, 200, 40) :JTextFCMake(PUBLIC_FONT_SIZE16, COLOR_ORANGE)];
        [self.view addSubview:titleLabel];
        titleLabel.text = NSLocalizedString(@"Get verification code", nil);
    });

}
- (void)picker:(PHPickerViewController *)picker didFinishPicking:(NSArray<PHPickerResult *> *)results{
    
}
@end

