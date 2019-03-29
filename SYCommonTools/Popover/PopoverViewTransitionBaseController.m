//
//  PopoverViewTransitionBaseController.m
//  AutoInsurance
//
//  Created by 李思远 on 16/9/23.
//  Copyright © 2016年 Nanjing Renrenbao Network Technology Co.,Ltd. All rights reserved.
//

#import "PopoverViewTransitionBaseController.h"
#import "PopoverViewControllerTransitioningDelegate.h"

@interface PopoverViewTransitionBaseController ()

@property (nonatomic, strong) PopoverViewControllerTransitioningDelegate *popoverViewDelegate;

@end

@implementation PopoverViewTransitionBaseController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.popoverViewDelegate = [[PopoverViewControllerTransitioningDelegate alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
}

- (UIModalPresentationStyle)modalPresentationStyle {
    return UIModalPresentationCustom;
}

- (id<UIViewControllerTransitioningDelegate>)transitioningDelegate {
    return self.popoverViewDelegate;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
