//
//  ActivityControllerDisappearAnimatedTransitioning.m
//  AutoInsurance
//
//  Created by 李思远 on 16/3/4.
//  Copyright © 2016年 Nanjing Renrenbao Network Technology Co.,Ltd. All rights reserved.
//

#import "PopoverControllerDisappearAnimatedTransitioning.h"

@implementation PopoverControllerDisappearAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    [UIView animateWithDuration:duration
                          delay:0.0
         usingSpringWithDamping:1
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         fromVC.view.alpha = 0;
                     } completion:^(BOOL finished) {
                         
                         if (finished)
                         {
                             [fromVC.view removeFromSuperview];
                             [transitionContext completeTransition:YES];
                         }
                     }];
}
@end
