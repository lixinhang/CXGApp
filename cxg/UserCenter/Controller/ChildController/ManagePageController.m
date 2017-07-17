//
//  ManagePageController.m
//  cxg
//
//  Created by abc on 16/9/8.
//  Copyright © 2016年 changyou. All rights reserved.
//

#import "ManagePageController.h"
#import "ChildTableCellView.h"

@interface ManagePageController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) UITextField *editLabel;
@property (nonatomic, weak) UITableView *tableView;
@end

@implementation ManagePageController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"usercenter_bg"]];
    imageView.frame = self.view.bounds;
    [self.view addSubview:imageView];
    self.navigationController.navigationBarHidden = NO;
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@" " style:1 target:nil action:nil];
    self.navigationItem.backBarButtonItem = backBtn;
}

- (void)viewDidDisappear:(BOOL)animated
{
    //if(curPageType != MANAGE){ curPageType = MANAGE; }
}

- (void)setupManagePageWithType:(UIViewPageType)type
{
    curPageType = type;
    switch (curPageType)
    {
        case MANAGE:
        {
            numberOfRowsInSection = 3;
            self.title = @"直播间管理";
            [self setupTableView];
            break;
        }
        case MANAGE_TITEL:
        {
            numberOfRowsInSection = 1;
            self.title = @"标题";
            [self setupEditLabelViewWithText:@"未设置"];
            [self setupTextFieldTipsWithNum:@"15"];
            [self setupSaveBtnView];
            break;
        }
        case MANAGE_NOTICE:
        {
            numberOfRowsInSection = 1;
            self.title = @"公告";
            [self setupEditLabelViewWithText:@"未设置"];
            [self setupTextFieldTipsWithNum:@"40"];
            [self setupSaveBtnView];
            break;
        }
        case MANAGECHILD:
        {
            numberOfRowsInSection = 1;
            self.title = @"管理列表";
            [self setupTableView];
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
    if(curPageType == MANAGECHILD)
        tableBGRect = CGRectMake(0, 1, SCREEN_W, GENERAL_TABLE_CELL_H * (numberOfRowsInSection + 1));
    else
        tableBGRect = CGRectMake(0, 1, SCREEN_W, GENERAL_TABLE_CELL_H * numberOfRowsInSection);
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:tableBGRect style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.scrollEnabled = NO;
    if(curPageType == MANAGECHILD)
    {
        tableView.allowsSelection = NO;
        tableView.editing = YES;
    }
    
    [tableView setSeparatorColor:FUIColorFromRGB(0x750eaf)];
    
    tableBG.frame = tableBGRect;
    tableView.frame = tableBGRect;
    _tableView = tableView;
    [self.view addSubview:tableBG];
    [self.view addSubview:tableView];
}

- (void)setupEditLabelViewWithText:(NSString *)text
{
    CGRect editLabel = CGRectMake(0, 0, SCREEN_W, GENERAL_TABLE_CELL_H);
    UITextField *editLabelView = [[UITextField alloc] init];
    editLabelView.background = [UIImage imageNamed:@"tablecell_bg"];
    editLabelView.text = text;
    editLabelView.font = [UIFont systemFontOfSize:16];
    editLabelView.textColor = [UIColor whiteColor];
    editLabelView.keyboardType = UIKeyboardTypeDefault;
    editLabelView.returnKeyType =UIReturnKeyDone;
    editLabelView.frame = editLabel;
    //editLabelView.delegate = self;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_W - 20, 0, 20, GENERAL_TABLE_CELL_H)];
    editLabelView.leftView = view;
    editLabelView.leftViewMode = UITextFieldViewModeAlways;
    
    _editLabel = editLabelView;
    [self.view addSubview:_editLabel];
    [_editLabel becomeFirstResponder];
}

- (void)setupSaveBtnView
{
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    saveBtn.backgroundColor = [UIColor clearColor];
    [saveBtn.layer setCornerRadius:7.0];
    [saveBtn.layer setBorderWidth:1.0];
    [saveBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
    [saveBtn setTitle:@"保 存" forState:UIControlStateNormal];
    [saveBtn setFrame:CGRectMake(SCREEN_W * 0.15, SCREEN_H * 0.65, SCREEN_W * 0.7, GENERAL_BTN_H)];
    [saveBtn addTarget:self action:@selector(clickSaveBtn) forControlEvents:UIControlEventTouchUpInside];

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

#pragma mark ---- 添加按钮响应事件
- (void)clickSaveBtn
{
    switch (curPageType)
    {
        case MANAGE_TITEL:
            break;
        case MANAGE_NOTICE:
            
            break;
        default:
            break;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ---- <textfield数据源方法>
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_editLabel resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_editLabel resignFirstResponder];
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
    if(curPageType == MANAGECHILD)
        return GENERAL_TABLE_CELL_H;
    else
        return 0.1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(curPageType == MANAGECHILD)
        return @"当前房管:(1/100)";
    else
        return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChildTableCellView *tableCell = nil;
    switch (curPageType)
    {
        case MANAGE:
        {
            if(indexPath.row == 0)
                tableCell = [[ChildTableCellView alloc] initWithTableTitel:@"标题" andDetail:@"未设置"];
            else if (indexPath.row == 1)
                tableCell = [[ChildTableCellView alloc] initWithTableTitel:@"公告" andDetail:@"未设置"];
            else
                tableCell = [[ChildTableCellView alloc] initWithTableTitel:@"房管" andDetail:@""];
            break;
        }
        case MANAGECHILD:
        {
            tableCell = [[ChildTableCellView alloc] initWithHeadIcon:@"head_icon" andText:@"冷@紫禁之巅"];
            break;
        }
        default:
            break;
    }
    return tableCell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (curPageType)
    {
        case MANAGE:
        {
            if(indexPath.row == 0)
            {
                ManagePageController *childView = [[ManagePageController alloc] init];
                [self.navigationController pushViewController:childView animated:YES];
                [childView setupManagePageWithType:MANAGE_TITEL];
            }
            else if(indexPath.row == 1)
            {
                ManagePageController *childView = [[ManagePageController alloc] init];
                [self.navigationController pushViewController:childView animated:YES];
                [childView setupManagePageWithType:MANAGE_NOTICE];
            }
            else
            {
                ManagePageController *childView = [[ManagePageController alloc] init];
                [self.navigationController pushViewController:childView animated:YES];
                [childView setupManagePageWithType:MANAGECHILD];
            }
            break;
        }
        case MANAGECHILD:
        {
            break;
        }
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO]; 
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"撤销房管";
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (curPageType != MANAGECHILD)
        return UITableViewCellEditingStyleNone;
    else
        return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        //[self.commonPlaceArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView reloadData];
    }
}

@end
