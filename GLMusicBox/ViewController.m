//
//  ViewController.m
//  GLMusicBox
//
//  Created by 高磊 on 2017/8/7.
//  Copyright © 2017年 高磊. All rights reserved.
//

#import "ViewController.h"

#import "FSAudioStream.h"
#import "GLMusicLrcLable.h"
#import "GLSlider.h"

#import "GLMusicPlayer.h"

@interface ViewController ()<FSPCMAudioStreamDelegate>

//@property (nonatomic,strong) FSAudioStream *audioStream;

@property (nonatomic,strong) CALayer *dot;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    FSStreamConfiguration *config = [[FSStreamConfiguration alloc] init];
    config.httpConnectionBufferSize *=2;
    config.enableTimeAndPitchConversion = YES;
    

//    self.audioStream = [[FSAudioStream alloc] initWithConfiguration:config];
//    self.audioStream.delegate = (id)self;
//    self.audioStream.onFailure = ^(FSAudioStreamError error, NSString *errorDescription) {
//
//    };
//    __weak typeof(self)weakSelf = self;
//    self.audioStream.onCompletion = ^{
//        [weakSelf.audioStream stop];
//    };
//
//    self.audioStream.onStateChange = ^(FSAudioStreamState state) {
//        switch (state) {
//            case kFsAudioStreamPlaying:
//            {
////                    NSLog(@" 打印信息  playing.....");
//
//
//            }
//                break;
//
//            default:
//                break;
//        }
//    };
//    [self.audioStream setVolume:0.8];
//    //设置播放速率
//    [self.audioStream setPlayRate:1];
    
    __block GLMusicLrcLable *lable = [[GLMusicLrcLable alloc] initWithFrame:CGRectMake(10, 100, 300, 40)];
    lable.text = @"我们说好的都是的点击我的的我的我哦哦哦哦哈哈哈哈哈哈哈";
    [self.view addSubview:lable];
    
    
    [GLMusicPlayer defaultPlayer].loopState = GLSingleLoop;
    
    [[GLMusicPlayer defaultPlayer] playFromURL:[NSURL URLWithString:@"http://sc1.111ttt.com/2017/1/05/09/298092042172.mp3"]];
  
    __block GLSlider *slider = [[GLSlider alloc] initWithFrame:CGRectMake(50, 200, 200, 30)];
    slider.backgroundColor = [UIColor yellowColor];
    [slider setValue:0];
    [self.view addSubview:slider];
    [slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    
    __block CGFloat progress = 0;
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {

//        NSLog(@" 打印信息:%u---%u",self.audioStream.currentTimePlayed.minute, self.audioStream.currentTimePlayed.second);
        progress = ([GLMusicPlayer defaultPlayer].currentTimePlayed.minute*60 + [GLMusicPlayer defaultPlayer].currentTimePlayed.second)*1.0 / ([GLMusicPlayer defaultPlayer].duration.minute*60 + [GLMusicPlayer defaultPlayer].duration.second);
//        NSLog(@" 打印信息:%f",progress);
        [lable setProgress:progress];
        [slider setValue:progress];
        
    
//        NSLog(@" 打印信息:%u--%u",self.audioStream.currentTimePlayed.second,self.audioStream.duration.minute);
    }];

}

- (void)audioStream:(FSAudioStream *)audioStream samplesAvailable:(AudioBufferList *)samples frames:(UInt32)frames description: (AudioStreamPacketDescription)description
{
    
    
}


#pragma mark == event
- (void)sliderValueChange:(GLSlider *)slider
{
    FSStreamPosition position = {};
    unsigned totalSeconds = [GLMusicPlayer defaultPlayer].duration.minute*60 + [GLMusicPlayer defaultPlayer].duration.second;
    unsigned currentSeconds = totalSeconds * slider.value;
    
    position.second = currentSeconds % 60;
    position.minute = currentSeconds / 60;
    
    [[GLMusicPlayer defaultPlayer] seekToPosition:position];
    
    NSLog(@" 打印信息:%u",currentSeconds);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
