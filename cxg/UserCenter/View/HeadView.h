//
//  HeadView.h
//  cxg
//
//  Created by abc on 16/8/26.
//  Copyright © 2016年 changyou. All rights reserved.
//

#define HEAD_VIEW_HEIGHT    240
#define HEAD_ICON_SIZE      80

@interface UserHeadView : UIView

@property (nonatomic, weak) IBOutlet UIButton *headIcon;

@property (nonatomic, weak) UITextField *userName;
@property (nonatomic, weak) UIImageView *userLevel;
@property (nonatomic, weak) UIButton    *editBtn;
@property (nonatomic, weak) UITextView  *fansNum;

- (instancetype)SetupUserCenterHeadView;

@end

