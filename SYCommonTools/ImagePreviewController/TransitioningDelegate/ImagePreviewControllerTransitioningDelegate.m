//
//  AlertControllerTransitioningDelegate.m
//  TAlert
//
//  Created by ji-chang-an on 16/1/7.
//  Copyright © 2016年 Nanjing Renrenbao Network Technology Co.,Ltd. All rights reserved.
//

#import "ImagePreviewControllerTransitioningDelegate.h"

#import "ImagePreviewControllerAppearAnimatedTransitioning.h"
#import "ImagePreviewControllerDisappearAnimatedTransitioning.h"

@interface ImagePreviewControllerTransitioningDelegate ()
@property (nonatomic, strong) ImagePreviewControllerAppearAnimatedTransitioning *appearAnimatedTransitioning;
@property (nonatomic, strong) ImagePreviewControllerDisappearAnimatedTransitioning *disappearAnimatedTransitioning;
@end

@implementation ImagePreviewControllerTransitioningDelegate

- (void)dealloc {}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    if (!_appearAnimatedTransitioning) {
        _appearAnimatedTransitioning = [[ImagePreviewControllerAppearAnimatedTransitioning alloc] init];
    }
    return _appearAnimatedTransitioning;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    if (!_disappearAnimatedTransitioning) {
        _disappearAnimatedTransitioning = [[ImagePreviewControllerDisappearAnimatedTransitioning alloc] init];
    }
    return _disappearAnimatedTransitioning;
}

@end
