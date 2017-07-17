//
//  RankListTableHeadView.m
//  cxg
//
//  Created by abc on 16/9/1.
//  Copyright © 2016年 changyou. All rights reserved.
//

#import "RankListTableHeadView.h"

#define TITEL_LABEL_WIDTH   40
#define INFO_LABEL_HEIGHT   30
#define HEAD_ICON_SIZE      80

#define TOP_CONSTRANINT     5
#define BETWEEN_CONSTRANINT 10
#define GENERAL_SIZE        20

#define LABEL_FONT_SIZE_1   15
#define LABEL_FONT_SIZE_2   12


@implementation RankListTableHeadView

- (id)initWithTableName:(NSString *)tableName
{
    self = [super init];
    
    if([tableName isEqualToString:@"财富榜"])
    {
        _listTitel = [self InitTitelLabelWithName:tableName];
        [self addSubview:_listTitel];
        
        _headIcon = [self InitHeadIconWithName:@"tab_user"];
        [self addSubview:_headIcon];
        _userInfo = [self InitUserInfoWithName:@"暂无数据" andLevel:@"Lv.0"];
        [self addSubview:_userInfo];
    }
    else
    {
        _listTitel = [self InitTitelLabelWithName:tableName];
        [self addSubview:_listTitel];
        [self initDataOptionBtnView];
        
        _headIcon = [self InitHeadIconWithName:@"tab_user"];
        [self addSubview:_headIcon];
        _userInfo = [self InitUserInfoWithName:@"暂无数据  " andLevel:@"Lv.0"];
        [self addSubview:_userInfo];
    }
    
    return self;
}

-(id) InitTitelLabelWithName:(NSString *)name
{
    UILabel *rankTitel = [[UILabel alloc] initWithFrame:CGRectMake(0, TOP_CONSTRANINT, TITEL_LABEL_WIDTH, GENERAL_SIZE)];
    rankTitel.text = name;
    rankTitel.font = [UIFont systemFontOfSize:LABEL_FONT_SIZE_2];
    rankTitel.backgroundColor = [UIColor blueColor];
    rankTitel.textColor = [UIColor whiteColor];
    
    return rankTitel;
}

-(void) initDataOptionBtnView
{
    _optionDay = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_W - ((GENERAL_SIZE + BETWEEN_CONSTRANINT) * 4), TOP_CONSTRANINT, GENERAL_SIZE, GENERAL_SIZE)];
    _optionWeek = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_W - ((GENERAL_SIZE + BETWEEN_CONSTRANINT) * 3), TOP_CONSTRANINT, GENERAL_SIZE, GENERAL_SIZE)];
    _optionMonth = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_W - ((GENERAL_SIZE + BETWEEN_CONSTRANINT) * 2), TOP_CONSTRANINT, GENERAL_SIZE, GENERAL_SIZE)];
    _optionTotal = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_W - (GENERAL_SIZE + BETWEEN_CONSTRANINT), TOP_CONSTRANINT, GENERAL_SIZE, GENERAL_SIZE)];
    
    _optionDay.backgroundColor = _optionWeek.backgroundColor = _optionMonth.backgroundColor = _optionTotal.backgroundColor = [UIColor blueColor];
    
    [_optionDay   setTitle:@"日" forState:UIControlStateNormal];
    [_optionWeek  setTitle:@"周" forState:UIControlStateNormal];
    [_optionMonth setTitle:@"月" forState:UIControlStateNormal];
    [_optionTotal setTitle:@"总" forState:UIControlStateNormal];
    
    [self addSubview:_optionDay];
    [self addSubview:_optionWeek];
    [self addSubview:_optionMonth];
    [self addSubview:_optionTotal];
}

-(id) InitHeadIconWithName:(NSString *)name
{
    UIImageView *icon = [[UIImageView alloc]init];
    icon.image = [UIImage imageNamed:name];
    icon.frame = CGRectMake((SCREEN_W - HEAD_ICON_SIZE) / 2, TOP_CONSTRANINT + GENERAL_SIZE + 10 , HEAD_ICON_SIZE, HEAD_ICON_SIZE);
    
    return icon;
}

-(id) InitUserInfoWithName:(NSString *)name andLevel:(NSString *)level
{
    UILabel *userInfo = [[UILabel alloc] init];
    NSString *info = [name stringByAppendingString:@"  "];
    info = [info stringByAppendingString:level];
    userInfo.text = info;
    userInfo.font = [UIFont systemFontOfSize:LABEL_FONT_SIZE_1];
    userInfo.textAlignment = UITextAlignmentCenter;
    
    int posY = HEAD_ICON_SIZE + GENERAL_SIZE + TOP_CONSTRANINT * 3;
    CGRect infoLabelPos = CGRectMake(0, posY, SCREEN_W, INFO_LABEL_HEIGHT);
    userInfo.frame = infoLabelPos;
    
    return userInfo;
}

@end
