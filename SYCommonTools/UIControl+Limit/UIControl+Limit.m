 //
//  UIControl+Limit.m
//  网络请求Demo
//
//  Created by 李思远 on 2019/1/25.
//  Copyright © 2019年 李思远. All rights reserved.
//

#import "UIControl+Limit.h"
#import <objc/runtime.h>
#import "Aspect.h"

static const char *UIControl_acceptEventInterval="UIControl_acceptEventInterval";
static const char *UIControl_ignoreEvent="UIControl_ignoreEvent";

@implementation UIControl (Limit)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzleMethod(self, @selector(sendAction:to:forEvent:), @selector(swizzled_sendAction:to:forEvent:));
    });
}

- (void)swizzled_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    if (self.ignoreEvent) {
        NSLog(@"btnAction is intercepted");
        return;
    }
    if (self.acceptEventInterval > 0) {
        self.ignoreEvent = YES;
        [self performSelector:@selector(setIgnoreWithNo) withObject:nil afterDelay:self.acceptEventInterval];
    }
    [self swizzled_sendAction:action to:target forEvent:event];
}

- (void)setIgnoreWithNo {
    self.ignoreEvent = NO;
}

#pragma mark - private

- (void)setAcceptEventInterval:(NSTimeInterval)acceptEventInterval {
    objc_setAssociatedObject(self, UIControl_acceptEventInterval, @(acceptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval)acceptEventInterval {
    return [objc_getAssociatedObject(self, UIControl_acceptEventInterval) doubleValue];
}

- (void)setIgnoreEvent:(BOOL)ignoreEvent {
    objc_setAssociatedObject(self, UIControl_ignoreEvent, @(ignoreEvent), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)ignoreEvent {
    return [objc_getAssociatedObject(self, UIControl_ignoreEvent) boolValue];
}

@end
