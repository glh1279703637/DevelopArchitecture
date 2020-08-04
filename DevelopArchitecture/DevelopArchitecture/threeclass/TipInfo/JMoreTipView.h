//
//  JMoreTipView.h
//  DevelopArchitecture
//
//  Created by Jeffrey on 2019/12/2.
//  Copyright © 2019 Jeffrey. All rights reserved.
//

#import "JBaseView.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,TipPointPostion) {
    kshowLeftPostion,
    kshowTopPostion,
    kshowRightPostion,
    kshowBottomPostion
};

@interface JMoreTipView : JBaseView

+(void)funj_addMainBottomSwipeView:(UIView*)superView;

-(id)initWithTitle:(NSString*)title :(UIView*)superView;

-(void)funj_reloadType :(TipPointPostion)type :(CGPoint)tipPoint :(CGFloat)Offset;

-(void)funj_addAutoHiddenViews;
@end

NS_ASSUME_NONNULL_END
