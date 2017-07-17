//
//  LivingController.m
//  cxg
//
//  Created by abc on 16/8/26.
//  Copyright © 2016年 changyou. All rights reserved.
//

#import "LivingController.h"
#import "LivingView.h"
#import "GiftsComboView.h"
#import "ChatingFrameView.h"
#import "TopScrollView.h"
#import "LivingOptionView.h"


#import "PresentView.h"
#import "GiftModel.h"
#import "AnimOperation.h"
#import "AnimOperationManager.h"
#import "GSPChatMessage.h"
#import "BarrageViewController.h"

//#import "GPUImageGaussianBlurFilter.h"


#define BOTTOM_BUTTON_SIZE      40

@interface CameraViewController () <OnChatDelegate>
{
    NSMutableArray * _msgarray;
    int ncount;
}

@property (weak, nonatomic) IBOutlet UIImageView *backgroundView;
@property (weak, nonatomic) IBOutlet UITextField *chatField;
@property (nonatomic, weak) UILabel *chatTextLabel;
@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (nonatomic, weak) LivingOptionView *optionView;
@property (nonatomic, weak) AnimOperationManager *animManager;
@property (nonatomic, weak) BarrageViewController *barrage;
//@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addViedoViewWith:@"rtmp://push.wscdn.cxg.changyou.com/show/123456789"];
    [self SetupButtons];
    [self setupBoradCastLabel];
    [self setupTopScorllZone];
    //[self setupGiftsComboLable];
    //[self setupEnterRoomInfoLabel];
    
    _msgarray = NULL;
    
    //隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:TRUE];
    self.navigationController.navigationBarHidden = NO;
    self.view.userInteractionEnabled = YES;
    
    BarrageViewController *barrage = [[BarrageViewController alloc] init];
    _barrage = barrage;
    [self addChildViewController:_barrage];
    [self.view addSubview:_barrage.view];
    
   
    
    //发起客户端拉流
    LiveRoom *liveroom = [[LiveRoom alloc] init];
    [liveroom Init];
    _roominfo = [liveroom GetChatRoomInfo];
 
     /*
    //发起主播端推流
    ShowRoom *showroom = [[ShowRoom alloc] init];
    _showroom = showroom;
    [_showroom Init];
    _roominfo = [_showroom getShowRoomInfo];
    
    NSString *pushurl = [_showroom getRtmp];
    [self addViedoViewWith:pushurl];
    [_showroom StartPushStream];
       */

    NSLog(@"start call tcp requet...");
    ChatInterface *chatroom = [[ChatInterface alloc] init];
    _chatManager = chatroom;
    //[_chatManager setRoomInfoWith:_roominfo];
    [_chatManager setReceiverObject:self];
    //[_chatManager enterRoom];
    //[_chatManager setReceiverObject:self];
    NSLog(@"tcp requet endl,enter chatroom.");
    //[self SpeakSomething];
    
    
    
}

