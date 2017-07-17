//
//  BarrageViewController.h
//  cxg
//
//  Created by abc on 16/9/28.
//  Copyright © 2016年 changyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BarrageViewController : UIViewController

@property(nonatomic, strong)IBOutlet UILabel *infoLabel;

- (void)barrageStart;
- (void)barrageStop;

- (NSMutableArray *) GetArray;

@end
