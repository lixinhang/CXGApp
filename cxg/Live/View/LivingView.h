//
//  LivingView.h
//  cxg
//
//  Created by abc on 16/8/26.
//  Copyright © 2016年 changyou. All rights reserved.
//


@interface StartLiveView : UIView
{
    bool m_bLiving;
    NSString* url;
}

-(void) StartLiveWith:(NSString*) url;
-(void) EndLive;

@end
