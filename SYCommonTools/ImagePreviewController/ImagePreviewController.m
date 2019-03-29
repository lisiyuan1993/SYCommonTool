//
//  ImagePreviewController.m
//  CBClient
//
//  Created by ji-chang-an on 15/6/19.
//  Copyright (c) 2015年 chebao. All rights reserved.
//

#import "ImagePreviewController.h"

#import "ImageIndexViewController.h"

#import "ImagePreviewControllerTransitioningDelegate.h"

#pragma mark - ImageAbstractPageController
@interface ImageAbstractPageController : UIPageViewController
@end
@implementation ImageAbstractPageController
- (BOOL)prefersStatusBarHidden {
    return YES;
}
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationFade;
}
@end

#pragma mark - ImagePreviewController
@interface ImagePreviewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, copy) NSArray<ImagePreviewObject *> *images;
@property (nonatomic, strong) ImagePreviewObject *currentImage;

@property (nonatomic, strong) UILabel * indexLabel;

@property (nonatomic, strong) ImagePreviewControllerTransitioningDelegate *imagePreviewControllerTransitioningDelegate;

@property (nonatomic, strong, readwrite) UIPageViewController *pageViewController;

@end

@implementation ImagePreviewController

- (void)dealloc {}

+ (ImagePreviewController *)controllerWithImage:(ImagePreviewObject *)image images:(NSArray<ImagePreviewObject *> *)images {
    UIPageViewController *pageVC = [[ImageAbstractPageController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:@{UIPageViewControllerOptionInterPageSpacingKey:@(20)}];
    
    ImagePreviewController *controller = [[ImagePreviewController alloc] initWithRootViewController:pageVC];
    pageVC.delegate = controller;
    pageVC.dataSource = controller;
    
    //初始
    ImageIndexViewController *indexVC = [[ImageIndexViewController alloc] initWithImage:image];
    indexVC.firstShowAnimated = YES;
    [pageVC setViewControllers:@[indexVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    
    controller.currentImage = image;
    controller.images = images;
    controller.pageViewController = pageVC;
    

    
    return controller;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        self.imagePreviewControllerTransitioningDelegate = [[ImagePreviewControllerTransitioningDelegate alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor blackColor];
    self.view.clipsToBounds = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //针对非vc控制状态栏显示与否
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self loadCloseButton];
    [self loadIndexLabel];
}

- (void)viewWillDisappear:(BOOL)animated {
    //针对非vc控制状态栏显示与否
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [super viewWillDisappear:animated];
}

- (void)loadCloseButton {
    UIButton  *closeBtn= [[UIButton alloc] initWithFrame:CGRectMake(10, 60, 40, 40)];
    closeBtn.backgroundColor = [UIColor clearColor];
    closeBtn.contentEdgeInsets = UIEdgeInsetsMake(-80, 0, 0, 0);
    [closeBtn setImage:[UIImage imageNamed:@"public_close_video.png"] forState:UIControlStateNormal];
    [self.view addSubview:closeBtn];
}

- (void)loadIndexLabel {
    if (self.indexLabel.superview != self.view) {
        [self.view addSubview:self.indexLabel];
    }
    self.indexLabel.text = [NSString stringWithFormat:@"%lu/%lu",(unsigned long)[self indexOfImagePreviewObject:self.currentImage] + 1,(unsigned long)self.images.count];
}

- (NSUInteger)indexOfImagePreviewObject:(ImagePreviewObject *)imagePreviewObject {
    for (NSUInteger i = 0; i < self.images.count; ++i) {
        ImagePreviewObject *one = self.images[i];
        if ([imagePreviewObject isEqualToImagePreviewObject:one]) {
            return i;
        }
    }
    return NSNotFound;
}

- (UILabel *)indexLabel{
    if (_indexLabel == nil) {
        _indexLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 80)/2, 20, 80, 40)];
        _indexLabel.textColor = [UIColor whiteColor];
        _indexLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _indexLabel;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    ImagePreviewObject *imagePreviewObject = ((ImageIndexViewController *)viewController).imagePreviewObject;
    
    NSUInteger index = [self indexOfImagePreviewObject:imagePreviewObject];
    if (index == 0) {
        return nil;
    }

    ImageIndexViewController *indexVCBefore = [[ImageIndexViewController alloc] initWithImage:self.images[index-1]];
    return indexVCBefore;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    ImagePreviewObject *imagePreviewObject = ((ImageIndexViewController *)viewController).imagePreviewObject;
    
    NSUInteger index = [self indexOfImagePreviewObject:imagePreviewObject];
    if (index+1 >= [self presentationCountForPageViewController:pageViewController]) {
        return nil;
    }
    
    ImageIndexViewController *indexVCAfter = [[ImageIndexViewController alloc] initWithImage:self.images[index+1]];
    return indexVCAfter;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (!completed) {
        return;
    }
    
    // Find index of current page
    ImageIndexViewController *currentViewController = (ImageIndexViewController *)[pageViewController.viewControllers lastObject];
    
    NSUInteger index = [self indexOfImagePreviewObject:currentViewController.imagePreviewObject];
    self.indexLabel.text = [NSString stringWithFormat:@"%lu/%lu",(unsigned long)index + 1,(unsigned long)self.images.count];
    
    self.currentImage = currentViewController.imagePreviewObject;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return self.images.count;
}

//暂时直接覆盖这个@property (nullable, nonatomic, weak) id <UIViewControllerTransitioningDelegate> transitioningDelegate NS_AVAILABLE_IOS(7_0);
- (id<UIViewControllerTransitioningDelegate>)transitioningDelegate {
    return self.imagePreviewControllerTransitioningDelegate;
}

- (UIModalPresentationStyle)modalPresentationStyle {
    return UIModalPresentationFullScreen;
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

@end


