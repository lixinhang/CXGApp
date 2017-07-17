//
//  ChildTableCellView.m
//  cxg
//
//  Created by abc on 16/9/8.
//  Copyright © 2016年 changyou. All rights reserved.
//

#import "ChildTableCellView.h"
#import "UIImage+XGRoundIcon.h"

static NSString * cellIdentifier = @"childTableCell";
@implementation ChildTableCellView

-(id) initWithTableTitel:(NSString *)titel andDetail:(NSString *)value
{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    if(self)
    {
        self.textLabel.text = titel;
        self.detailTextLabel.text = value;
        
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.font = [UIFont systemFontOfSize:16];
        
        self.detailTextLabel.textColor = [UIColor grayColor];
        self.detailTextLabel.font = [UIFont systemFontOfSize:14];
        
        self.backgroundColor = [UIColor clearColor];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return self;
}

-(id) initWithHeadIcon:(NSString *)icon andText:(NSString *)text
{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    if(self)
    {
        
        UIImage *iconImage = [UIImage imageWithIconName:icon andSize:GENERAL_HEADICON_SIZE];
        self.imageView.image = iconImage;
        
        self.textLabel.text = text;
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.font = [UIFont systemFontOfSize:16];
        
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

@end
