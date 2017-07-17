//
//  UserCenterTableCellView.m
//  cxg
//
//  Created by abc on 16/9/5.
//  Copyright © 2016年 changyou. All rights reserved.
//

#import "UserCenterTableCellView.h"

static NSString * cellIdentifier = @"settingCell";

@implementation UserCenterTableCellView

-(id) initWithTableTitel:(NSString *)titel andDetail:(NSString *)describe
{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    if(self)
    {
        self.textLabel.text = titel;
        self.detailTextLabel.text = describe;
        
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.font = [UIFont systemFontOfSize:16];
        
        self.detailTextLabel.textColor = FUIColorFromRGB(0xff00aa);
        self.detailTextLabel.font = [UIFont systemFontOfSize:15];
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        //self.backgroundColor = FUIColorFromRGB(0x2c2c2e);
        self.backgroundColor = [UIColor clearColor];
        //self.alpha = 0.2;
        //self.opaque = NO;
        
        //self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tablecell_bg"]];
    }
    
    return self;
}
@end
