//
//  RankListViewController.m
//  cxg
//
//  Created by abc on 16/9/28.
//  Copyright © 2016年 changyou. All rights reserved.
//

#import "RankListViewController.h"
#import "StarTableController.h"
#import "RichTableController.h"
#import "CharmTableController.h"
#import "UIView+Frame.h"


@interface RankListViewController () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, weak) UIScrollView *navigationView;
@property (nonatomic, weak) UIView *underLineView;

@property (nonatomic, weak) UIButton *curSelectBtn;
@property (nonatomic, strong) NSMutableArray *tableTypeBtns;

@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, assign) BOOL isInitial;
@end

@implementation RankListViewController

- (NSMutableArray *)tableTypeBtns
{
    if(_tableTypeBtns == nil)
    {
        _tableTypeBtns = [NSMutableArray array];
    }
    return _tableTypeBtns;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNavgationBar];
    [self setupBottomContentView];
    [self setupAllChildViewController];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"rank_nav_bg"]forBarMetrics:UIBarMetricsDefault];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_isInitial == NO)
    {
        [self setupNavigationSelectBtn];
        _isInitial = YES;
    }
    
    [self titleClick:_tableTypeBtns[0]];
}

#pragma mark - 添加所有的子控制器
- (void)setupAllChildViewController {
    
    //关注
    StarTableController *starTable = [[StarTableController alloc] init];
    starTable.title = @"明星榜";
    [self addChildViewController:starTable];
    
    //热门
    RichTableController *richTable = [[RichTableController alloc] init];
    richTable.title = @"富豪榜";
    [self addChildViewController:richTable];
    
    //最新
    CharmTableController *charmTable = [[CharmTableController alloc] init];
    charmTable.title = @"魅力榜";
    [self addChildViewController:charmTable];
    
}

#pragma mark - 设置导航条内容
- (void)setupNavgationBar
{
    //middleView
    UIScrollView *navigationView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 250, 50)];
    navigationView.scrollsToTop = NO;
    _navigationView = navigationView;
    
    [self.navigationItem setTitleView:_navigationView];
}

#pragma mark - 选中标题按钮
- (void)selButton:(UIButton *)curButton
{
    _curSelectBtn.selected = NO;
    curButton.selected = YES;
    _curSelectBtn = curButton;
    
    // 移动下划线的位置
    [UIView animateWithDuration:0.25 animations:^{
        _underLineView.xj_centerX = curButton.xj_centerX;
    }];

    switch (curButton.tag)
    {
        case 0:
        {
            _underLineView.backgroundColor = FUIColorFromRGB(0xff00aa);
            [_curSelectBtn setTitleColor:FUIColorFromRGB(0xff00aa) forState:UIControlStateNormal];
            [self.tableTypeBtns[1] setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [self.tableTypeBtns[2] setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            break;
        }
        case 1:
        {
            _underLineView.backgroundColor = FUIColorFromRGB(0x8261fe);
            [_curSelectBtn setTitleColor:FUIColorFromRGB(0x8261fe) forState:UIControlStateNormal];
            [self.tableTypeBtns[0] setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [self.tableTypeBtns[2] setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            break;
        }
        case 2:
        {
            _underLineView.backgroundColor = FUIColorFromRGB(0xd758ef);
            [_curSelectBtn setTitleColor:FUIColorFromRGB(0xd758ef) forState:UIControlStateNormal];
            [self.tableTypeBtns[0] setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [self.tableTypeBtns[1] setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            break;
        }
        default:
            break;
    }
}

#pragma mark - 选择标题
- (void)titleClick:(UIButton *)curButton
{
    NSInteger i = curButton.tag;
    
    // 重复点击标题按钮的时候,刷新当前界面
    if (curButton == _curSelectBtn)
    {
        //刷新操作
        return;
    }
    
    [self selButton:curButton];
    
    //滚动collectionView 修改偏移量
    CGFloat offsetX = i * SCREEN_W;
    _collectionView.contentOffset = CGPointMake(offsetX, 0);
}

#pragma mark - UICollectionViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger i = scrollView.contentOffset.x / SCREEN_W;
    UIButton *curButton = self.tableTypeBtns[i];

    [self selButton:curButton];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.childViewControllers.count;
}

// 只要有新的cell出现的时候才会调用
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 只要有新的cell出现,就把对应的子控制器的view添加到新的cell上
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:rankListViewID forIndexPath:indexPath];
    
    // 移除之前子控制器view
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    cell.backgroundColor = [UIColor whiteColor];
    
    // 取出对应的子控制器添加到对应cell上
    UIViewController *vc = self.childViewControllers[indexPath.row];
    vc.view.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
    [cell.contentView addSubview:vc.view];
    
    return cell;
}

#pragma mark - 添加导航栏按钮
- (void)setupNavigationSelectBtn
{
    NSUInteger count = self.childViewControllers.count;
    CGFloat btnW = 80;
    CGFloat btnX = 40;
    CGFloat btnH = _navigationView.xj_height;
    for (int i = 0; i < count; i++)
    {
        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        titleButton.tag = i;
        
        UIViewController *vc = self.childViewControllers[i];
        [titleButton setTitle:vc.title forState:UIControlStateNormal];
        [titleButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        
        btnX = i * btnW;
        titleButton.frame = CGRectMake(btnX, 0, btnW, btnH);
        titleButton.titleLabel.font = [UIFont systemFontOfSize:18];
        
        [_navigationView addSubview:titleButton];
        
        if (i == 0)
        {
            CGFloat h = 2;
            CGFloat y = 38;
            UIView *lineView =[[UIView alloc] init];
            // 位置和尺寸
            lineView.xj_height = h;
            // 先计算文字尺寸,在给label去赋值
            [titleButton.titleLabel sizeToFit];
            lineView.xj_width = titleButton.titleLabel.xj_width + 6;
            lineView.xj_centerX = titleButton.xj_centerX;
            lineView.xj_y = y + 6;
            lineView.backgroundColor = [UIColor lightGrayColor];
            _underLineView = lineView;
            
            [_navigationView addSubview:lineView];
        }
        
        [self.tableTypeBtns addObject:titleButton];
    }
}

#pragma mark - 添加底部内容view
- (void)setupBottomContentView
{
    // 创建一个流水布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(SCREEN_W, SCREEN_H);
    
    // 设置水平滚动方向
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    
    // 创建UICollectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [self.view addSubview:collectionView];
    _collectionView = collectionView;
    collectionView.scrollsToTop = NO;
    
    // 开启分页
    collectionView.pagingEnabled = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.bounces = NO;
    
    // 展示cell
    collectionView.dataSource = self;
    collectionView.delegate = self;
    
    // 注册cell
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:rankListViewID];
}

@end
