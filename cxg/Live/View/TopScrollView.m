//
//  TopScrollView.m
//  cxg
//
//  Created by abc on 16/9/12.
//  Copyright © 2016年 changyou. All rights reserved.
//

#import "TopScrollView.h"
#import "PopDetailView.h"

@implementation TopScrollView

-(void) initTopScorllLabelView
{
    
    [self setupAnchorViewWithIcon:[UIImage imageNamed:@"headicon"] andOnlineNum:@" 1"];
    
    CGRect scrollRect = CGRectMake(GENERAL_HEADICON_SIZE + 70, 0, SCREEN_W - GENERAL_HEADICON_SIZE - 20, 50);
    UIScrollView *topHead = [[UIScrollView alloc] initWithFrame:scrollRect];
    topHead.showsHorizontalScrollIndicator = NO;
    //topHead.backgroundColor = [UIColor darkGrayColor];
    
    //通过mode方法 请求回当前房间的人数和信息
    int totalNum = 50;
    topHead.contentSize = CGSizeMake((GENERAL_HEADICON_SIZE + 5) * totalNum, 50);
    
    for(int i = 0; i < totalNum; i++)
    {
        UIButton *headBtn = [[UIButton alloc] init];
        [headBtn setImage:[UIImage imageNamed:@"tab_live_select"] forState:UIControlStateNormal];
        //_scrollHead = [self setupScrollHeadButtonWithIcon:[UIImage imageNamed:@"tab_live_select"] andUserInfo:@"haha"];
        headBtn.frame = CGRectMake((GENERAL_HEADICON_SIZE + 5) * i, 5, GENERAL_HEADICON_SIZE, GENERAL_HEADICON_SIZE);
        [headBtn addTarget:self action:@selector(clickIcon) forControlEvents:UIControlEventTouchUpInside];
        
        [topHead addSubview:headBtn];
    }
    
    [self addSubview:topHead];
}

-(void) setupAnchorViewWithIcon:(UIImage *)icon andOnlineNum:(NSString *)num
{
    CGRect iconRect = CGRectMake(5, 5, GENERAL_HEADICON_SIZE, GENERAL_HEADICON_SIZE);
    UIImageView *AnchorIcon = [[UIImageView alloc] initWithFrame:iconRect];
    AnchorIcon.image = icon;
    
    [self addSubview:AnchorIcon];
    
    CGRect titelRect = CGRectMake( GENERAL_HEADICON_SIZE + 10, 5, 100, 20);
    UILabel *title = [[UILabel alloc] initWithFrame:titelRect];
    title.text = @"直播 Live";
    title.textColor = [UIColor blackColor];
    title.font = [UIFont systemFontOfSize:13];
    
    [self addSubview:title];
    
    CGRect onlineNumRect = CGRectMake(GENERAL_HEADICON_SIZE + 10, 25, 50, 20);
    UILabel *onlineNum = [[UILabel alloc] initWithFrame:onlineNumRect];
    //NSString *stringInt = [NSString stringWithFormat:@"%d",intString];
    onlineNum.text = num;
    onlineNum.textColor = [UIColor blackColor];
    onlineNum.font = [UIFont systemFontOfSize:13];
    
    [self addSubview:onlineNum];
}

-(id) setupScrollHeadButtonWithIcon:(UIImage *)icon andUserInfo:(NSString *)name
{
    //CGRect btnRect = CGRectMake(5, 5, SCROLL_HEAD_ICON_SIZE, SCROLL_HEAD_ICON_SIZE);
    UIButton *headBtn = [[UIButton alloc] init];
    [headBtn setImage:icon forState:UIControlStateNormal];
    [headBtn addTarget:self action:@selector(clickIcon) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:headBtn];
    
    return headBtn;
}

-(IBAction) clickIcon
{
    PopDetailView *view = [[PopDetailView alloc] init];
    [view initWith];
    
    [self.superview addSubview:view];
}

@end
