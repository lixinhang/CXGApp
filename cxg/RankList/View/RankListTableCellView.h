//
//  RankListTableCellView.h
//  cxg
//
//  Created by abc on 16/8/28.
//  Copyright © 2016年 changyou. All rights reserved.
//

static NSString * cellIdentifier = @"rankCell";
@interface RankListTableCell: UITableViewCell

@property (nonatomic,strong) UILabel *levelLabel;

- (id)initWithName:(NSString *)name andRank:(NSString *)rank andLevel:(NSString *)level andHeadIcon:(UIImage *)icon;

@end
