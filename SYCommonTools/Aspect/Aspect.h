//
//  Aspect.h
//  网络请求Demo
//
//  Created by 李思远 on 2019/1/25.
//  Copyright © 2019年 李思远. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Aspect : NSObject

void swizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector);

@end

NS_ASSUME_NONNULL_END
