//
//  ImagePreviewObject.h
//  AutoInsurance
//
//  Created by ji-chang-an on 15/11/12.
//  Copyright © 2015年 Nanjing Renrenbao Network Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  图片预览对象
 */
@interface ImagePreviewObject : NSObject

/**
 *  ID
 */
@property (nonnull, nonatomic, copy) NSString *identifier;

/**********************以下3个属性至少设置一个**************************/
/**
 *  缩略图（快速预览图）
 */
@property (nullable, nonatomic, strong) UIImage *thumbnailImage;

/**
 *  原图链接（图片服务端链接）
 */
@property (nullable, nonatomic, copy) NSURL *originalImageServerURL;

/**
 *  原图链接（本地文件地址）
 */
@property (nullable, nonatomic, copy) NSString *originalImageFilePath;

/**
 *  thumbnailImage所在view
 */
@property (nullable, nonatomic, strong) UIView *containerView;

- (BOOL)isEqualToImagePreviewObject:(ImagePreviewObject *)aImagePreviewObject;

@end

NS_ASSUME_NONNULL_END
