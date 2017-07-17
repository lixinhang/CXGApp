//
//  UserCenterController.m
//  cxg
//
//  Created by abc on 16/8/26.
//  Copyright © 2016年 changyou. All rights reserved.
//

#import "UserCenterController.h"
#import "HeadView.h"
#import "UserCenterTableCellView.h"
#import "ManagePageController.h"
#import "SubPageController.h"
#import "QueryPageController.h"
#import "UIBarButtonItem+Item.h"

@interface MineViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UserHeadView *introView;
@property (nonatomic, weak) UITableView *tableView;

@end

@implementation MineViewController
{
    NSArray* tableData;
}

- (void)viewDidLoad
{
    tableData = @[@[@"本月收益",@"0 元宝"],
                  @[@"本月直播",@"0 场次"],
                  @[@"直播间管理",@" "],
                  @[@"设置",@" "]];
    
    
    [super viewDidLoad];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"usercenter_bg"]];
    imageView.frame = self.view.bounds;
    [self.view addSubview:imageView];
    
    [self setupPageView];
    
    //   self.edgesForExtendedLayout = UIRectEdgeNone;
    //隐藏navigationbar和tableHeaderView
    //self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@" " style:1 target:nil action:nil];
    self.navigationItem.backBarButtonItem = backBtn;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
    
- (void) setupPageView
{
    //UserHeadView *introView = [[UserHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, HEAD_VIEW_HEIGHT)];
    //[introView SetupUserCenterHeadView];
    //_introView = introView;
    [self setupPageHeadView];
    
    CGRect tableRect = CGRectMake(0, SCREEN_H * 0.45, SCREEN_W, GENERAL_TABLE_CELL_H * 4);
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tablecell_bg"]];
    background.frame = tableRect;
    [self.view addSubview:background];
                               
    UITableView *tableView = [[UITableView alloc] initWithFrame:tableRect style:UITableViewStyleGrouped];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.scrollEnabled = NO;
    tableView.backgroundColor = [UIColor clearColor];
    [tableView setSeparatorColor:FUIColorFromRGB(0x750eaf)];
    _tableView = tableView;
    
    [self.view addSubview:_introView];
    [self.view addSubview:_tableView];
    
    //添加监听，动态观察tableview的contentOffset的改变
    //[tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark ---- <KVO 回调>
//设置的最大高度为200，最小为64
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"])
    {
        CGPoint offset = [change[NSKeyValueChangeNewKey] CGPointValue];
        
        if (offset.y <= 0 && -offset.y >= 20) {
            
            CGRect newFrame = CGRectMake(0, 0, self.view.frame.size.width, -offset.y);
            
            _introView.frame = newFrame;
            
            if (-offset.y <= 200)
            {
                _tableView.contentInset = UIEdgeInsetsMake(-offset.y, 0, 0, 0);
            }
        } else {
            
            CGRect newFrame = CGRectMake(0, 0, self.view.frame.size.width, 64);
            _introView.frame = newFrame;
            _tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        }
    }
}

