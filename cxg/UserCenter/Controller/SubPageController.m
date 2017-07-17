//
//  SubPageController.m
//  cxg
//
//  Created by abc on 16/9/30.
//  Copyright © 2016年 changyou. All rights reserved.
//

#import "SubPageController.h"
#import "LoginViewController.h"
#import "ChildTableCellView.h"
#import "UIImage+XGRoundIcon.h"

@interface SubPageController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UITextField *nickName;

@end

@implementation SubPageController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"usercenter_bg"]];
    imageView.frame = self.view.bounds;
    [self.view addSubview:imageView];
    //[self setupPageViewWithType:UVPTinfo];
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:1 target:nil action:nil];
    self.navigationItem.backBarButtonItem = backBtn;
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupPageViewWithType:(UIViewPageType)type
{
    curPageType = type;
    switch (type) {
        case USERINFO:
        {
            self.title = @"编辑资料";
            numberOfRowsInSection = 2;
            [self setupTableView];
            break;
        }
        case NICKNAME:
        {
            self.title = @"修改昵称";
            [self setupTextFieldViewWithName:@"未知"];
            [self setupSaveBtnView];
            [self setupTextFieldTipsWithNum:@"6"];
            break;
        }
        case SETTING:
        {
            self.title = @"设置";
            numberOfRowsInSection = 1;
            [self setupTableView];
            [self setupLogoutBtnandVersionNum:nil];
            break;
        }
        default:
            break;
    }
}

- (void)setupTableView
{
    UIImageView *tableBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tablecell_bg"]];
    
    CGRect tableBGRect;
    tableBGRect = CGRectMake(0, 1, SCREEN_W, GENERAL_TABLE_CELL_H * numberOfRowsInSection);
    UITableView *tableView = [[UITableView alloc] initWithFrame:tableBGRect style:UITableViewStyleGrouped];
    
    tableView.backgroundColor = [UIColor clearColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.scrollEnabled = NO;
    //tableView.tableHeaderView.hidden = YES;
    [tableView setSeparatorColor:FUIColorFromRGB(0x750eaf)];
    _tableView = tableView;
    
    tableBG.frame = tableBGRect;
    _tableView.frame = tableBGRect;
    [self.view addSubview:tableBG];
    [self.view addSubview:_tableView];
}

- (void)setupTextFieldViewWithName:(NSString *)name
{
    CGRect nickName = CGRectMake(0, 0, SCREEN_W, GENERAL_TABLE_CELL_H);
    UITextField *nickNameView = [[UITextField alloc] init];
    nickNameView.background = [UIImage imageNamed:@"tablecell_bg"];
    nickNameView.text = name;
    nickNameView.font = [UIFont systemFontOfSize:16];
    nickNameView.textColor = [UIColor whiteColor];
    nickNameView.textAlignment = UITextAlignmentRight;
    nickNameView.keyboardType = UIKeyboardTypeDefault;
    nickNameView.returnKeyType =UIReturnKeyDone;
    nickNameView.frame = nickName;
    nickNameView.delegate = self;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_W - 20, 0, 20, GENERAL_TABLE_CELL_H)];
    nickNameView.rightView = view;
    nickNameView.rightViewMode = UITextFieldViewModeAlways;
    
    _nickName = nickNameView;
    [self.view addSubview:_nickName];
    [_nickName becomeFirstResponder];
}

