//
//  PopDetailView.m
//  cxg
//
//  Created by abc on 16/9/18.
//  Copyright © 2016年 changyou. All rights reserved.
//

#import "PopDetailView.h"

#define POP_VIEW_W      SCREEN_W * 0.6
#define POP_VIEW_H      SCREEN_H * 0.4

@implementation PopDetailView

-(void) initWith
{
    self.backgroundColor = [UIColor whiteColor];
    self.frame = CGRectMake(SCREEN_W * 0.2, SCREEN_H * 0.2, POP_VIEW_W, POP_VIEW_H);
    //self.clipsToBounds = YES;
    
    [self setupButtons];
    [self setupUserInfo];
}


-(void) setupButtons
{
    CGRect manageBtnRect = CGRectMake(5, 5, 50, 30);
    UIButton *manageBtn = [[UIButton alloc] initWithFrame:manageBtnRect];
    [manageBtn addTarget:self action:@selector(clickManageBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [manageBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [manageBtn setTitle:@"管理" forState:UIControlStateNormal];
    [self addSubview: manageBtn];
    
    CGRect closeBtnRect = CGRectMake(POP_VIEW_H - 90, 5, 50, 15);
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:closeBtnRect];
    //[closeBtn setImage:[UIImage imageNamed:@"tab_user_select"] forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(clickCloseBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn];
}

-(void) setupUserInfo
{
    UIImageView *headIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tab_user_select"]];
    headIcon.frame = CGRectMake((POP_VIEW_W - 60) / 2, 50, 60, 60);
    [self addSubview:headIcon];
    
    UILabel *userName = [[UILabel alloc] initWithFrame:CGRectMake(0,120,POP_VIEW_W,30)];
    userName.font = [UIFont systemFontOfSize:15];
    userName.textColor = [UIColor grayColor];
    userName.text = @"冷雨@紫禁之巅 lv.9";
    userName.textAlignment = UITextAlignmentCenter;
    [self addSubview:userName];
    
    //UILabel userInfo = [[UILabel alloc] initWithFrame:CGRectMake(0, 120, POP_VIEW_W, 40)];
}

-(IBAction) clickManageBtn
{
    NSString *title = @"Alert Button Selected";
    NSString *message = @"I need your attention NOW!";
    NSString *okButtonTitle = @"OK";
    NSString *neverButtonTitle = @"Never";
    NSString *laterButtonTitle = @"Maybe Later";
    
    // 初始化
    UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    
    // 分别3个创建操作
    UIAlertAction *laterAction = [UIAlertAction actionWithTitle:laterButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // 普通按键
        //self.userOutput.text = @"Clicked 'Maybe Later'";
    }];
    UIAlertAction *neverAction = [UIAlertAction actionWithTitle:neverButtonTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        // 红色按键
        //self.userOutput.text = @"Clicked 'Never'";
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:okButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        // 取消按键
        //self.userOutput.text = @"Clicked 'OK'";
    }];
    
    // 添加操作（顺序就是呈现的上下顺序）
    [alertDialog addAction:laterAction];
    [alertDialog addAction:neverAction];
    [alertDialog addAction:okAction];
    
    // 呈现警告视图
    UIViewController *curController = [self getCurrentVC];
    [curController presentViewController:alertDialog animated:YES completion:nil];
    
}

-(IBAction) clickCloseBtn
{
    [self removeFromSuperview];
}

- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

@end
