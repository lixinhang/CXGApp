//
//  GiftsComboView.m
//  cxg
//
//  Created by abc on 16/9/12.
//  Copyright © 2016年 changyou. All rights reserved.
//

#import "GiftsComboView.h"

@implementation GiftsComboView

-(void) setupGiftComboViewWithIcon:(UIImage *)icon andUser:(NSString *)user andGift:(NSString *)gift
{
    [self setupHeadViewWithImage:icon];
    [self setupUserNameViewWithName:user];
    [self setupGiftInfoViewWithGift:gift];
    
    //这里还要加载礼物图标
    //self.backgroundColor = [UIColor blueColor];
}



-(void) setupHeadViewWithImage:(UIImage *)icon
{
    CGRect iconRect = CGRectMake(5, 5, GENERAL_HEADICON_SIZE, GENERAL_HEADICON_SIZE);
    UIImageView *headIcon = [[UIImageView alloc] initWithImage:icon];
    headIcon.frame = iconRect;
    
    [self addSubview:headIcon];
}

-(void) setupUserNameViewWithName:(NSString *)username
{
    CGRect nameLabel = CGRectMake(GENERAL_HEADICON_SIZE + 10, 5, 100, 25);
    UILabel *name = [[UILabel alloc] initWithFrame:nameLabel];
    name.text = username;
    
    [self addSubview:name];
}

-(void) setupGiftInfoViewWithGift:(NSString *)giftName
{
    CGRect giftLabel = CGRectMake(GENERAL_HEADICON_SIZE + 10, 25, 150, 25);
    UILabel *gift = [[UILabel alloc] initWithFrame:giftLabel];
    NSString *text = @"送出一个:";
    text = [text stringByAppendingString:giftName];
    gift.text = text;
    gift.textColor = [UIColor grayColor];
    gift.font = [UIFont systemFontOfSize:13];
    
    [self addSubview:gift];
}

@end
