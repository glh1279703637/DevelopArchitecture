//
//  UIImageView+JReloadImageView.h
//  DevelopArchitecture
//
//  Created by Jeffrey on 15/2/4.
//  Copyright (c) 2015年 Jeffrey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"

@interface UIImageView (JReloadImageView)
//具有缓存图片的同时也具有保存图片的功能
-(void)funj_setInternetImage:(NSString*)imageUrl :(NSString*)placeholderImage;

-(void)funj_setInternetImageBlock:(NSString*)imageUrl :(NSString*)placeholderImage  :(SDExternalCompletionBlock)completedBlocks;

@end
