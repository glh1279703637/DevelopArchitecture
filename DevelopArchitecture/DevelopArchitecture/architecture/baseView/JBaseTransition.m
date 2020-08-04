//
//  JBaseTransition.m
//  DevelopArchitecture
//
//  Created by Jeffrey on 2019/9/12.
//  Copyright © 2019 Jeffrey. All rights reserved.
//

#import "JBaseTransition.h"

@implementation JBaseTransition
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext;{
    return 0.5;
}
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *toVC = (UIViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = (UIViewController*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView * containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];
    
    [containerView bringSubviewToFront:fromVC.view];
    
    NSTimeInterval duration = [self transitionDuration:nil];
    
    LRWeakSelf(fromVC);LRWeakSelf(toVC);
    LRWeakSelf(transitionContext);
    toVC.view.alpha = 0;
//    toVC.view.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateKeyframesWithDuration:duration delay:0 options: UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1 animations:^{
            LRStrongSelf(fromVC);LRStrongSelf(toVC);
            fromVC.view.alpha = 0;
            fromVC.view.transform = CGAffineTransformMakeScale(0.4, 0.4);
            toVC.view.alpha = 1;
        }];
        [UIView addKeyframeWithRelativeStartTime: 0.5 relativeDuration:0.5 animations:^{
            LRStrongSelf(fromVC);LRStrongSelf(toVC);
//            NSInteger isAddx = arc4random() % 3 ;
//            NSInteger isAddy = arc4random() % 2 ;

//            fromVC.view.transform = CGAffineTransformTranslate(fromVC.view.transform, (1-isAddx)* KWidth, (1-isAddy)*KHeight);
//            toVC.view.transform = CGAffineTransformMakeScale(1, 1);
        }];
    } completion:^(BOOL finished) {
        LRStrongSelf(fromVC);LRStrongSelf(transitionContext);
        fromVC.view.transform = CGAffineTransformMakeScale(1, 1);
        [transitionContext completeTransition:YES];
    }];
}
//- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
//    UIViewController *toVC = (UIViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
//    UIViewController *fromVC = (UIViewController*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
//    UIView * containerView = [transitionContext containerView];
//    UIView * fromView = fromVC.view;
//    UIView * toView = toVC.view;
//    [containerView addSubview:toView];
//
//    [containerView bringSubviewToFront:fromView];
//
//    NSTimeInterval duration = [self transitionDuration:nil];
//    [UIView animateWithDuration:duration animations:^{
//        fromView.alpha = 0.0;
//        fromView.transform = CGAffineTransformMakeScale(0.2, 0.2);
//        toView.alpha = 1.0;
//    } completion:^(BOOL finished) {
//        fromView.transform = CGAffineTransformMakeScale(1, 1);
//        [transitionContext completeTransition:YES];
//    }];
//}

@end
