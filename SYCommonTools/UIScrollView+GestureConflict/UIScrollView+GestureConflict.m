//
//  UIScrollView+GestureConflict.m
//  HospitalProject
//
//  Created by 李思远 on 2019/2/11.
//  Copyright © 2019年 zxj. All rights reserved.
//

#import "UIScrollView+GestureConflict.h"

@implementation UIScrollView (GestureConflict)

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer isKindOfClass:NSClassFromString(@"UIScreenEdgePanGestureRecognizer")]) {
        if (otherGestureRecognizer.state == UIGestureRecognizerStateBegan && self.contentOffset.x == 0) {
            return YES;
        }
    }
    return NO;
}

@end
