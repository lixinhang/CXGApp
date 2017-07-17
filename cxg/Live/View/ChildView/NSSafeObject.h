//
//  NSSafeObject.h
//  cxg
//
//  Created by abc on 16/9/29.
//  Copyright © 2016年 changyou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSSafeObject : NSObject

- (instancetype)initWithObject:(id)object;
- (instancetype)initWithObject:(id)object withSelector:(SEL)selector;
- (void)excute;

@end
