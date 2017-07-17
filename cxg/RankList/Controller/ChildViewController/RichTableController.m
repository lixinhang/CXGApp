//
//  RichTableController.m
//  cxg
//
//  Created by abc on 16/9/28.
//  Copyright © 2016年 changyou. All rights reserved.
//

#import "RichTableController.h"

@interface RichTableController ()

@end

@implementation RichTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"usercenter_bg"]];
    imageView.frame = self.view.bounds;
    [self.view addSubview:imageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated
{
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation_bg"]forBarMetrics:UIBarMetricsDefault];
}

@end
