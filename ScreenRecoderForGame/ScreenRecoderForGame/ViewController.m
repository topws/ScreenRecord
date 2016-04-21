//
//  ViewController.m
//  ScreenRecoderForGame
//
//  Created by qianwei on 16/4/21.
//  Copyright © 2016年 qianwei. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <ReplayKit/ReplayKit.h>
#import "GameScreenRecoder.h"

@interface ViewController ()<GameScreenRecoderDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong,nonatomic)AVAudioPlayer * player;
@property (nonatomic,strong)NSTimer * timer;
@property (weak, nonatomic) IBOutlet UILabel *flagLabel;
@end

@implementation ViewController
-(NSTimer *)timer{
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeBegin) userInfo:nil repeats:YES];
    }
    return _timer;
}
-(void)timeBegin{
    _timeLabel.text = [NSString stringWithFormat:@"%ld",[_timeLabel.text integerValue]+1];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage * image1 = [UIImage imageNamed:@"0.png"];
    UIImage * image2 = [UIImage imageNamed:@"1.gif"];
    self.backImageView.animationImages = @[image1,image2];
    self.backImageView.animationDuration = 3.0;
    self.backImageView.animationRepeatCount = 0;
    [self.backImageView startAnimating];
    [self createMusic];
    [self.timer fire];
    [GameScreenRecoder INSTANCE].delegate = self;
    self.flagLabel.text = @"状态";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc{
    [self.timer invalidate];
    self.timer = nil;
}
- (IBAction)startRecord:(id)sender {
    //同时开启音乐
    [_player play];
    [GameScreenRecoder startRecord:YES];
    [self.timer fire];
    NSLog(@"开始录制");
}
- (IBAction)endRecord:(id)sender {
    [_player stop];
    [GameScreenRecoder  stopRecord];
    self.flagLabel.text = @"录制结束";
    [self.timer invalidate];
    self.timer = nil;
     NSLog(@"结束");
}
#pragma mark -Delegate
-(void)loading{
    self.flagLabel.text = @"准备中";
}
-(void)loadEnd{
    self.flagLabel.text = @"正在录制";
}
-(void)showSuccessViewController{
    
}
- (void)previewControllerDidFinish:(RPPreviewViewController *)previewController{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"%@",previewController);
    [previewController dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}
- (void)previewController:(RPPreviewViewController *)previewController didFinishWithActivityTypes:(NSSet <NSString *> *)activityTypes{
    NSLog(@"展示视图的内容%@",activityTypes);
    if ([activityTypes containsObject:@"com.apple.UIKit.activity.SaveToCameraRoll"]) {
        NSLog(@"已保存到用户相册,如果有需要可以提示用户，弹出一个对话框");
    }
    //"com.apple.UIKit.activity.CopyToPasteboard"拷贝了该文件
    
}
#pragma mark -音乐播放
-(void)createMusic{
    NSURL * url = [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"a" ofType:@"mp3"]];
    AVAudioPlayer * player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    player.volume = 1.0;
    self.player = player;
    [player prepareToPlay];
  
}

@end
