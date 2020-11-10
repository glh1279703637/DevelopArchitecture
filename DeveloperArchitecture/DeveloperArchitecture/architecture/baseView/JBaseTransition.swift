//
//  JBaseTransition.swift
//  DeveloperArchitecture
//
//  Created by Jeffrey on 2020/11/5.
//  Copyright © 2020 Jeffery. All rights reserved.
//

import Foundation
import  UIKit
class JBaseTransition : JBaseView ,UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let containerView = transitionContext.containerView
        if toVC?.view == nil || fromVC?.view == nil { return }
        containerView.addSubview(toVC!.view)
        containerView.bringSubviewToFront(fromVC!.view)
        let duration = self.transitionDuration(using: nil)
        toVC?.view.alpha = 0
//        toVC?.view.transform = CGAffineTransform(scaleX: 0.1 ,y : 0.1)
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeLinear) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                fromVC?.view.alpha = 0
                fromVC?.view.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
                toVC?.view.alpha = 1
            }
//            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
//                let isAddX = arc4random() % 3
//                let isAddY = arc4random() % 2
//                fromVC?.view.transform = fromVC?.view.transform.translatedBy(x: (1 - isAddX) * KWidth , y: (1 - isAddY) * KHeight)
//                toVC?.view.transform = CGAffineTransform(scaleX: 1, y: 1)
//            }
        } completion: { (completion) in
            fromVC?.view.transform = CGAffineTransform(scaleX: 1, y: 1)
            transitionContext.completeTransition(true)
        }
    } 
}
