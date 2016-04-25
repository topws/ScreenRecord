//
//  GameScreenRecoder.m
//  ScreenRecoderForGame
//
//  Created by qianwei on 16/4/21.
//  Copyright © 2016年 qianwei. All rights reserved.
//

#import "GameScreenRecoder.h"


#if TARGET_IPHONE_SIMULATOR
#define SIMULATOR 1
#elif TARGET_OS_IPHONE
#define SIMULATOR 0
#endif

@interface GameScreenRecoder()<RPScreenRecorderDelegate>
//@property (nonatomic,strong)
@property (assign,nonatomic)BOOL isRecord;
//加载中的提示，可以自行替换
@property(nonatomic,strong)UIActivityIndicatorView * indicator;
@end

@implementation GameScreenRecoder
+(instancetype)INSTANCE{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
    });
    return instance;
}
+(BOOL)startRecord:(BOOL)isNeedMicroPhone{
   return [[self INSTANCE]start:isNeedMicroPhone];
}
+(void)stopRecord{
    [[self INSTANCE]stop];
}
-(instancetype)init{
    if (self = [super init]) {
        _isRecord = NO;
        [RPScreenRecorder sharedRecorder].delegate = self;
    }
    return self;
}
-(UIActivityIndicatorView *)indicator{
    if (_indicator == nil) {
        _indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        UIView * view = [UIApplication sharedApplication].keyWindow.rootViewController.view;
        _indicator.bounds = CGRectMake(0, 0, 50, 50);
        _indicator.center = view.center;
        [view addSubview:_indicator];
    }
    return _indicator;
}
//开始录制
-(BOOL)start:(BOOL)isNeedMicroPhone{
    if (![self isSystemVersionOk]) {
        return NO;
    }
    //不支持模拟器
    if (SIMULATOR) {
        [self showSimulatorWarning];
        return NO;
    }
    if (![RPScreenRecorder sharedRecorder].isAvailable) {
        NSLog(@"不支持ReplayKit录制");
        return NO;
    }
    //系统自带的接口，判断是否在录制，比我的好用多了
    NSLog(@"%d",[[RPScreenRecorder sharedRecorder]isRecording]);
    if ([[RPScreenRecorder sharedRecorder]isRecording]) {
        return NO;
    }
    
    
    if ([self isRecord]) {
        return NO;
    }
    self.isRecord = YES;
    //开始录制(参数是是否启用麦克风)(回调是 录制是否准备完毕
    [[self indicator]startAnimating];
    if ([[self delegate] respondsToSelector:@selector(loading)]) {
        [[self delegate]loading];
    }
    [[RPScreenRecorder sharedRecorder]startRecordingWithMicrophoneEnabled:isNeedMicroPhone handler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"录制失败 %@",error);
            self.isRecord = NO;
            
        }else{
            //加载完毕
            if ([[self delegate] respondsToSelector:@selector(loadEnd)]) {
                [[self delegate]loadEnd];
            }
        }
        [[self indicator]stopAnimating];
    }];
    return YES;
}
//结束录制
-(void)stop{
    NSLog(@"结束录制");
    self.isRecord = NO;
    
    //应该修改提示文字
    
    [[RPScreenRecorder sharedRecorder]stopRecordingWithHandler:^(RPPreviewViewController * _Nullable previewViewController, NSError * _Nullable error) {
        if (!error) {
            //让代理控制器来展示
            if ([self.delegate respondsToSelector:@selector(showSuccessViewController)])
                {
                    if ([self.delegate isKindOfClass:[UIViewController class]])
                    {
                        UIViewController * vc = (UIViewController *)self.delegate;
                        previewViewController.previewControllerDelegate = vc;
                        NSLog(@"%@",[NSThread currentThread]);
                        //回到主线程展示页面
                        [vc presentViewController:previewViewController animated:YES completion:^{
                            
                        }];

                        
                    }
            }
        }
    }];
}
#pragma mark RPScreenRecordDelegate
- (void)screenRecorder:(RPScreenRecorder *)screenRecorder didStopRecordingWithError:(NSError *)error previewViewController:(nullable RPPreviewViewController *)previewViewController
{
    NSLog(@"%s  error = %@",__FUNCTION__,error);
}

- (void)screenRecorderDidChangeAvailability:(RPScreenRecorder *)screenRecorder
{
    //如果变成了无法录屏，应该发送通知去停止录屏
    NSLog(@"屏幕录制的能力改变了 %d %d",screenRecorder.isRecording,screenRecorder.isAvailable);
}


-(void)showSimulatorWarning{
    NSLog(@"不支持模拟器");
}
//判断对应系统版本是否支持ReplayKit
- (BOOL)isSystemVersionOk {
    if ([[UIDevice currentDevice].systemVersion floatValue] < 9.0) {
        return NO;
    } else {
        return YES;
    }
}

@end
