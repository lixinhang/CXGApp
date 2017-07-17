//
//  RankListTableHeadView.h
//  cxg
//
//  Created by abc on 16/9/1.
//  Copyright © 2016年 changyou. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HEAD_LABEL_HEIGHT   150

@interface RankListTableHeadView : UILabel

@property (nonatomic,strong) UILabel *listTitel;
@property (nonatomic,strong) UIImageView *headIcon;
@property (nonatomic,strong) UITextView *userInfo;

@property (nonatomic,strong) UIButton *optionDay;
@property (nonatomic,strong) UIButton *optionWeek;
@property (nonatomic,strong) UIButton *optionMonth;
@property (nonatomic,strong) UIButton *optionTotal;

- (id)initWithTableName:(NSString *)tableName;

@end
