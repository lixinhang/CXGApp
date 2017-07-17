//
//  RoomManagerTableCellView.m
//  cxg
//
//  Created by abc on 16/9/12.
//  Copyright © 2016年 changyou. All rights reserved.
//

#import "RoomManagerTableCellView.h"

static NSString * cellIdentifier = @"manageTableCell";
@implementation RoomManagerTableCellView

-(id) initWithHeadIcon:(UIImage *)icon andText:(NSString *)text
{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    if(self)
    {
        
        if(icon == nil)
        {
            self.detailTextLabel.text = @"左滑撤销房管";
            self.textLabel.text = [self setupTitelTextWithNum:text];
        }
        else
        {
            self.imageView.image = icon;
            self.textLabel.text = text;
        }
        
        self.textLabel.textColor = [UIColor blackColor];
        self.textLabel.font = [UIFont systemFontOfSize:15];
        
        self.detailTextLabel.textColor = [UIColor grayColor];
        self.detailTextLabel.font = [UIFont systemFontOfSize:13];
    }
    
    return self;
}

-(NSString *) setupTitelTextWithNum:(NSString *)personNum
{
    NSString *text = @"当前房管:(";
    text = [text stringByAppendingString:personNum];
    text = [text stringByAppendingString:@"/100)"];
    
    return text;
}

@end

