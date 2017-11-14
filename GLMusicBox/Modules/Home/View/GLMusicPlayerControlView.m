//
//  GLMusicPlayerControlView.m
//  GLMusicBox
//
//  Created by 高磊 on 2017/10/27.
//  Copyright © 2017年 高磊. All rights reserved.
//

#import "GLMusicPlayerControlView.h"
#import "GLSlider.h"
#import "FSAudioStream.h"
#import "GLMusicPlayer.h"

@interface GLMusicPlayerControlView ()

//播放方法按钮
@property (nonatomic,weak) IBOutlet UIButton *playModeButton;
//前一首歌曲
@property (nonatomic,weak) IBOutlet UIButton *frontMusicButton;
//下一首
@property (nonatomic,weak) IBOutlet UIButton *nextMusicButton;

@property (nonatomic,assign) GLLoopState loopSate;
@end

@implementation GLMusicPlayerControlView
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [_slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    
    self.loopSate = GLForeverLoop;
    
    [_playModeButton setImage:[UIImage imageNamed:@"miniplayer_btn_repeat_normal"] forState:UIControlStateNormal];
    [_playModeButton setImage:[UIImage imageNamed:@"miniplayer_btn_repeat_highlight"] forState:UIControlStateHighlighted];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

#pragma mark == event responder
- (void)sliderValueChange:(GLSlider *)slider
{
    FSStreamPosition position = {};
    unsigned totalSeconds = [GLMusicPlayer defaultPlayer].duration.minute*60 + [GLMusicPlayer defaultPlayer].duration.second;
    unsigned currentSeconds = totalSeconds * slider.value;
    
    position.second = currentSeconds % 60;
    position.minute = currentSeconds / 60;
    
    [[GLMusicPlayer defaultPlayer] seekToPosition:position];
}

- (IBAction)frontMusic:(UIButton *)sender
{
    [[GLMusicPlayer defaultPlayer] playFont];
}

- (IBAction)play:(UIButton *)sender
{
    sender.selected = !sender.selected;
    //pause对应pause
    /*
     如果流播放，则在调用暂停时暂停流播放。
     否则(流暂停)，调用暂停将继续播放。
     */
    [[GLMusicPlayer defaultPlayer] pause];
}

- (IBAction)nextMusic:(UIButton *)sender
{
    [[GLMusicPlayer defaultPlayer] playNext];
}

- (IBAction)changePlayMode:(UIButton *)sender
{
    switch (self.loopSate) {
        case GLSingleLoop:
        {
            self.loopSate = GLForeverLoop;
            [_playModeButton setImage:[UIImage imageNamed:@"miniplayer_btn_repeat_normal"] forState:UIControlStateNormal];
            [_playModeButton setImage:[UIImage imageNamed:@"miniplayer_btn_repeat_highlight"] forState:UIControlStateHighlighted];
        }
            break;
        case GLForeverLoop:
        {
            self.loopSate = GLRandomLoop;
            [_playModeButton setImage:[UIImage imageNamed:@"miniplayer_btn_random_normal"] forState:UIControlStateNormal];
            [_playModeButton setImage:[UIImage imageNamed:@"miniplayer_btn_random_highlight"] forState:UIControlStateHighlighted];
        }
            break;
        case GLRandomLoop:
        {
            self.loopSate = GLOnceLoop;
            [_playModeButton setImage:[UIImage imageNamed:@"miniplayer_btn_repeat_onece_normal"] forState:UIControlStateNormal];
            [_playModeButton setImage:[UIImage imageNamed:@"miniplayer_btn_repeat_once_highlight"] forState:UIControlStateHighlighted];
        }
            break;
        case GLOnceLoop:
        {
            self.loopSate = GLSingleLoop;
            [_playModeButton setImage:[UIImage imageNamed:@"miniplayer_btn_repeatone_normal"] forState:UIControlStateNormal];
            [_playModeButton setImage:[UIImage imageNamed:@"miniplayer_btn_repeatone_highlight"] forState:UIControlStateHighlighted];
        }
            break;
        default:
            break;
    }
    
    [GLMusicPlayer defaultPlayer].loopState = self.loopSate;
}

@end