#pragma mark ---- <加载视频采集界面>
- (void)addViedoViewWith:(NSString*) url
{
    //UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"live_bg"]];
    //imageView.frame = self.view.bounds;
    //[self.view addSubview:imageView];
    
    StartLiveView *view = [[StartLiveView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:view];
    [view StartLiveWith:url];
}

- (void)SetupButtons
{
    CGRect chat = CGRectMake(5, SCREEN_H - BOTTOM_BUTTON_SIZE - 5, BOTTOM_BUTTON_SIZE, BOTTOM_BUTTON_SIZE);
    UIButton *chatBtn = [[UIButton alloc] initWithFrame:chat];
    [chatBtn setImage:[UIImage imageNamed:@"tab_live_select"] forState:UIControlStateNormal];
    //[chatBtn addTarget:self action:@selector(clickChatBtn) forControlEvents:UIControlEventTouchUpInside];
    [chatBtn addTarget:self action:@selector(clickManageBtn) forControlEvents:UIControlEventTouchUpInside];
    
    
    CGRect option = CGRectMake((SCREEN_W - BOTTOM_BUTTON_SIZE * 2 - 10), SCREEN_H - BOTTOM_BUTTON_SIZE - 5, BOTTOM_BUTTON_SIZE, BOTTOM_BUTTON_SIZE);
    UIButton *optionBtn = [[UIButton alloc] initWithFrame:option];
    [optionBtn setImage:[UIImage imageNamed:@"tab_live_select"] forState:UIControlStateNormal];
    [optionBtn addTarget:self action:@selector(clickOptionBtn) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect back = CGRectMake((SCREEN_W - BOTTOM_BUTTON_SIZE - 5), SCREEN_H - BOTTOM_BUTTON_SIZE - 5, BOTTOM_BUTTON_SIZE, BOTTOM_BUTTON_SIZE);
    UIButton *backBtn = [[UIButton alloc] initWithFrame:back];
    [backBtn setImage:[UIImage imageNamed:@"tab_live_select"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:chatBtn];
    [self.view addSubview:optionBtn];
    [self.view addSubview:backBtn];
}

-(void) setupChatZone
{
    
}

-(void) setupBoradCastLabel
{
    /*
    CGRect viewFrame = CGRectMake(0, SCREEN_H * 0.6, SCREEN_W * 0.6, 30);
    BoradcastView *boradcastLabel = [[BoradcastView alloc] initWithFrame:viewFrame];
    [boradcastLabel setupWithUser:@"无极@紫禁之巅" andContent:@"哦呵呵呵呵呵~"];
    [self.view addSubview:boradcastLabel];
    */
}

-(void) setupGiftsComboLable
{
    CGRect comboRect = CGRectMake(0, SCREEN_H * 0.4, SCREEN_W * 0.5, 150);
    GiftsComboView *comboLabel = [[GiftsComboView alloc] initWithFrame:comboRect];
    [comboLabel setupGiftComboViewWithIcon:[UIImage imageNamed:@"tab_rank"] andUser:@"某某@天下" andGift:@"么么哒"];
    //comboLabel.backgroundColor = [UIColor grayColor];
    
    [self.view addSubview:comboLabel];
}

-(void) setupGiftsZone
{
    
}

-(void) setupTopScorllZone
{
    CGRect topRect = CGRectMake(0, 15, SCREEN_W, 80);
    TopScrollView *topView = [[TopScrollView alloc] initWithFrame:topRect];
    UITapGestureRecognizer *topRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(view)];
    [topView addGestureRecognizer:topRecognizer];
    [topView initTopScorllLabelView];
    
    [self.view addSubview:topView];
}

/*
-(void) setupEnterRoomInfoLabel
{
    CGRect labelRect = CGRectMake(0, SCREEN_H * 0.6 + 35, SCREEN_W, 30);
    EnterRoomInformView *label = [[EnterRoomInformView alloc]initWithFrame:labelRect];
    [label initLabelWithUser:@"糖人儿" andMounts:@"天马"];
    
    [self.view addSubview:label];
}
 */

//开始直播采集
- (IBAction)startLiveStream {
    
    StartLiveView *view = [[StartLiveView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:view];
    
    //_backBtn.hidden = YES;
    _middleView.hidden = YES;
    
}

-(void) setupChatField
{
    UILabel *textfieldLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_H * 0.55, SCREEN_W, 35)];
    UITextField *text = [[UITextField alloc] initWithFrame:CGRectMake(0, 2.5, SCREEN_W * 0.7, 25)];
    UIButton *sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_W * 0.75, 2.5, SCREEN_W * 0.2, 25)];
    //textfieldLabel.backgroundColor = [UIColor whiteColor];
    
    text.borderStyle = UITextBorderStyleRoundedRect;
    text.placeholder = @"和大家说点什么";
    text.returnKeyType = UIReturnKeySend;
    //text.delegate = self;
    
    _chatField = text;
    
    sendBtn.backgroundColor = [UIColor blueColor];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    
    [textfieldLabel addSubview:text];
    [textfieldLabel addSubview:sendBtn];
    
    _chatTextLabel = textfieldLabel;
    [self.view addSubview:_chatTextLabel];
}