- (void)setupPageHeadView
{
    NSString *headIconName = @"headicon";
    UIButton *headIcon = [UIButton buttonWithType:UIButtonTypeCustom];
    [headIcon setImage:[UIImage imageNamed:headIconName] forState:UIControlStateNormal];
    [headIcon setImage:[UIImage imageNamed:headIconName] forState:UIControlStateHighlighted];
    [headIcon.layer setCornerRadius:100];
    
    [headIcon setFrame:CGRectMake((SCREEN_W - HEAD_ICON_SIZE) / 2, 80, HEAD_ICON_SIZE, HEAD_ICON_SIZE)];
    //[headIcon addTarget:self action:@selector(userIconClick) forControlEvents:UIControlEventTouchUpInside];
    [headIcon addTarget:self action:@selector(clickEditBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:headIcon];
    [self addUserInfoWithUserName:@"未登录" andLevel:@"levelicon"];
}

-(void) addUserInfoWithUserName:(NSString *)name andLevel:(NSString *)level
{
    UITextField *userName = [[UITextField alloc] init];
    userName.borderStyle = UITextBorderStyleNone;
    userName.text = name;
    userName.textColor = FUIColorFromRGB(0xff00aa);
    userName.font = [UIFont systemFontOfSize:16];
    userName.userInteractionEnabled = NO;
    
    UIImageView *levelIcon = [[UIImageView alloc] init];
    levelIcon.image = [UIImage imageNamed:level];
    
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [editBtn setImage:[UIImage imageNamed:@"editbtn"] forState:UIControlStateNormal];
    //[editBtn setImage:[UIImage imageNamed:@"editbtn"] forState:UIControlStateHighlighted];
    [editBtn addTarget:self action:@selector(clickEditBtn) forControlEvents:UIControlEventTouchUpInside];
    
    int nameWidth = [userName.text length] * 16;
    int posX = (SCREEN_W - nameWidth - 48) / 2;
    
    userName.frame = CGRectMake(posX, 170, nameWidth, 20);
    levelIcon.frame = CGRectMake(posX + nameWidth + 3, 170, 20, 20);
    editBtn.frame = CGRectMake(posX + nameWidth + 25, 168, 20, 20);
    
    [self.view addSubview:userName];
    [self.view addSubview:levelIcon];
    [self.view addSubview:editBtn];
    
    NSString *fans = [[NSString alloc] initWithFormat:@"%d",0];
    UITextField *fansNum = [[UITextField alloc] init];
    fansNum.text = [@"粉丝: " stringByAppendingString:fans];
    fansNum.textColor = [UIColor whiteColor];
    fansNum.font = [UIFont systemFontOfSize:15];
    fansNum.backgroundColor = [UIColor clearColor];
    fansNum.textAlignment = NSTextAlignmentCenter;
    fansNum.userInteractionEnabled = NO;
    
    int fansNumWidth = [fansNum.text length] * 15;
    posX = (SCREEN_W - fansNumWidth) / 2;
    fansNum.frame = CGRectMake(posX, 190, fansNumWidth, 20);
    
    [self.view addSubview:fansNum];
}

#pragma mark ---- <tableView数据源方法>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return GENERAL_TABLE_CELL_H;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSUInteger row = indexPath.row;
    switch (row) {
        case 0:
        {
            QueryPageController *childView = [[QueryPageController alloc] init];
            [self.navigationController pushViewController:childView animated:YES];
            [childView setupQueryPageWithType:QUERY_INCOME];
            break;
        }
        case 1:
        {
            QueryPageController *childView = [[QueryPageController alloc] init];
            [self.navigationController pushViewController:childView animated:YES];
            [childView setupQueryPageWithType:QUERY_LIVING];
            break;
        }
        case 2:
        {
            ManagePageController *childView = [[ManagePageController alloc] init];
            [self.navigationController pushViewController:childView animated:YES];
            [childView setupManagePageWithType:MANAGE];
            break;
        }
        case 3:
        {
            SubPageController *childView = [[SubPageController alloc] init];
            [self.navigationController pushViewController:childView animated:YES];
            [childView setupPageViewWithType:SETTING];
            break;
        }
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserCenterTableCellView *tableCell = [[UserCenterTableCellView alloc] initWithTableTitel:
                                          [(NSArray *)[tableData objectAtIndex:indexPath.row] objectAtIndex:indexPath.section]
                                          andDetail:
                                          [(NSArray *)[tableData objectAtIndex:indexPath.row] objectAtIndex:1]];
    
    return tableCell;
}

#pragma mark 按钮响应事件
- (void)clickEditBtn
{
    SubPageController *childView = [[SubPageController alloc] init];
    [self.navigationController pushViewController:childView animated:YES];
    [childView setupPageViewWithType:USERINFO];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
