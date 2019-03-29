//
//  ActivityVCDelegate.m
//  AutoInsurance
//
//  Created by 李思远 on 16/3/4.
//  Copyright © 2016年 Nanjing Renrenbao Network Technology Co.,Ltd. All rights reserved.
//

#import "PopoverViewControllerTransitioningDelegate.h"
#import "PopoverControllerAppearAnimatedTransitioning.h"
#import "PopoverControllerDisappearAnimatedTransitioning.h"


@interface PopoverViewControllerTransitioningDelegate ()
@property (nonatomic, strong) PopoverControllerAppearAnimatedTransitioning *appearAnimatedTransitioning;
@property (nonatomic, strong) PopoverControllerDisappearAnimatedTransitioning *disappearAnimatedTransitioning;
@end
@implementation PopoverViewControllerTransitioningDelegate

- (void)dealloc
{
    
}
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    if (!_appearAnimatedTransitioning)
    {
        _appearAnimatedTransitioning = [[PopoverControllerAppearAnimatedTransitioning alloc] init];
    }
    return _appearAnimatedTransitioning;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    if (!_disappearAnimatedTransitioning)
    {
        _disappearAnimatedTransitioning = [[PopoverControllerDisappearAnimatedTransitioning alloc] init];
    }
    return _disappearAnimatedTransitioning;
}

@end
