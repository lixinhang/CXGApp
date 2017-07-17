//
//  NavigationController.m
//  cxg
//
//  Created by abc on 16/8/26.
//  Copyright © 2016年 changyou. All rights reserved.
//

#import "NavigationController.h"

@interface MainNavigationController () <UIGestureRecognizerDelegate>
@end

@implementation MainNavigationController

//设置navigation背景
+ (void)initialize
{
    if (self == [MainNavigationController class]) {
        UINavigationBar *bar = [UINavigationBar appearanceWhenContainedIn:self, nil];
        [bar setBackgroundImage:[UIImage imageNamed:@"navigation_bg"] forBarMetrics:UIBarMetricsDefault];
    }
    
    [[UINavigationBar appearance] setTintColor:FUIColorFromRGB(0xff00aa)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //实现全屏滑动返回
    id target = self.interactivePopGestureRecognizer.delegate;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
#pragma clang diagnostic pop
    [self.view addGestureRecognizer:pan];
    
    // 取消边缘滑动手势
    //self.interactivePopGestureRecognizer.enabled = NO;
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],
    NSForegroundColorAttributeName:FUIColorFromRGB(0xff00aa)}];
    
    pan.delegate = self;
}

#pragma mark ---- <UIGestureRecognizerDelegate>
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 判断下当前是不是在根控制器
    return self.childViewControllers.count > 1;
}

#pragma mark ---- <非根控制器隐藏底部tabbar>
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0)
    {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end

