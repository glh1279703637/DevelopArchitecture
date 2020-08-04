//
//  JWhenTappedView.m
//  DevelopArchitecture
//
//  Created by Jeffrey on 2020/1/16.
//  Copyright © 2020 Jeffrey. All rights reserved.
//

#import "JWhenTappedView.h"
#import <objc/runtime.h>

@interface UIView (JWhenTappedViewBlocks_Private)

- (void)funj_runBlockForKey:(void *)blockKey;
- (void)funj_setBlock:(JWhenTappedViewBlock)block forKey:(void *)blockKey;

- (UITapGestureRecognizer*)funj_addTapGestureRecognizerWithTaps:(NSUInteger) taps touches:(NSUInteger) touches selector:(SEL) selector;
- (void) funj_addRequirementToSingleTapsRecognizer:(UIGestureRecognizer*) recognizer;
- (void) funj_addRequiredToDoubleTapsRecognizer:(UIGestureRecognizer*) recognizer;

@end

@implementation UIView (JWhenTappedView)

static char kWhenTappedBlockKey;
static char kWhenDoubleTappedBlockKey;
static char kWhenLongPressedBlockKey;
static char kWhenTouchedDownBlockKey;
static char kWhenTouchedUpBlockKey;

#pragma mark -
#pragma mark Set blocks

- (void)funj_runBlockForKey:(void *)blockKey {
    JWhenTappedViewBlock block = objc_getAssociatedObject(self, blockKey);
    if (block) block(self);
}

- (void)funj_setBlock:(JWhenTappedViewBlock)block forKey:(void *)blockKey {
    self.userInteractionEnabled = YES;
    objc_setAssociatedObject(self, blockKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark -
#pragma mark When Tapped

- (void)funj_whenTapped:(JWhenTappedViewBlock)block {
    UITapGestureRecognizer* gesture = [self funj_addTapGestureRecognizerWithTaps:1 touches:1 selector:@selector(funj_viewWasTapped)];
    [self funj_addRequiredToDoubleTapsRecognizer:gesture];
    
    [self funj_setBlock:block forKey:&kWhenTappedBlockKey];
}

- (void)funj_whenDoubleTapped:(JWhenTappedViewBlock)block {
    UITapGestureRecognizer* gesture = [self funj_addTapGestureRecognizerWithTaps:2 touches:1 selector:@selector(funj_viewWasDoubleTapped)];
    [self funj_addRequirementToSingleTapsRecognizer:gesture];
    
    [self funj_setBlock:block forKey:&kWhenDoubleTappedBlockKey];
}

- (void)funj_whenLongPressed:(JWhenTappedViewBlock)block{
     UILongPressGestureRecognizer *longPress =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(funj_viewWasLongPressed)];
    [self addGestureRecognizer:longPress];
    
    [self funj_setBlock:block forKey:&kWhenLongPressedBlockKey];
}

- (void)funj_whenTouchedDown:(JWhenTappedViewBlock)block {
    [self funj_setBlock:block forKey:&kWhenTouchedDownBlockKey];
}

- (void)funj_whenTouchedUp:(JWhenTappedViewBlock)block {
    [self funj_setBlock:block forKey:&kWhenTouchedUpBlockKey];
}

#pragma mark -
#pragma mark Callbacks

- (void)funj_viewWasTapped {
    [self funj_runBlockForKey:&kWhenTappedBlockKey];
}

- (void)funj_viewWasDoubleTapped {
    [self funj_runBlockForKey:&kWhenDoubleTappedBlockKey];
}

- (void)funj_viewWasLongPressed {
    [self funj_runBlockForKey:&kWhenLongPressedBlockKey];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self funj_runBlockForKey:&kWhenTouchedDownBlockKey];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [self funj_runBlockForKey:&kWhenTouchedUpBlockKey];
}

#pragma mark -
#pragma mark Helpers

- (UITapGestureRecognizer*)funj_addTapGestureRecognizerWithTaps:(NSUInteger)taps touches:(NSUInteger)touches selector:(SEL)selector {
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:selector];
    tapGesture.delegate = self;
    tapGesture.numberOfTapsRequired = taps;
    tapGesture.numberOfTouchesRequired = touches;
    [self addGestureRecognizer:tapGesture];
    
    return tapGesture;
}

- (void) funj_addRequirementToSingleTapsRecognizer:(UIGestureRecognizer*) recognizer {
    for (UIGestureRecognizer* gesture in [self gestureRecognizers]) {
        if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
            UITapGestureRecognizer* tapGesture = (UITapGestureRecognizer*) gesture;
            if (tapGesture.numberOfTouchesRequired == 1 && tapGesture.numberOfTapsRequired == 1) {
                [tapGesture requireGestureRecognizerToFail:recognizer];
            }
        }
    }
}

- (void) funj_addRequiredToDoubleTapsRecognizer:(UIGestureRecognizer*) recognizer {
    for (UIGestureRecognizer* gesture in [self gestureRecognizers]) {
        if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
            UITapGestureRecognizer* tapGesture = (UITapGestureRecognizer*) gesture;
            if (tapGesture.numberOfTouchesRequired == 2 && tapGesture.numberOfTapsRequired == 1) {
                [recognizer requireGestureRecognizerToFail:tapGesture];
            }
        }
    }
}

@end
