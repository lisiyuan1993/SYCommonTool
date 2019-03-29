//
//  ImageIndexViewController.m
//  AutoInsurance
//
//  Created by ji-chang-an on 15/11/12.
//  Copyright © 2015年 Nanjing Renrenbao Network Technology Co.,Ltd. All rights reserved.
//

#import "ImageIndexViewController.h"

#import "ImagePreviewObject.h"

#import "UIImageView+WebCache.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "AppDelegate.h"
#import "Const.h"

#pragma mark - ImageIndexViewController
@interface ImageIndexViewController ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong, readwrite) ImagePreviewObject *imagePreviewObject;

@end

@implementation ImageIndexViewController

- (void)dealloc {}

- (instancetype)initWithImage:(ImagePreviewObject *)imagePreviewObject {
    self = [super init];
    if (self) {
        self.imagePreviewObject = imagePreviewObject;
    }
    return self;
}

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *delegete = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegete.isFromHomePage = YES;

    self.view.backgroundColor = [UIColor clearColor];
    
    UILongPressGestureRecognizer *tap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                   action:@selector(handleTap:)];
    //使用一根手指双击时，才触发点按手势识别器
    recognizer.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:recognizer];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.imageView];
//    [self loadCloseMethod];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self appearAnimated:self.isFirstShowAnimated];
    self.firstShowAnimated = NO;
}

//- (void)loadCloseMethod {
//    UIButton  *closeBtn= [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 40, 40)];
//    closeBtn.backgroundColor = [UIColor clearColor];
//    [closeBtn addTarget:self action:@selector(closePressed) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:closeBtn];
//}

- (void)appearAnimated:(BOOL)animated {
    __block CGRect frame = CGRectZero;
    __block BOOL hasAnimated = NO;
    if (animated) {
        frame = [self.imagePreviewObject.containerView.superview convertRect:self.imagePreviewObject.containerView.frame toView:self.imageView.superview];
        self.imageView.frame = frame;
    } else {
        hasAnimated = YES;
    }
    
    //缩略图
    if (self.imagePreviewObject.thumbnailImage) {
        self.imageView.image = self.imagePreviewObject.thumbnailImage;
        frame = [self calculateImageViewFrame];
        [self setImageViewFrame:frame animated:!hasAnimated];
        hasAnimated = YES;
    }
    
    //本地路径
    if (self.imagePreviewObject.originalImageFilePath) {
        self.imageView.image = [UIImage imageWithContentsOfFile:self.imagePreviewObject.originalImageFilePath];
        frame = [self calculateImageViewFrame];
        [self setImageViewFrame:frame animated:!hasAnimated];
        hasAnimated = YES;
    }
    
    __weak __typeof(self)weakSelf = self;
    //加载图片
    if (self.imagePreviewObject.originalImageServerURL) {
//        [self.imageView setShowActivityIndicatorView:YES];
//        [self.imageView setIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
        [self.imageView sd_setImageWithURL:self.imagePreviewObject.originalImageServerURL
                          placeholderImage:self.imageView.image options:SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
        } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            
            if (!error) {
                frame = [weakSelf calculateImageViewFrame];
                [weakSelf setImageViewFrame:frame animated:!hasAnimated];
                hasAnimated = YES;
            }
        }];
    }
}

- (void)setImageViewFrame:(CGRect)frame animated:(BOOL)animated {
    __weak __typeof(self)weakSelf = self;
    //执行动画
    if (animated) {
        NSTimeInterval duration = 0.25;
        [UIView animateWithDuration:duration
                              delay:0.0
             usingSpringWithDamping:1
              initialSpringVelocity:0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             weakSelf.imageView.frame = frame;
                         } completion:^(BOOL finished) {
                             if (finished) {
                                 weakSelf.scrollView.contentSize = frame.size;
                             }
                         }];
    } else {
        self.scrollView.contentSize = frame.size;
        self.imageView.frame = frame;
    }
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.autoresizingMask = UIViewAutoresizingNone;
    }
    return _imageView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.delegate = self;
        _scrollView.minimumZoomScale = 1;
        _scrollView.maximumZoomScale = 2;
        _scrollView.autoresizingMask = ~UIViewAutoresizingNone;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = NO;
        _scrollView.directionalLockEnabled = YES;
        _scrollView.contentSize = _scrollView.bounds.size;
    }
    return _scrollView;
}

