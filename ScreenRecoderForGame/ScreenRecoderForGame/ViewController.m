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

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong,nonatomic)AVAudioPlayer * player;
@property (nonatomic,strong)NSTimer * timer;
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
}
- (IBAction)endRecord:(id)sender {
    [_player stop];
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
