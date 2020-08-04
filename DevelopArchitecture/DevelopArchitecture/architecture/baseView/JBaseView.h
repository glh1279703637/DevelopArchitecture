//
//  JBaseView.h
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
@interface JBaseView : UIView
-(void) funj_showProgressViewType:(NSInteger) type;
-(void) funj_showProgressView:(NSString*) hintString ;
- (void)funj_closeLoadingProgressView;

@end
