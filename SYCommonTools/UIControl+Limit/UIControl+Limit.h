//
//  UIControl+Limit.h
//  网络请求Demo
//
//  Created by 李思远 on 2019/1/25.
//  Copyright © 2019年 李思远. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIControl (Limit)

@property (nonatomic, assign) NSTimeInterval acceptEventInterval;
@property (nonatomic, assign) BOOL ignoreEvent;

@end

NS_ASSUME_NONNULL_END
