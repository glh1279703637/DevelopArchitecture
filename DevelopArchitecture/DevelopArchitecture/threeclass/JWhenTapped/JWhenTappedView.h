//
//  JWhenTappedView.h
//  DevelopArchitecture
//
//  Created by Jeffrey on 2020/1/16.
//  Copyright © 2020 Jeffrey. All rights reserved.
//

#import "JBaseView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^JWhenTappedViewBlock)(UIView *sender);

@interface UIView (JWhenTappedView) <UIGestureRecognizerDelegate>

- (void)funj_whenTapped:(JWhenTappedViewBlock)block;
- (void)funj_whenDoubleTapped:(JWhenTappedViewBlock)block;

- (void)funj_whenLongPressed:(JWhenTappedViewBlock)block;

- (void)funj_whenTouchedDown:(JWhenTappedViewBlock)block;
- (void)funj_whenTouchedUp:(JWhenTappedViewBlock)block;

@end

NS_ASSUME_NONNULL_END
