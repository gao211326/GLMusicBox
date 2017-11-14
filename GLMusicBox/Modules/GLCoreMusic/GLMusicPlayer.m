//
//  GLMusicPlayer.m
//  GLMusicBox
//
//  Created by 高磊 on 2017/10/24.
//  Copyright © 2017年 高磊. All rights reserved.
//

#import "GLMusicPlayer.h"
#import "GLMusicLRCModel.h"
#import "GLMiniMusicView.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <notify.h>


@interface GLMusicPlayer()

@property (nonatomic,strong) CADisplayLink *progressTimer;

@end

@implementation GLMusicPlayer

+ (instancetype)defaultPlayer
{
    static GLMusicPlayer *player = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        FSStreamConfiguration *config = [[FSStreamConfiguration alloc] init];
        config.httpConnectionBufferSize *=2;
        config.enableTimeAndPitchConversion = YES;
        
        
        player = [[super alloc] initWithConfiguration:config];
        player.delegate = (id)self;
        player.onFailure = ^(FSAudioStreamError error, NSString *errorDescription) {
            //播放错误
            //有待解决
        };
        player.onCompletion = ^{
            //播放完成
                NSLog(@" 打印信息: 播放完成1");
        };
    
        
        player.onStateChange = ^(FSAudioStreamState state) {
            switch (state) {
                case kFsAudioStreamPlaying:
                {
                    NSLog(@" 打印信息  playing.....");
                    player.isPause = NO;
                    
                    [GLMiniMusicView shareInstance].palyButton.selected = YES;
                }
                    break;
                case kFsAudioStreamStopped:
                {
                    NSLog(@" 打印信息  stop.....%@",player.url.absoluteString);
                }
                    break;
                case kFsAudioStreamPaused:
                {
                    //pause
                    player.isPause = YES;
                    [GLMiniMusicView shareInstance].palyButton.selected = NO;
                        NSLog(@" 打印信息: pause");
                }
                    break;
                case kFsAudioStreamPlaybackCompleted:
                {
                    NSLog(@" 打印信息: 播放完成2");
                    [player playMusicForState];
                }
                    break;
                default:
                    break;
            }
        };
        //设置音量
        [player setVolume:0.5];
        //设置播放速率
        [player setPlayRate:1];
        player.loopState = GLForeverLoop;
    });
    return player;
}



#pragma mark == private method

- (void)updateProgress
{
    if (self.glPlayerDelegate && [self.glPlayerDelegate respondsToSelector:@selector(updateProgressWithCurrentPosition:endPosition:)])
    {
        [self.glPlayerDelegate updateProgressWithCurrentPosition:self.currentTimePlayed endPosition:self.duration];
    }
    
    [self showLockScreenCurrentTime:(self.currentTimePlayed.second + self.currentTimePlayed.minute * 60) totalTime:(self.duration.second + self.duration.minute * 60)];
}



#pragma mark == private method - 锁屏展示部分
- (void)showLockScreenCurrentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime
{
    //监听锁屏状态 lock=1则为锁屏状态
    uint64_t locked;
    __block int token = 0;
    notify_register_dispatch("com.apple.springboard.lockstate",&token,dispatch_get_main_queue(),^(int t){
    });
    notify_get_state(token, &locked);
    
    //监听屏幕点亮状态 screenLight = 1则为变暗关闭状态
    uint64_t screenLight;
    __block int lightToken = 0;
    notify_register_dispatch("com.apple.springboard.hasBlankedScreen",&lightToken,dispatch_get_main_queue(),^(int t){
    });
    notify_get_state(lightToken, &screenLight);
    if (screenLight == 0 && locked == 1) {
        NSMutableDictionary *musicInfoDict = [[NSMutableDictionary alloc] init];
        //设置歌曲题目
        [musicInfoDict setObject:self.currentTitle forKey:MPMediaItemPropertyTitle];
        //设置歌手名
        [musicInfoDict setObject:@"" forKey:MPMediaItemPropertyArtist];
        //设置专辑名
        [musicInfoDict setObject:@"" forKey:MPMediaItemPropertyAlbumTitle];
        //设置歌曲时长
        [musicInfoDict setObject:[NSNumber numberWithFloat:totalTime]
                          forKey:MPMediaItemPropertyPlaybackDuration];
        //设置已经播放时长
        [musicInfoDict setObject:[NSNumber numberWithFloat:currentTime]
                          forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
        
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:musicInfoDict];
    }
}


