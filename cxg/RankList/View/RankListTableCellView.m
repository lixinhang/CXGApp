//
//  RankListTableCellView.m
//  cxg
//
//  Created by abc on 16/8/28.
//  Copyright © 2016年 changyou. All rights reserved.
//

#import "RankListTableCellView.h"

static int levelLabelViewWidth  = 35;
static int levelLabelViewHeight = 20;

@implementation RankListTableCell
 
- (id)initWithName:(NSString *)name andRank:(NSString *)rank andLevel:(NSString *)level andHeadIcon:(UIImage *)icon
{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    if (self)
    {
        self.imageView.image = icon;
        self.textLabel.text = name;
        self.detailTextLabel.text = rank;
        
        //设置主播排名
        UITextView *rankText = [[UITextView alloc] init];
        rankText.text = rank;
        rankText.editable = NO;
        rankText.font = [UIFont systemFontOfSize:15];
        [rankText sizeToFit];
        //self.accessoryView = rankText;

        //设置主播等级
        _levelLabel = [[UILabel alloc]initWithFrame:CGRectMake(140, 16, levelLabelViewWidth, levelLabelViewHeight)];
        _levelLabel.text =level;
        [self addSubview:_levelLabel];
    }
    
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
