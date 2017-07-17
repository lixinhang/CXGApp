//
//  HeadView.m
//  cxg
//
//  Created by abc on 16/8/26.
//  Copyright © 2016年 changyou. All rights reserved.
//

#import "HeadView.h"

#define LABEL_FONT_SIZE     16
#define LEVEL_ICON_SIZE     20
#define EDIT_ICON_SIZE      20

@implementation UserHeadView

- (instancetype)SetupUserCenterHeadView
{
    //self.backgroundColor = [UIColor blueColor];
    
    [self addUserHeadIconWithImageName:nil];
    int labelWidth = [self addUserInfoWithUserName:@"未登录" andLevel:@"levelicon"];
    float posX = (SCREEN_W - labelWidth - LEVEL_ICON_SIZE * 2 - 10) / 2;
    _userName.frame = CGRectMake(posX, 170, labelWidth, EDIT_ICON_SIZE + 5);
    _userLevel.frame = CGRectMake(posX + labelWidth + 5, 170, LEVEL_ICON_SIZE, LEVEL_ICON_SIZE);
    _editBtn.frame = CGRectMake(posX + labelWidth + LEVEL_ICON_SIZE + 10, 170, EDIT_ICON_SIZE, EDIT_ICON_SIZE);
    
    [self addFansNumberLabelWithNum:0];
    _fansNum.frame = CGRectMake(0, 190, SCREEN_W, LABEL_FONT_SIZE * 2);
    
    return self;
}

-(void) addUserHeadIconWithImageName:(NSString *)imageName
{
    NSString *headIconName = @"headicon";

    if(imageName != nil) {
        headIconName = imageName;
    }
    
    UIButton *headIcon = [UIButton buttonWithType:UIButtonTypeCustom];
    [headIcon setImage:[UIImage imageNamed:headIconName] forState:UIControlStateNormal];
    [headIcon setImage:[UIImage imageNamed:headIconName] forState:UIControlStateHighlighted];
    [headIcon.layer setCornerRadius:100];
    
    [headIcon setFrame:CGRectMake((SCREEN_W - HEAD_ICON_SIZE) / 2, 80, HEAD_ICON_SIZE, HEAD_ICON_SIZE)];
    //[headIcon addTarget:self action:@selector(userIconClick) forControlEvents:UIControlEventTouchUpInside];
    [headIcon addTarget:self action:@selector(editClick) forControlEvents:UIControlEventTouchUpInside];
    _headIcon = headIcon;
    
    [self addSubview:_headIcon];
}

-(int) addUserInfoWithUserName:(NSString *)name andLevel:(NSString *)level
{
    UITextField *userName = [[UITextField alloc] init];
    userName.borderStyle = UITextBorderStyleNone;
    userName.text = name;
    userName.textColor = FUIColorFromRGB(0xff00aa);
    userName.font = [UIFont systemFontOfSize:LABEL_FONT_SIZE];
    userName.userInteractionEnabled = NO;
    //userName.delegate = self;
    _userName = userName;
    [self addSubview:_userName];
    
    UIImageView *levelIcon = [[UIImageView alloc] init];
    levelIcon.image = [UIImage imageNamed:level];
    _userLevel = levelIcon;
    [self addSubview:_userLevel];
    
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [editBtn setImage:[UIImage imageNamed:@"editbtn"] forState:UIControlStateNormal];
    //[editBtn setImage:[UIImage imageNamed:@"editbtn"] forState:UIControlStateHighlighted];
    [editBtn addTarget:self action:@selector(editClick) forControlEvents:UIControlEventTouchUpInside];
    _editBtn = editBtn;
    [self addSubview:_editBtn];
    
    int labelTotalWidth = [_userName.text length] * LABEL_FONT_SIZE;
    return labelTotalWidth;
}

-(void) addFansNumberLabelWithNum:(int)fansNum
{
    NSString *fans = [[NSString alloc] initWithFormat:@"%d",fansNum];
    UITextView *text = [[UITextView alloc] init];
    text.text = [@"粉丝: " stringByAppendingString:fans];
    text.textColor = [UIColor whiteColor];
    text.font = [UIFont systemFontOfSize:15];
    text.backgroundColor = [UIColor clearColor];
    text.textAlignment = NSTextAlignmentCenter;
    text.editable = NO;
    
    _fansNum = text;
    [self addSubview:_fansNum];
}

-(void) editClick
{
    _userName.userInteractionEnabled = YES;
    _userName.textColor = [UIColor blackColor];
    _userName.borderStyle = UITextBorderStyleRoundedRect;
    //使键盘获得第一焦点
}

@end