//返回主界面
- (IBAction)clickBackBtn {
    
    //[_chatManager leaveRoom];
    [_animManager clearAllOperation];
    
    [_showroom StopPushStream];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//操作按钮
- (IBAction)clickOptionBtn {
    
    if(OptionBtnStatus)
    {
        [_optionView removeFromSuperview];
        OptionBtnStatus = NO;
    }
    else
    {
        CGRect viewRect = CGRectMake(SCREEN_W * 0.6, SCREEN_H * 0.7, OPTION_VIEW_W, OPTION_VIEW_H);
        LivingOptionView *view = [[LivingOptionView alloc] initWithFrame:viewRect];
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(view)];
        [view addGestureRecognizer:tapRecognizer];
        [view setupOptionView];
        _optionView = view;
        
        [self.view addSubview:_optionView];
        [self.view bringSubviewToFront:_optionView];
        OptionBtnStatus = YES;
    }
    
}

//聊天框
-(IBAction) clickChatBtn
{
    //UI控件整体上移
    //初始化聊天框
    [self setupChatField];
    //设置键盘
    [_chatField becomeFirstResponder];
}

/*
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [_chatTextLabel removeFromSuperview];
}
 */


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == _chatField)
    {
        [_chatField resignFirstResponder];
        [_chatTextLabel removeFromSuperview];
        return NO;
    }
    return YES;
}

-(IBAction) clickManageBtn
{
    NSString *title = @"Alert Button Selected";
    NSString *message = @"I need your attention NOW!";
    NSString *okButtonTitle = @"OK";
    NSString *neverButtonTitle = @"Never";
    NSString *laterButtonTitle = @"Maybe Later";
    
    // 初始化
    UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    
    // 分别3个创建操作
    UIAlertAction *laterAction = [UIAlertAction actionWithTitle:laterButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // 普通按键
        //self.userOutput.text = @"Clicked 'Maybe Later'";
    }];
    UIAlertAction *neverAction = [UIAlertAction actionWithTitle:neverButtonTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        // 红色按键
        //self.userOutput.text = @"Clicked 'Never'";
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:okButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        // 取消按键
        //self.userOutput.text = @"Clicked 'OK'";
    }];
    
    // 添加操作（顺序就是呈现的上下顺序）
    [alertDialog addAction:laterAction];
    [alertDialog addAction:neverAction];
    [alertDialog addAction:okAction];
    
    // 呈现警告视图
    [self presentViewController:alertDialog animated:YES completion:nil];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
    [_chatTextLabel removeFromSuperview];
    // IM 消息
    GSPChatMessage *msg = [[GSPChatMessage alloc] init];
    msg.text = @"1个【玫瑰】";
    // 模拟 n 个人在送礼物
    int x = arc4random() % 9;
    msg.senderChatID = [NSString stringWithFormat:@"%d",x];
    msg.senderName = msg.senderChatID;
    NSLog(@"id %@ -------送了1个【玫瑰】--------",msg.senderChatID);
    
    // 礼物模型
    GiftModel *giftModel = [[GiftModel alloc] init];
    giftModel.headImage = [UIImage imageNamed:@"head_icon"];
    giftModel.name = msg.senderName;
    giftModel.giftImage = [UIImage imageNamed:@"head_icon"];
    giftModel.giftName = msg.text;
    giftModel.giftCount = 1;
    
    AnimOperationManager *manager = [AnimOperationManager sharedManager];
    manager.parentView = self.view;
    // 用用户唯一标识 msg.senderChatID 存礼物信息,model 传入礼物模型
    [manager animWithUserID:[NSString stringWithFormat:@"%@",msg.senderChatID] model:giftModel finishedBlock:^(BOOL result) {
        
    }];
    _animManager = manager;

}

- (void)onChatRoom:(int) msgCode Msg:(NSString*) msg
{
    if(_msgarray != NULL)
        [_msgarray addObject:msg];
    else
    {
        _msgarray = [_barrage GetArray];
        if(_msgarray != NULL)
        {
            [_msgarray addObject:msg];
        }
    }
    
}

- (void)SpeakSomething
{
    [_chatManager speak:@"lxh speak test." to:@"" andPrivate:false];
}

@end

