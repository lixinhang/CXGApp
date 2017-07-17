//
//  BarrageViewController.m
//  cxg
//
//  Created by abc on 16/9/28.
//  Copyright © 2016年 changyou. All rights reserved.
//

#import "BarrageViewController.h"
#import "BarrageRenderer.h"
#import "NSSafeObject.h"
#import "UIImage+Barrage.h"

@interface BarrageViewController()
{
    BarrageRenderer * _renderer;
    NSTimer * _timer;
    NSInteger _index;
    
    NSMutableArray * _msgarray;
    int ncount;
}
@end

@implementation BarrageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _index = 0;
    [self initBarrageRenderer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initBarrageRenderer
{
    _renderer = [[BarrageRenderer alloc]init];
    if(_msgarray == nil)
    {
        _msgarray = [[NSMutableArray alloc]init];
    }
    [self.view addSubview:_renderer.view];
    self.view.frame = CGRectMake(0, 100, self.view.bounds.size.width, 300);
    _renderer.canvasMargin = UIEdgeInsetsMake(10, 10, 10, 10);
    // 若想为弹幕增加点击功能, 请添加此句话, 并在Descriptor中注入行为
    //_renderer.view.userInteractionEnabled = YES;
    [self.view sendSubviewToBack:_renderer.view];
    
    [self barrageStart];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSSafeObject * safeObj = [[NSSafeObject alloc]initWithObject:self withSelector:@selector(autoSendBarrage)];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:safeObj selector:@selector(excute) userInfo:nil repeats:YES];
}

- (void)dealloc
{
    [_msgarray removeAllObjects];
    ncount = 0;
    [_renderer stop];
    _msgarray = nil;
}

#pragma mark - Action
- (void)barrageStart
{
    [_renderer start];
}
- (void)barrageStop
{
    [_renderer stop];
}

- (void)autoSendBarrage
{
    NSInteger spriteNumber = [_renderer spritesNumberWithName:nil];
    self.infoLabel.text = [NSString stringWithFormat:@"当前屏幕弹幕数量: %ld",(long)spriteNumber];
    if (spriteNumber <= 500) { // 用来演示如何限制屏幕上的弹幕量
        [_renderer receive:[self walkTextSpriteDescriptorWithDirection:BarrageWalkDirectionR2L side:BarrageWalkSideLeft]];
        //[_renderer receive:[self walkTextSpriteDescriptorWithDirection:BarrageWalkDirectionR2L side:BarrageWalkSideDefault]];
        
        //[_renderer receive:[self walkTextSpriteDescriptorWithDirection:BarrageWalkDirectionB2T side:BarrageWalkSideLeft]];
        //[_renderer receive:[self walkTextSpriteDescriptorWithDirection:BarrageWalkDirectionB2T side:BarrageWalkSideRight]];
        
        //[_renderer receive:[self floatTextSpriteDescriptorWithDirection:BarrageFloatDirectionB2T side:BarrageFloatSideCenter]];
        //[_renderer receive:[self floatTextSpriteDescriptorWithDirection:BarrageFloatDirectionT2B side:BarrageFloatSideLeft]];
        //[_renderer receive:[self floatTextSpriteDescriptorWithDirection:BarrageFloatDirectionT2B side:BarrageFloatSideRight]];
        
        //[_renderer receive:[self walkImageSpriteDescriptorWithDirection:BarrageWalkDirectionL2R]];
        //[_renderer receive:[self walkImageSpriteDescriptorWithDirection:BarrageWalkDirectionL2R]];
        //[_renderer receive:[self floatImageSpriteDescriptorWithDirection:BarrageFloatDirectionT2B]];
    }
}

#pragma mark - 弹幕描述符生产方法

/// 生成精灵描述 - 过场文字弹幕
- (BarrageDescriptor *)walkTextSpriteDescriptorWithDirection:(BarrageWalkDirection)direction
{
    return [self walkTextSpriteDescriptorWithDirection:direction side:BarrageWalkSideDefault];
}

/// 生成精灵描述 - 过场文字弹幕
- (BarrageDescriptor *)walkTextSpriteDescriptorWithDirection:(BarrageWalkDirection)direction side:(BarrageWalkSide)side
{
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];

    /*
    NSString* msg = nil;
    ncount = _msgarray.count;
    if(ncount > 0)
    {
        msg = [_msgarray objectAtIndex:0];
        [_msgarray removeObjectAtIndex:0];
        ncount = _msgarray.count;
    }
    else{ return descriptor; }
    
     */
    descriptor.spriteName = NSStringFromClass([BarrageWalkTextSprite class]);
    descriptor.params[@"text"] = [NSString stringWithFormat:@"过场飞屏:%ld",(long)_index++];
    //descriptor.params[@"text"] = msg;
    descriptor.params[@"textColor"] = [UIColor blackColor];
    descriptor.params[@"speed"] = @(100 * (double)random()/RAND_MAX+50);
    descriptor.params[@"direction"] = @(direction);
    descriptor.params[@"side"] = @(side);
    descriptor.params[@"clickAction"] = ^{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"弹幕被点击" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alertView show];
    };
    
    return descriptor;
}

- (NSMutableArray *) GetArray
{
    return _msgarray;
}


@end
