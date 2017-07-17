//
//  UIImage+XGRoundIcon.m
//  cxg
//
//  Created by abc on 16/10/14.
//  Copyright © 2016年 changyou. All rights reserved.
//

#import "UIImage+XGRoundIcon.h"

@implementation UIImage (XGRoundIcon)

+ (instancetype)imageWithIconName:(NSString *)icon andSize:(int)imageSize
{
    UIImage * image = [UIImage imageNamed:icon];
    CGSize size = CGSizeMake(image.size.width, image.size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(context, CGRectMake(0, 4, imageSize, imageSize));
    CGContextClip(context);

    [image drawInRect:CGRectMake(0, 4, imageSize, imageSize)];
    UIImage *iconImage = UIGraphicsGetImageFromCurrentImageContext();
    
    return iconImage;
}

+ (instancetype)imageWithIconName:(NSString *)icon border:(int)border borderColor:(UIColor *)color
{
    UIImage * image = [UIImage imageNamed:icon];
    CGSize size = CGSizeMake(image.size.width + border, image.size.height + border);

    UIGraphicsBeginImageContextWithOptions(size, NO, 0);

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(context, CGRectMake(0, 0, size.width, size.height));
    [color set ];
    CGContextFillPath(context);
 
    CGFloat iconX = border / 2;
    CGFloat iconY = border / 2;
    CGFloat iconW = size.width;
    CGFloat iconH = size.height;

    CGContextAddEllipseInRect(context, CGRectMake(iconX, iconY, iconW, iconH));
    CGContextClip(context);
    //绘制头像
    [image drawInRect:CGRectMake(iconX, iconY, iconW, iconH)];
    UIImage *iconImage = UIGraphicsGetImageFromCurrentImageContext();
    
    return iconImage;
}

@end
