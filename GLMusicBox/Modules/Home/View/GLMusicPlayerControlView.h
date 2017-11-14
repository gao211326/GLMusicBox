//
//  GLMusicPlayerControlView.h
//  GLMusicBox
//
//  Created by 高磊 on 2017/10/27.
//  Copyright © 2017年 高磊. All rights reserved.
//  控制部分 暂停播放下一首等

#import <UIKit/UIKit.h>


@class GLSlider;
@interface GLMusicPlayerControlView : UIView

@property (weak, nonatomic) IBOutlet GLSlider *slider;
//当前播放时间
@property (weak, nonatomic) IBOutlet UILabel *leftTimeLable;
//总时间
@property (nonatomic,weak) IBOutlet UILabel *rightTimeLable;
//播放、暂停按钮
@property (nonatomic,weak) IBOutlet UIButton *palyMusicButton;

@end
