//
//  SubPageController.h
//  cxg
//
//  Created by abc on 16/9/30.
//  Copyright © 2016年 changyou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, UIViewPageType)
{
    USERINFO,
    NICKNAME,
    
    QUERY_INCOME,
    INCOMELIST,
    INCOMEDETAIL,
    
    QUERY_LIVING,
    LIVINGLIST,
    LIVINGDETAIL,
    
    MANAGE,
    MANAGE_TITEL,
    MANAGE_NOTICE,
    MANAGECHILD,
    
    SETTING
};

static NSInteger numberOfRowsInSection = 0;
static UIViewPageType curPageType = 0;

@interface SubPageController : UIViewController
- (void)setupPageViewWithType:(UIViewPageType)type;
@end
