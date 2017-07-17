//
//  LoginWarningLabelView.m
//  cxg
//
//  Created by abc on 16/9/28.
//  Copyright © 2016年 changyou. All rights reserved.
//

#import "LoginWarningLabelView.h"

@implementation LoginWarningLabelView

- (instancetype)initWithWarningInfo:(NSString *)info
{
    CGRect labelRect = CGRectMake(0, SCREEN_H * 0.7, SCREEN_W, LABEL_H);
    
    if(self = [super initWithFrame:labelRect])
    {
        self.textColor = [UIColor redColor];
        self.font = [UIFont systemFontOfSize:15];
        self.textAlignment = NSTextAlignmentCenter;
        self.backgroundColor = [UIColor clearColor];
        self.text = info;
    }
    
    return self;
}

@end
