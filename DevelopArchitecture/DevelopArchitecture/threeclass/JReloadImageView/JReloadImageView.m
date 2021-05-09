//
//  UIImageView+JReloadImageView.m
//  DevelopArchitecture
//
//  Created by Jeffrey on 15/2/4.
//  Copyright (c) 2015年 Jeffrey. All rights reserved.
//

#import "JReloadImageView.h"
#import "UIView+WebCache.h"

@implementation UIImageView (JReloadImageView)
-(NSString*)funj_checkUrl:(NSString*)imageUrl{
    if(!imageUrl || imageUrl.length<=0)return nil;
    imageUrl = [imageUrl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    if(!([imageUrl.lowercaseString hasPrefix:@"http://"] || [imageUrl.lowercaseString hasPrefix:@"https://"])) return nil;
    
//    if([UIImageView funj_isHasChinese:imageUrl.lastPathComponent]){
//        imageUrl=[imageUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    }
    if([imageUrl rangeOfString:@"|"].length>0){
        imageUrl =[imageUrl stringByReplacingOccurrencesOfString:@"|" withString:@"%7C"];
    }
    if([imageUrl rangeOfString:@" "].length>0){
        imageUrl =[imageUrl stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    }
    return imageUrl;
}

-(void)funj_setInternetImage:(NSString*)imageUrl ph:(NSString*)placeholderImage{
    [self funj_setInternetImageBlock:imageUrl ph:placeholderImage c:nil];
}
-(void)funj_setInternetImageBlock:(NSString*)imageUrl ph:(NSString*)placeholderImage  c:(SDExternalCompletionBlock)completedBlocks{
    imageUrl = [self funj_checkUrl:imageUrl];
    UIImage *defaultimage=nil;
    if(placeholderImage && placeholderImage.length>0){
        defaultimage=[UIImage imageNamed:placeholderImage];
    }else{
        defaultimage=[UIImage imageNamed:@"pic_default_logo"];
    }

    SDWebImageOptions option = SDWebImageRetryFailed | SDWebImageLowPriority;
//     self.sd_imageIndicator = SDWebImageActivityIndicator.grayLargeIndicator;
    [self sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:defaultimage options:option context:nil  progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if(completedBlocks && [imageUrl length]>0){
            completedBlocks(image,error,cacheType,imageURL);
        }
    }];
    
}

@end
