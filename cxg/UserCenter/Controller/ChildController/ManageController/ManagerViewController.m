//
//  ManagerViewController.m
//  cxg
//
//  Created by abc on 16/10/14.
//  Copyright © 2016年 changyou. All rights reserved.
//

#import "ManagerViewController.h"

@interface ManagerViewController ()

@end

@implementation ManagerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setupTableView
{
    UIImageView *tableBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tablecell_bg"]];
    CGRect tableBGRect;
    tableBGRect = CGRectMake(0, 1, SCREEN_W, GENERAL_TABLE_CELL_H * 1);
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:tableBGRect style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.scrollEnabled = NO;
    [tableView setSeparatorColor:FUIColorFromRGB(0x750eaf)];
    
    tableBG.frame = tableBGRect;
    tableView.frame = tableBGRect;
    [self.view addSubview:tableBG];
    [self.view addSubview:tableView];
}

#pragma mark ---- <tableView数据源方法>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return GENERAL_TABLE_CELL_H;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return GENERAL_TABLE_CELL_H;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"当前房管:(1/100)";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChildTableCellView *tableCell = nil;

    tableCell = [[ChildTableCellView alloc] initWithHeadIcon:@"head_icon" andText:@"冷@紫禁之巅"];
    return tableCell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
