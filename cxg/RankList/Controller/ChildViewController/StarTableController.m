//
//  StarTableController.m
//  cxg
//
//  Created by abc on 16/9/28.
//  Copyright © 2016年 changyou. All rights reserved.
//

#import "StarTableController.h"

@interface StarTableController ()

@end

@implementation StarTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rank_star"]];
    imageView.frame = self.view.bounds;
    [self.view addSubview:imageView];
    
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"rich_nav"]forBarMetrics:UIBarMetricsDefault];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"rich_nav"]forBarMetrics:UIBarMetricsDefault];
}

@end
