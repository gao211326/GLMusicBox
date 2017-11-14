//
//  GLSlider.m
//  GLMusicBox
//
//  Created by 高磊 on 2017/10/20.
//  Copyright © 2017年 高磊. All rights reserved.
//

#import "GLSlider.h"

static CGFloat const kProgressHeight = 2;
static CGFloat const kProgressLeftPadding = 2;
static CGFloat const kThumbHeight = 16;
@interface GLSlider()

//滑块 默认
@property (nonatomic,strong) CALayer *thumbLayer;
//进度条
@property (nonatomic,strong) CALayer *progressLayer;
//缓存进度条
@property (nonatomic,strong) CALayer *progressCacheLayer;

@property (nonatomic,assign) BOOL isTouch;

@end

@implementation GLSlider

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubLayers];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self addSubLayers];
    }
    return self;
}

#pragma mark == private method

- (void)addSubLayers
{
    [self.layer addSublayer:self.progressLayer];
    [self.layer addSublayer:self.progressCacheLayer];
    [self.layer addSublayer:self.thumbLayer];
}


- (void)layoutSubviews
{
    [super layoutSubviews];

    if (CGRectEqualToRect(_progressLayer.frame, CGRectZero) ||
        CGRectEqualToRect(_thumbLayer.frame, CGRectZero))
    {
        _progressLayer.frame = CGRectMake(kProgressLeftPadding, (CURRENT_FRAME_HEIGTH - kProgressHeight)/2.0, CURRENT_FRAME_WIDTH - 2*kProgressLeftPadding, kProgressHeight);
        _progressCacheLayer.frame = CGRectMake(kProgressLeftPadding, (CURRENT_FRAME_HEIGTH - kProgressHeight)/2.0, 0, kProgressHeight);
        _thumbLayer.frame = CGRectMake(0, 0, kThumbHeight, kThumbHeight);
        [_thumbLayer setPosition:CGPointMake(kThumbHeight/2.0, self.layer.frame.size.height/2.0)];
    }
}
#pragma mark == touch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    self.isTouch = YES;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    self.isTouch = YES;
    CGPoint touch = [[touches anyObject]locationInView:self];
    CGFloat x = touch.x;
    if (touch.x < kThumbHeight/2.0) {
        x = kThumbHeight/2.0;
    }else if (touch.x > (CURRENT_FRAME_WIDTH - kThumbHeight/2.0)){
        x = self.frame.size.width - kThumbHeight/2.0;
    }
    //关闭隐式动画
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [_thumbLayer setPosition:CGPointMake(x, self.layer.frame.size.height/2.0)];
    CGRect frame = self.progressCacheLayer.frame;
    frame.size.width = x-frame.origin.x;
    [self.progressCacheLayer setFrame:frame];
    
    [CATransaction commit];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    self.isTouch = NO;
    
    CGPoint touch = [[touches anyObject]locationInView:self];
    CGFloat x = touch.x;
    if (touch.x <= kThumbHeight/2.0) {
        x = kThumbHeight/2.0;
    }else if (touch.x >= (CURRENT_FRAME_WIDTH - kThumbHeight/2.0)){
        x = CURRENT_FRAME_WIDTH - kThumbHeight/2.0;
    }
    
    self.value = 1.0*(x-kThumbHeight/2.0)/ (CURRENT_FRAME_WIDTH - kThumbHeight);
    
    for (id target in [self allTargets]) {
        NSArray *actions = [self actionsForTarget:target forControlEvent:UIControlEventValueChanged];
        for (NSString *action in actions) {
            [self sendAction:NSSelectorFromString(action) to:target forEvent:event];
        }
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    self.isTouch = NO;
    
}

#pragma mark == setter
-(void)setValue:(CGFloat)value
{
    if (self.isTouch) {
        return;
    }
    _value = value;
    //关闭隐式动画
    [CATransaction begin];
    [CATransaction setDisableActions:YES];

    [self.thumbLayer setPosition:CGPointMake(kThumbHeight/2.0+_value *(CURRENT_FRAME_WIDTH-kThumbHeight), CGRectGetHeight(self.frame)/2.0)];
    CGRect frame = self.progressCacheLayer.frame;
    frame.size.width = _value * (CURRENT_FRAME_WIDTH-kThumbHeight);
    [self.progressCacheLayer setFrame:frame];
    
    [CATransaction commit];
}


#pragma mark == 懒加载

- (CALayer *)thumbLayer
{
    if (nil == _thumbLayer) {
        _thumbLayer = [CALayer layer];
        [_thumbLayer setContents:(id)[UIImage imageNamed:@"mvplayer_progress_thumb_mini"].CGImage];
    }
    return _thumbLayer;
}

- (CALayer *)progressLayer
{
    if (nil == _progressLayer) {
        _progressLayer = [CALayer layer];
        _progressLayer.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"mvplayer_progress_bg_mini"]].CGColor;
    }
    return _progressLayer;
}

- (CALayer *)progressCacheLayer
{
    if (nil == _progressCacheLayer) {
        _progressCacheLayer = [CALayer layer];
        _progressCacheLayer.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"mvplayer_progress_played_mini"]].CGColor;
    }
    return _progressCacheLayer;
}


@end