//不同状态下 播放歌曲
- (void)playMusicForState
{
    switch (self.loopState) {
        case GLSingleLoop:
        {
            [self playMusicAtIndex:self.currentIndex];
        }
            break;
        case GLForeverLoop:
        {
            if (self.currentIndex == self.musicListArray.count-1) {
                [self playMusicAtIndex:0];
            }else{
                [self playMusicAtIndex:self.currentIndex + 1];
            }
        }
            break;
        case GLRandomLoop:
        {
            //取随机值
            int index = arc4random() % self.musicListArray.count;
            [self playMusicAtIndex:index];
        }
            break;
        case GLOnceLoop:
        {
            if (self.currentIndex == self.musicListArray.count-1) {
                [self stop];
            }else{
                [self playMusicAtIndex:self.currentIndex + 1];
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark == overloading
- (void)play
{
    if (self.currentTitle.length == 0) {
        return;
    }
    [super play];
    if (!_progressTimer) {
        _progressTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateProgress)];
        [_progressTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}

- (void)playFromURL:(NSURL *)url
{
    //根据地址 在本地找歌词
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"musiclist" ofType:@"plist"]];
    for (NSString *playStringKey in dic.allKeys) {
        if ([[dic valueForKey:playStringKey] isEqualToString:url.absoluteString]) {
            self.currentTitle = playStringKey;
            break;
        }
    }
    
    [self stop];

    if (![url.absoluteString isEqualToString:self.url.absoluteString]) {
        [super playFromURL:url];
    }else{
        [self play];
    }
    
    NSLog(@" 当前播放歌曲:%@",self.currentTitle);
    
    [GLMiniMusicView shareInstance].titleLable.text = self.currentTitle;
    
    //获取歌词
    NSString *lrcFile = [NSString stringWithFormat:@"%@.lrc",self.currentTitle];
    self.musicLRCArray = [NSMutableArray arrayWithArray:[GLMusicLRCModel musicLRCModelsWithLRCFileName:lrcFile]];
    
    if (![self.musicListArray containsObject:url]) {
        [self.musicListArray addObject:url];
    }
    
    //更新主界面歌词UI
    if (self.glPlayerDelegate && [self.glPlayerDelegate respondsToSelector:@selector(updateMusicLrc)])
    {
        [self.glPlayerDelegate updateMusicLrc];
    }
    _currentIndex = [self.musicListArray indexOfObject:url];
    
    if (!_progressTimer) {
        _progressTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateProgress)];
        [_progressTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}

- (void)playFromOffset:(FSSeekByteOffset)offset
{
    [super playFromOffset:offset];
    if (!_progressTimer) {
        _progressTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateProgress)];
        [_progressTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}

- (void)stop
{
    [super stop];
    if (_progressTimer) {
        [_progressTimer invalidate];
        _progressTimer = nil;
    }
}


#pragma mark == public method
- (void)playMusicAtIndex:(NSUInteger)index
{
    if (index < self.musicListArray.count) {
        _currentIndex = index;
        [self playFromURL:[self.musicListArray objectAtIndex:index]];
    }
}

- (void)playFont
{
    switch (self.loopState) {
        case GLSingleLoop:
        {
            [self playMusicAtIndex:self.currentIndex];
        }
            break;
        case GLRandomLoop:
        {
            //取随机值
            int index = arc4random() % self.musicListArray.count;
            [self playMusicAtIndex:index];
        }
            break;

        case GLForeverLoop:
        {
            if (self.currentIndex == 0) {
                [self playMusicAtIndex:self.musicListArray.count - 1];
            }else{
                [self playMusicAtIndex:self.currentIndex - 1];
            }
        }
            break;

        case GLOnceLoop:
        {
            if (self.currentIndex == 0) {
                [self stop];
            }else{
                [self playMusicAtIndex:self.currentIndex - 1];
            }
        }
            break;

        default:
            break;
    }

}

- (void)playNext
{
    [self playMusicForState];
}
#pragma mark == setter
- (void)setLoopState:(GLLoopState)loopState
{
    _loopState = loopState;
}


#pragma mark == 懒加载

- (NSMutableArray *)musicListArray
{
    if (nil == _musicListArray) {
        _musicListArray = [[NSMutableArray alloc] init];
    }
    return _musicListArray;
}


@end

