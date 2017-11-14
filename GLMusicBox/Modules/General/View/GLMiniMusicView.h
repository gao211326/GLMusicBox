//
//  GLMiniMusicView.h
//  GLMusicBox
//
//  Created by 高磊 on 2017/11/10.
//  Copyright © 2017年 高磊. All rights reserved.
//  小圆形播放器指示器

#import <UIKit/UIKit.h>



@interface GLMiniMusicView : UIView

+ (instancetype)shareInstance;


//头图
@property (nonatomic,strong) UIImageView *imageView;
//歌曲名
@property (nonatomic,strong) UILabel *titleLable;
//播放暂停控制按钮
@property (nonatomic,strong) UIButton *palyButton;
/**
 *
 展示
 *
 **/
- (void)showView;

/**
 *
 隐藏
 *
 **/
- (void)hiddenView;

@end
