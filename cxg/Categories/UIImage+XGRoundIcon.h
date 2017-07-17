//
//  UIImage+XGRoundIcon.h
//  cxg
//
//  Created by abc on 16/10/14.
//  Copyright © 2016年 changyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (XGRoundIcon)
+ (instancetype)imageWithIconName:(NSString *)icon andSize:(int)imageSize;
+ (instancetype)imageWithIconName:(NSString *)icon border:(int)border borderColor:(UIColor *)color;
@end
