//
//  HeadIconView.m
//  cxg
//
//  Created by abc on 16/8/31.
//  Copyright © 2016年 changyou. All rights reserved.
//

#import "HeadIconView.h"

@implementation HeadIconView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *result = [super hitTest:point withEvent:event];
    if (result == self) {
        return nil;
    } else {
        return result;
    }
}

@end
