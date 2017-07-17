//
//  ListViewController.h
//  cxg
//
//  Created by abc on 16/8/28.
//  Copyright © 2016年 changyou. All rights reserved.
//

#define TABLE_TOTAL_HEIGHT  GENERAL_TABLE_CELL_H * 9

#import "RankListTableCellView.h"

@interface ListViewController : UITableView <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,copy) NSDictionary *listData;
-(id)initListWithData:(NSDictionary *)dataInfo;

@end