- (void)setupLogoutBtnandVersionNum:(NSString *)version
{
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    loginBtn.backgroundColor = [UIColor clearColor];
    [loginBtn.layer setCornerRadius:8.0];
    [loginBtn.layer setBorderWidth:1.0];
    [loginBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
    [loginBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [loginBtn setFrame:CGRectMake(SCREEN_W * 0.15, SCREEN_H * 0.65, SCREEN_W * 0.7, GENERAL_BTN_H)];
    [loginBtn addTarget:self action:@selector(clickLogoutBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:loginBtn];
    
    UILabel *versionLabel = [[UILabel alloc]init];
    versionLabel.text = @"Version 1.1.0";
    versionLabel.font = [UIFont systemFontOfSize:14];
    versionLabel.textColor = FUIColorFromRGB(0x86699a);
    versionLabel.textAlignment = UITextAlignmentCenter;
    versionLabel.frame = CGRectMake(0, SCREEN_H * 0.715, SCREEN_W, 30);
    [self.view addSubview:versionLabel];
}

- (void)setupSaveBtnView
{
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    //[loginBtn setImage:[UIImage imageNamed:@"tab_user_select"] forState:UIControlStateNormal];
    //[loginBtn setImage:[UIImage imageNamed:@"tab_live_select"] forState:UIControlStateHighlighted];
    saveBtn.backgroundColor = [UIColor clearColor];
    [saveBtn.layer setCornerRadius:7.0];
    [saveBtn.layer setBorderWidth:1.0];
    [saveBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
    [saveBtn setTitle:@"保 存" forState:UIControlStateNormal];
    [saveBtn setFrame:CGRectMake(SCREEN_W * 0.15, SCREEN_H * 0.65, SCREEN_W * 0.7, GENERAL_BTN_H)];
    [saveBtn addTarget:self action:@selector(clickSaveNickName) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:saveBtn];
}

- (void)setupTextFieldTipsWithNum:(NSString *)num
{
    CGRect tipsRect = CGRectMake(0, GENERAL_TABLE_CELL_H, SCREEN_W - 10, 30);
    UILabel *tips = [[UILabel alloc] initWithFrame:tipsRect];
    NSString *text = @"您最多还能输入 ";
    text = [text stringByAppendingString:num];
    text = [text stringByAppendingString:@" 个字"];
    tips.backgroundColor = [UIColor clearColor];
    tips.text = text;
    tips.textColor = [UIColor grayColor];
    tips.font = [UIFont systemFontOfSize:13];
    tips.textAlignment = UITextAlignmentRight;
    
    [self.view addSubview:tips];
}

#pragma mark ---- <Btn响应事件>
- (void)clickEditHeadBtn
{
    NSString *cancelBtnTitle = @"取消";
    NSString *photoBtnTitle = @"从手机相册选择";
    NSString *cameraBtnTitle = @"拍照";
    
    // 初始化
    UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    // 分别3个创建操作
    UIAlertAction *laterAction = [UIAlertAction actionWithTitle:photoBtnTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // 普通按键
        //self.userOutput.text = @"Clicked 'Maybe Later'";
    }];
    
    // 设置按钮的title颜色
    UIAlertAction *neverAction = [UIAlertAction actionWithTitle:cameraBtnTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // 红色按键
        //self.userOutput.text = @"Clicked 'Never'";
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelBtnTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        // 取消按键
        //self.userOutput.text = @"Clicked 'OK'";
    }];
    // 添加操作（顺序就是呈现的上下顺序）
    [alertDialog addAction:laterAction];
    [alertDialog addAction:neverAction];
    [alertDialog addAction:cancelAction];
    
    // 呈现警告视图
    [self presentViewController:alertDialog animated:YES completion:nil];
}

- (void)clickSaveNickName
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickLogoutBtn
{
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    self.view.window.rootViewController = nav;
}

#pragma mark ---- <textfield数据源方法>
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_nickName resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_nickName resignFirstResponder];
    return NO;
}

#pragma mark ---- <tableView数据源方法>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return numberOfRowsInSection;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return GENERAL_TABLE_CELL_H;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChildTableCellView *tableCell = nil;
    switch (curPageType)
    {
        case USERINFO:
        {
            if(!indexPath.row)
            {
                tableCell = [[ChildTableCellView alloc] initWithTableTitel:@"头像" andDetail:@" "];
                tableCell.accessoryType = UITableViewCellAccessoryNone;
                
                UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headicon"]];
                icon.frame = CGRectMake(SCREEN_W - 55, 6, GENERAL_HEADICON_SIZE, GENERAL_HEADICON_SIZE);
                [tableCell addSubview:icon];
                break;
            }
            else
            {
                tableCell = [[ChildTableCellView alloc] initWithTableTitel:@"昵称" andDetail:@"未知"];
                break;
            }
            break;
        }
        case SETTING:
        {
            tableCell = [[ChildTableCellView alloc] initWithTableTitel:@"清理缓存" andDetail:@"0 M"];
            tableCell.accessoryType = UITableViewCellAccessoryNone;
        }
        default:
            break;
    }
    
    return tableCell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(curPageType == NICKNAME){ curPageType = USERINFO; }
    switch (curPageType)
    {
        case USERINFO:
        {
            if(!indexPath.row)
            {
                [self clickEditHeadBtn];
                break;
            }
            else
            {
                SubPageController *childView = [[SubPageController alloc] init];
                [self.navigationController pushViewController:childView animated:YES];
                [childView setupPageViewWithType:NICKNAME];
                break;
            }
            break;
        }
        case SETTING:
        {
            //清除缓存
            break;
        }
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


@end
