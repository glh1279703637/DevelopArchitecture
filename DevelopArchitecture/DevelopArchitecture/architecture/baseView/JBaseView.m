//
//  JBaseView.m
//  DevelopArchitecture
//
//  Created by Jeffrey on 15/6/19.
//  Copyright (c) 2015年 Jeffrey. All rights reserved.
//

#import "JBaseView.h"
#import "JProgressHUD.h"
@interface JBaseView()
@property(nonatomic,strong)JProgressHUD *m_mbProgressHUD;
@end
@implementation JBaseView
maddProperyValue(m_mbProgressHUD, JProgressHUD)
-(void) funj_showProgressViewType:(NSInteger) type{
    //    NSArray *array= @[LocalStr(@"Data loading..."),LocalStr(@"Data requesting..."),LocalStr(@"Data deleting..."),
    //                      LocalStr(@"Data processing..."),LocalStr(@"Removing..."),LocalStr(@"Data committing..."),
    //                      LocalStr(@"Creating..."),LocalStr(@"Modifying..."),LocalStr(@"Searching..."),
    //                      LocalStr(@"Uploading..."),LocalStr(@"Logining..."),LocalStr(@"Registing...")];
    //    [self funj_showProgressView:array[type]];
    [self.m_mbProgressHUD funj_showProgressView];
}
-(void) funj_showProgressView:(NSString*) hintString{
     [self.m_mbProgressHUD funj_showProgressView];
}

- (void)funj_closeLoadingProgressView
{
    [self.m_mbProgressHUD funj_stopProgressAnimate];
}


@end