- (CGRect)calculateImageViewFrame {
    UIImage *currentImage = self.imageView.image;
    CGRect imageFrame;
    if (currentImage.size.width > SQWidth || currentImage.size.height > SQHeight) {
        CGFloat imageRatio = currentImage.size.width/currentImage.size.height;
        CGFloat photoRatio = SQWidth/SQHeight;
        
        if (imageRatio > photoRatio) {
            imageFrame.size = CGSizeMake(SQWidth, SQWidth/currentImage.size.width*currentImage.size.height);
            imageFrame.origin.x = 0;
            imageFrame.origin.y = (SQHeight - imageFrame.size.height)/2.0;
        }
        else {
            imageFrame.size = CGSizeMake(SQHeight/currentImage.size.height*currentImage.size.width, SQHeight);
            imageFrame.origin.x = (SQWidth - imageFrame.size.width)/2.0;
            imageFrame.origin.y = 0;
        }
    }
    else {
        imageFrame.size = currentImage.size;
        imageFrame.origin.x = (SQWidth - currentImage.size.width)/2.0;
        imageFrame.origin.y = (SQHeight-currentImage.size.height)/2.0;
    }
   
    return imageFrame;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
//    if (scrollView.zoomScale >=1 || scrollView.zoomScale <= 2) {
//        CGFloat offsetX = (SQWidth > scrollView.contentSize.width)?(SQWidth - SQWidth)*0.5:0.0;
//        CGFloat offsetY = (SQHeight > scrollView.contentSize.height)?(SQHeight - scrollView.contentSize.height)*0.5:0.0;
//        _imageView.center = CGPointMake(scrollView.contentSize.width*0.5+offsetX, scrollView.contentSize.height*0.5+offsetY);
//    }
    // 延中心点缩放
    CGRect rect = _imageView.frame;
    rect.origin.x = 0;
    rect.origin.y = 0;
    if (rect.size.width < self.view.frame.size.width) {
        rect.origin.x = floorf((self.view.frame.size.width - rect.size.width) / 2.0);
    }
    if (rect.size.height < self.view.frame.size.height) {
        rect.origin.y = floorf((self.view.frame.size.height - rect.size.height) / 2.0);
    }
    _imageView.frame = rect;
    if (scrollView.zoomScale > 1) {
        scrollView.bounces = NO;
    } else {
        scrollView.bounces = YES;
    }
}

- (void)tap:(UILongPressGestureRecognizer *)tapGestureRecognizer {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * saveAction = [UIAlertAction actionWithTitle:@"保存图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library writeImageDataToSavedPhotosAlbum:[NSData dataWithContentsOfURL:self.imagePreviewObject.originalImageServerURL] metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
            NSString * message;
            if ([assetURL path].length > 0) {
                message = @"保存成功";
            }else{
                message = @"保存失败";
            }
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alertController animated:YES completion:nil];
            [UIView animateWithDuration:2.0 animations:^(){} completion:^(BOOL finished) {
                [alertController dismissViewControllerAnimated:YES completion:nil];
            }];
        }] ;
        
        
    }];
    [alertController addAction:saveAction];
    
    UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancleAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)closePressed {
    [self dismiss];
}

- (void)dismiss {
    UIView *superView = nil;
    superView = [UIApplication sharedApplication].keyWindow;
    
    //重建一个imageView，加到当前superView上，显示动画效果
    UIImageView *tempView = [[UIImageView alloc] initWithFrame:self.imageView.bounds];
    tempView.image = self.imageView.image;
    tempView.clipsToBounds = self.imageView.clipsToBounds;
    tempView.contentMode = self.imagePreviewObject.containerView.contentMode;
    tempView.backgroundColor = self.imageView.backgroundColor;
    
    [superView addSubview:tempView];
    
    CGRect startFrame = [self.imageView.superview convertRect:self.imageView.frame toView:tempView.superview];
    tempView.frame = startFrame;
    
    CGRect endFrame = [self.imagePreviewObject.containerView.superview convertRect:self.imagePreviewObject.containerView.frame toView:tempView.superview];
    if ([UIDevice currentDevice].systemVersion.floatValue < 9.0) {
        endFrame.origin.x *= 2;
        endFrame.origin.y *= 2;
        endFrame.size.width *= 2;
        endFrame.size.height *= 2;
    } else {
        endFrame.origin.y += 20;
    }
    
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    
    [UIView beginAnimations:@"Disappear" context:(__bridge void * _Nullable)(tempView)];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDelegate:self];
    tempView.frame = endFrame;
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    [UIView commitAnimations];
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    BOOL b = [finished boolValue];
    if ([animationID isEqualToString:@"Disappear"]) {
        if (b) {
            UIView *tempView = (__bridge UIView *)(context);
            [tempView removeFromSuperview];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)handleTap:(UITapGestureRecognizer *)recognizer{
    [self closePressed];
}

@end
