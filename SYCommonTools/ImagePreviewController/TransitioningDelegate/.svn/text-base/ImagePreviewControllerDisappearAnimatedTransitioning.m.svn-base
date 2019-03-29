//
//  AlertControllerAnimatedTransitioning.m
//  TAlert
//
//  Created by ji-chang-an on 16/1/7.
//  Copyright © 2016年 Nanjing Renrenbao Network Technology Co.,Ltd. All rights reserved.
//

#import "ImagePreviewControllerDisappearAnimatedTransitioning.h"

@implementation ImagePreviewControllerDisappearAnimatedTransitioning

// This is used for percent driven interactive transitions, as well as for container controllers that have companion animations that might need to
// synchronize with the main animation.
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.0;
}

// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *view = fromVC.view;
    [view removeFromSuperview];
    [transitionContext completeTransition:YES];
}

@end
