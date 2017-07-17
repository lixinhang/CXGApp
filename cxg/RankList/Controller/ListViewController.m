//
//  ListViewController.m
//  cxg
//
//  Created by abc on 16/8/28.
//  Copyright © 2016年 changyou. All rights reserved.
//

#import "ListViewController.h"
#import "RankListTableHeadView.h"

#define XJScreenW [UIScreen mainScreen].bounds.size.width
#define XJScreenH [UIScreen mainScreen].bounds.size.height

@implementation ListViewController
{
    NSArray *tableDataSArray;
}

-(id)initListWithData:(NSDictionary *)dataInfo
{
    tableDataSArray = @[@[@"暂无数据",@"No.2",@"lv.0"],
                        @[@"暂无数据",@"No.3",@"lv.0"],
                        @[@"暂无数据",@"No.4",@"lv.0"],
                        @[@"暂无数据",@"No.5",@"lv.0"],
                        @[@"暂无数据",@"No.6",@"lv.0"],
                        @[@"暂无数据",@"No.7",@"lv.0"],
                        @[@"暂无数据",@"No.8",@"lv.0"],
                        @[@"暂无数据",@"No.9",@"lv.0"],
                        @[@"暂无数据",@"No.10",@"lv.0"]];

    
    //self = [super initWithFrame:CGRectMake(0,130,[[UIScreen mainScreen]bounds].size.width,[[UIScreen mainScreen]bounds].size.height-180) style:UITableViewStylePlain];
    _listData = dataInfo;
    //self.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
    
    self.delegate = self;
    self.dataSource = self;
    
    self.allowsSelection = NO;
    self.scrollEnabled = NO;
    
    return self;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return GENERAL_TABLE_CELL_H;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //NSLog(@"%i",tableDataSArray.count);
    return tableDataSArray.count;
    //return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return section == 0? 3:1;
    //return ((NSArray *)[_dataArray objectAtIndex:section]).count;
    //return tableDataSArray.count;
    return 1;
}

-(NSString *) tabelVIew:(UITableView *)tableView titelForHeaderInSection:(NSUInteger)section
{
    return @"暂无数据";
}

/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    RankListTableHeadView *rankHeadView = [[RankListTableHeadView alloc] initWithFrame:CGRectMake(0, 0, XJScreenW, RankListHeadHeight)];
    rankHeadView.backgroundColor = [UIColor redColor];
    rankHeadView = [rankHeadView initWithDefaultData];
    
    return rankHeadView;
}
 */

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RankListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        cell = [[RankListTableCell alloc]
                //initWithName:[(NSArray *)[tableDataSArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]
                initWithName:[(NSArray *)[tableDataSArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]
                //initWithName:@"aaaa"
                andRank:[(NSArray *)[tableDataSArray objectAtIndex:indexPath.section] objectAtIndex:1]
                andLevel:[(NSArray *)[tableDataSArray objectAtIndex:indexPath.section] objectAtIndex:2]
                andHeadIcon:[UIImage imageNamed:@"tab_rank"]];
    }
    
    return cell;
}

@end
