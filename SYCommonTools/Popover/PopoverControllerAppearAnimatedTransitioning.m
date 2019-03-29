//
//  ActivityControllerAppearAnimatedTransitioning.m
//  AutoInsurance
//
//  Created by 李思远 on 16/3/4.
//  Copyright © 2016年 Nanjing Renrenbao Network Technology Co.,Ltd. All rights reserved.
//

#import "PopoverControllerAppearAnimatedTransitioning.h"

@implementation PopoverControllerAppearAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.25;
}
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    // 1. Get controllers from transition context
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    // 2. Set init frame for toVC
    
    //初始位置
    toVC.view.transform = CGAffineTransformMakeScale(1.1, 1.1);
    // 3. Add toVC's view to containerView
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];
    
    // 4. Do animate now
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration
                          delay:0.0
         usingSpringWithDamping:1
          initialSpringVelocity:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         toVC.view.transform = CGAffineTransformIdentity;
                     } completion:^(BOOL finished) {
                         if (finished)
                         {
                             [transitionContext completeTransition:YES];
                         }
                     }];

}
@end
