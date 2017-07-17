//
//  DateOptionController.m
//  cxg
//
//  Created by abc on 16/8/28.
//  Copyright © 2016年 changyou. All rights reserved.
//

#import "DateOptionController.h"

@interface DateOptionViewController ()

@property (nonatomic, weak) UILabel *optionView1;

@end

@implementation DateOptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"global_bg"]];
    imageView.frame = self.view.bounds;
    [self setupDateOption];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupDateOption
{
    NSUInteger count = self.childViewControllers.count;
    CGFloat btnW = 80;
    CGFloat btnX = 40;
    CGFloat btnH = 40;
    for (int i = 0; i < count; i++)
    {
        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        titleButton.tag = i;
        
        UIViewController *vc = self.childViewControllers[i];
        [titleButton setTitle:vc.title forState:UIControlStateNormal];
        // 设置标题颜色
        [titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        // 设置标题字体
        titleButton.titleLabel.font = [UIFont systemFontOfSize:18];
        
        btnX = i * btnW;
        
        titleButton.frame = CGRectMake(btnX, 0, btnW, btnH);
        
        // 监听按钮点击
        //[titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [_optionView1 addSubview:titleButton];
    }
}

@end