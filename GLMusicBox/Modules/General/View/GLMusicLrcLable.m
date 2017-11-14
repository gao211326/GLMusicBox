//
//  GLMusicLrcLable.m
//  GLMusicBox
//
//  Created by 高磊 on 2017/10/20.
//  Copyright © 2017年 高磊. All rights reserved.
//

#import "GLMusicLrcLable.h"

@implementation GLMusicLrcLable

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    //重绘
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGRect fillRect = CGRectMake(0, 0, self.bounds.size.width * _progress, self.bounds.size.height);
    
    [UICOLOR_FROM_RGB(45, 185, 105) set];
    
    UIRectFillUsingBlendMode(fillRect, kCGBlendModeSourceIn);
}
@end
