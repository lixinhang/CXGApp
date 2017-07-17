//
//  LoginView.m
//  cxg
//
//  Created by abc on 16/9/2.
//  Copyright © 2016年 changyou. All rights reserved.
//

#import "LoginViewController.h"
#import "TabBarController.h"
#import "LoginWarningLabelView.h"

@interface LoginViewController ()
@property (nonatomic,weak) UITextField *Account;
@property (nonatomic,weak) UITextField *Password;
@property (nonatomic, weak) LoginWarningLabelView *warningInfo;
@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.navigationController.navigationBarHidden = YES;
    //self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_bg"]];
    imageView.frame = self.view.bounds;
    [self.view addSubview:imageView];
    
    //隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:TRUE];
    self.navigationController.navigationBarHidden = YES;
    
    [self setupLogoImage];
    [self setupLoginView];
    [self addWarningLabelWithInfomation:@"登录提示"];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == _Account)
    {
        [_Password becomeFirstResponder];
        return NO;
    }else if(textField == _Password)
    {
        [_Password resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)setupLogoImage
{
    CGRect logoImage = CGRectMake(0, SCREEN_H * 0.1, SCREEN_W, SCREEN_H * 0.34);
    UIImageView *logoImageview = [[UIImageView alloc] initWithFrame:logoImage];
    logoImageview.image = [UIImage imageNamed:@"logo"];
    logoImageview.userInteractionEnabled = YES;
    
    [self.view addSubview:logoImageview];
}

- (void)setupLoginView
{
    _Account = [self addTextLabelWithDefaultWord:@" 请输入畅游通行证" andRightView:@"username"];
    _Account.frame = CGRectMake(SCREEN_W * 0.15, SCREEN_H * 0.55, SCREEN_W * 0.7, LOGIN_LABEL_H);
    _Account.keyboardType = UIKeyboardTypeEmailAddress;
    _Account.returnKeyType = UIReturnKeyNext;
    [self.view addSubview:_Account];
    
    _Password = [self addTextLabelWithDefaultWord:@" 请输入密码" andRightView:@"password"];
    _Password.frame = CGRectMake(SCREEN_W * 0.15, SCREEN_H * 0.55 + LOGIN_LABEL_H + 10, SCREEN_W * 0.7, LOGIN_LABEL_H);
    _Password.returnKeyType = UIReturnKeyDone;
    _Password.secureTextEntry = YES;
    _Password.clearsOnBeginEditing = YES;
    [self.view addSubview:_Password];
    
    [self addLoginBtn];
}

- (id)addLoginIconWithName:(NSString *)iconName
{
    UIImageView *icon = [[UIImageView alloc] init];
    icon.image = [UIImage imageNamed:iconName];
    
    return icon;
}

- (id)addTextLabelWithDefaultWord:(NSString *)defaultWord andRightView:(NSString *)imageName
{
    UITextField *textField = [[UITextField alloc] init];
    textField.borderStyle = UITextBorderStyleLine;
    textField.layer.cornerRadius = 7.0;
    textField.placeholder = defaultWord;
    [textField setValue:FUIColorFromRGB(0x86699a) forKeyPath:@"_placeholderLabel.textColor"];
    textField.font = [UIFont systemFontOfSize:15];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //textField.delegate = self;
    
    textField.background = [UIImage imageNamed:@"textfield"];
    
    if(imageName != nil)
    {
        UIImageView *rightImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        textField.leftView = rightImage;
        textField.leftViewMode = UITextFieldViewModeAlways;
    }
    
    return textField;
}

-(void)addWarningLabelWithInfomation:(NSString *)info
{
    LoginWarningLabelView *warningLabel = [[LoginWarningLabelView alloc] initWithWarningInfo:info];
    _warningInfo = warningLabel;
    
    //是否可见
    //[self.view addSubview:_warningInfo];
}

- (void)addLoginBtn
{
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    //[loginBtn setImage:[UIImage imageNamed:@"tab_user_select"] forState:UIControlStateNormal];
    //[loginBtn setImage:[UIImage imageNamed:@"tab_live_select"] forState:UIControlStateHighlighted];
    loginBtn.backgroundColor = [UIColor clearColor];
    [loginBtn.layer setCornerRadius:7.0];
    [loginBtn.layer setBorderWidth:1.0];
    [loginBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
    [loginBtn setTitle:@"登 录" forState:UIControlStateNormal];
    [loginBtn setFrame:CGRectMake(SCREEN_W * 0.15, SCREEN_H * 0.76, SCREEN_W * 0.7, GENERAL_BTN_H)];
    [loginBtn addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:loginBtn];
}

- (void)loginClick
{
    MainTabBarController *tabVc = [[MainTabBarController alloc] init];
    self.view.window.rootViewController = tabVc;
    //[self.navigationController pushViewController:tabVc animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
