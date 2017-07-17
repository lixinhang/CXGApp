//
//  LivingController.h
//  cxg
//
//  Created by abc on 16/8/26.
//  Copyright © 2016年 changyou. All rights reserved.
//

#import "ShowRoom.h"

static bool OptionBtnStatus = NO;
@interface CameraViewController : UIViewController

@property (nonatomic, strong) ChatInterface *chatManager;
@property (nonatomic, strong) ShowRoom *showroom;
@property CHATROOM_INFO roominfo;

- (void) SpeakSomething;

@end
