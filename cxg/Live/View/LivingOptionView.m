//
//  LivingOptionView.m
//  cxg
//
//  Created by abc on 16/9/14.
//  Copyright © 2016年 changyou. All rights reserved.
//

#import "LivingOptionView.h"
#import <AVFoundation/AVFoundation.h>

#define BUTTON_W    100
#define BUTTON_H    50

static bool flashBtnStatus = NO;

@interface LivingOptionView()

@property (nonatomic, weak)  UIButton *btn;
@property (nonatomic,strong) AVCaptureSession * captureSession;
@property (nonatomic,strong) AVCaptureDevice * captureDevice;

@end

@implementation LivingOptionView


-(void) setupOptionView
{
    self.backgroundColor = [UIColor grayColor];
    self.userInteractionEnabled = YES;
    _captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    for(int i = 0; i < 3; i++)
    {
        [self setupButtonsWithButtonNum:i];
    }
    
}

-(void) setupButtonsWithButtonNum:(int)num
{
    UIButton *btn = [[UIButton alloc] init];
    //UIImageView *btnImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconName]];
    switch (num) {
        case 0:
        {
            //[btn setImage:[UIImage imageNamed:iconName] forState:UIControlStateNormal];
            [btn setTitle:@"闪光灯" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(flashControl) forControlEvents:UIControlEventTouchUpInside];
            btn.frame = CGRectMake(0, 0, BUTTON_W, BUTTON_H);
            
            [self addSubview:btn];
            break;
        }
        case 1:
        {
            //[btn setImage:[UIImage imageNamed:iconName] forState:UIControlStateNormal];
            [btn setTitle:@"翻转" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(turnOverCamera) forControlEvents:UIControlEventTouchUpInside];
            btn.frame = CGRectMake(0, BUTTON_H, BUTTON_W, BUTTON_H);
            
            [self addSubview:btn];
            break;
        }
        case 2:
        {
            //[btn setImage:[UIImage imageNamed:iconName] forState:UIControlStateNormal];
            [btn setTitle:@"美颜" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(beautyFaceControl) forControlEvents:UIControlEventTouchUpInside];
            
            btn.frame = CGRectMake(0, BUTTON_H * 2, BUTTON_W, BUTTON_H);
            
            [self addSubview:btn];
            break;
        }
            
        default:
            break;
    }
}

- (IBAction)flashControl
{
    if(flashBtnStatus)
    {
        //关闭闪光灯
        [self.captureDevice lockForConfiguration:nil];
        if(self.captureDevice.torchMode == AVCaptureTorchModeOn)
        {
            [self.captureDevice setTorchMode:AVCaptureTorchModeOff];
            [self.captureDevice setFlashMode:AVCaptureFlashModeOff];
        }
        [self.captureDevice unlockForConfiguration];
        flashBtnStatus = NO;
    }
    else
    {
        //打开闪光灯
        if([self.captureDevice hasTorch] && [self.captureDevice hasFlash])
        {
            if(self.captureDevice.torchMode == AVCaptureTorchModeOff)
            {
                [self.captureDevice lockForConfiguration:nil];
                [self.captureDevice setTorchMode:AVCaptureTorchModeOn];
                [self.captureDevice setFlashMode:AVCaptureFlashModeOn];
                [self.captureDevice unlockForConfiguration];
            }
        }
        flashBtnStatus = YES;
    }
}

- (IBAction)turnOverCamera
{
    
}

- (IBAction)beautyFaceControl
{
    
}


@end
