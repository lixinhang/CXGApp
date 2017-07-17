//
//  QueryPageController.m
//  cxg
//
//  Created by abc on 16/10/4.
//  Copyright © 2016年 changyou. All rights reserved.
//

#import "QueryPageController.h"
#import "EditableTableCellView.h"
#import "ChildTableCellView.h"

@interface QueryPageController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) UITableView *tableView;
@end

@implementation QueryPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"usercenter_bg"]];
    imageView.frame = self.view.bounds;
    [self.view addSubview:imageView];
    
    self.navigationController.navigationBarHidden = NO;
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@" " style:1 target:nil action:nil];
    self.navigationItem.backBarButtonItem = backBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupQueryPageWithType:(UIViewPageType)type
{
    curPageType = type;
    switch (type)
    {
        case QUERY_INCOME:
        {
            numberOfRowsInSection = 2;
            self.title = @"查询收益";
            [self setupQueryBtnView];
            break;
        }
        case QUERY_LIVING:
        {
            numberOfRowsInSection = 2;
            self.title = @"查询直播";
            [self setupQueryBtnView];
            break;
        }
        case INCOMELIST:
        {
            numberOfRowsInSection = 3;
            self.title = @"查询结果";
            break;
        }
        case INCOMEDETAIL:
        {
            numberOfRowsInSection = 1;
            self.title = @"收益明细";
            break;
        }
        case LIVINGLIST:
        {
            numberOfRowsInSection = 3;
            self.title = @"查询结果";
            break;
        }
        case LIVINGDETAIL:
        {
            numberOfRowsInSection = 1;
            self.title = @"直播明细";
            break;
        }
        default:
            break;
    }
    
    [self setupTableView];
}

- (void)setupTableView
{
    UIImageView *tableBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tablecell_bg"]];
    CGRect tableBGRect;
    if(curPageType == QUERY_INCOME || curPageType == QUERY_LIVING)
        tableBGRect = CGRectMake(0, 1, SCREEN_W, GENERAL_TABLE_CELL_H * numberOfRowsInSection);
    else
        tableBGRect = CGRectMake(0, 1, SCREEN_W, GENERAL_TABLE_CELL_H * (numberOfRowsInSection + 1));
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:tableBGRect style:UITableViewStyleGrouped];
    
    if(curPageType == LIVINGDETAIL || curPageType == INCOMEDETAIL)
        tableView.allowsSelection = NO;
    
    tableView.backgroundColor = [UIColor clearColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.scrollEnabled = NO;
    tableView.tableHeaderView.hidden = YES;
    [tableView setSeparatorColor:FUIColorFromRGB(0x750eaf)];
    _tableView = tableView;
    
    tableBG.frame = tableBGRect;
    _tableView.frame = tableBGRect;
    [self.view addSubview:tableBG];
    [self.view addSubview:_tableView];
}

- (void)setupQueryBtnView
{
    UIButton *queryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    queryBtn.backgroundColor = [UIColor clearColor];
    [queryBtn.layer setCornerRadius:8.0];
    [queryBtn.layer setBorderWidth:1.0];
    [queryBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
    [queryBtn setTitle:@"查 询" forState:UIControlStateNormal];
    [queryBtn setFrame:CGRectMake( SCREEN_W * 0.15, SCREEN_H * 0.65, SCREEN_W * 0.7, 42)];
    if(curPageType == QUERY_INCOME)
        [queryBtn addTarget:self action:@selector(queryIncomeClick) forControlEvents:UIControlEventTouchUpInside];
    else if(curPageType == QUERY_LIVING)
        [queryBtn addTarget:self action:@selector(queryLivingClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:queryBtn];
}

#pragma mark ---- <按钮点击事件>
- (void)queryIncomeClick
{
    QueryPageController *childView = [[QueryPageController alloc] init];
    [self.navigationController pushViewController:childView animated:YES];
    [childView setupQueryPageWithType:INCOMELIST];
}

- (void)queryLivingClick
{
    QueryPageController *childView = [[QueryPageController alloc] init];
    [self.navigationController pushViewController:childView animated:YES];
    [childView setupQueryPageWithType:LIVINGLIST];
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
    if(curPageType == QUERY_LIVING || curPageType == QUERY_INCOME)
        return 0.11;
    else
        return GENERAL_TABLE_CELL_H;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (curPageType)
    {
        case INCOMELIST:
        {
            return @"总共收入价值 12345 元宝的礼物";
            break;
        }
        case LIVINGLIST:
        {
            return @"共直播 3场次 共 4小时40分钟40秒";
            break;
        }
        case INCOMEDETAIL:
        {
            return @"2016-08-08";
            break;
        }
        case LIVINGDETAIL:
        {
            return @"2016-08-08";
            break;
        }
        default:
        {
            return @"";
            break;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditableTableCellView *tableCellA = nil;
    ChildTableCellView *tableCellB = nil;
    
    switch (curPageType)
    {
        case QUERY_INCOME:
        {
            if(indexPath.row == 0)
                tableCellA = [[EditableTableCellView alloc] initWithTableTitel:@"开始日期" andDetail:@"20160303"];
            else
                tableCellA = [[EditableTableCellView alloc] initWithTableTitel:@"结束日期" andDetail:@"20160303"];
            break;
        }
        case QUERY_LIVING:
        {
            if(indexPath.row == 0)
                tableCellA = [[EditableTableCellView alloc] initWithTableTitel:@"开始日期" andDetail:@"20160303"];
            else
                tableCellA = [[EditableTableCellView alloc] initWithTableTitel:@"结束日期" andDetail:@"20160303"];
            break;
        }
        case INCOMELIST:
        {
            tableCellB = [[ChildTableCellView alloc] initWithTableTitel:@"20160801" andDetail:@"+2000"];
            break;
        }
        case INCOMEDETAIL:
        {
            tableCellB = [[ChildTableCellView alloc] initWithTableTitel:@"啦啦啦@紫禁之巅" andDetail:@"2500"];
            tableCellB.accessoryType = UITableViewCellAccessoryNone;
            break;
        }
        case LIVINGLIST:
        {
            tableCellB = [[ChildTableCellView alloc] initWithTableTitel:@"20160801" andDetail:@"1场次 共10分钟"];
            break;
        }
        case LIVINGDETAIL:
        {
            tableCellB = [[ChildTableCellView alloc] initWithTableTitel:@"1234567" andDetail:@"10分钟"];
            tableCellB.accessoryType = UITableViewCellAccessoryNone;
            break;
        }
        default:
            break;
    }
    
    if(tableCellA != nil)
        return tableCellA;
    else if (tableCellB != nil)
        return tableCellB;
    return nil;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (curPageType)
    {
        case INCOMELIST:
        {
            QueryPageController *childView = [[QueryPageController alloc] init];
            [self.navigationController pushViewController:childView animated:YES];
            [childView setupQueryPageWithType:INCOMEDETAIL];
            break;
        }
        case INCOMEDETAIL:
        {
            QueryPageController *childView = [[QueryPageController alloc] init];
            [self.navigationController pushViewController:childView animated:YES];
            [childView setupQueryPageWithType:INCOMEDETAIL];
            break;
        }
        case LIVINGLIST:
        {
            QueryPageController *childView = [[QueryPageController alloc] init];
            [self.navigationController pushViewController:childView animated:YES];
            [childView setupQueryPageWithType:LIVINGDETAIL];
            break;
        }
        case LIVINGDETAIL:
        {
            QueryPageController *childView = [[QueryPageController alloc] init];
            [self.navigationController pushViewController:childView animated:YES];
            [childView setupQueryPageWithType:LIVINGDETAIL];
            break;
        }
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
