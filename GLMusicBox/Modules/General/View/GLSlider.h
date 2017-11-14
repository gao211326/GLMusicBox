//
//  GLSlider.h
//  GLMusicBox
//
//  Created by 高磊 on 2017/10/20.
//  Copyright © 2017年 高磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLSlider : UIControl

//进度条颜色
@property (nonatomic,strong) UIColor *progressColor;
//缓存条颜色
@property (nonatomic,strong) UIColor *progressCacheColor;
//滑块颜色
@property (nonatomic,strong) UIColor *thumbColor;

//设置进度值 0-1
@property (nonatomic,assign) CGFloat value;
//设置缓存进度值 0-1
@property (nonatomic,assign) CGFloat cacheValue;
@end
