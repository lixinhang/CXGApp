//
//  GiftsComboView.h
//  cxg
//
//  Created by abc on 16/9/12.
//  Copyright © 2016年 changyou. All rights reserved.
//


#define COMBO_LABEL_W   200
#define CONME_LABEL_H   50

@interface GiftsComboView : UILabel

-(void) setupGiftComboViewWithIcon:(UIImage *)icon andUser:(NSString *)user andGift:(NSString *)gift;

@end
