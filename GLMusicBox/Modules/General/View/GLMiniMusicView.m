//
//  GLMiniMusicView.m
//  GLMusicBox
//
//  Created by 高磊 on 2017/11/10.
//  Copyright © 2017年 高磊. All rights reserved.
//

#import "GLMiniMusicView.h"
#import "GLMusicPlayer.h"
#import "AppDelegate.h"

#import "GLMusicPlayViewController.h"

static CGFloat const kShowBarHeight = 50;
static CGFloat const kMiniMusicImageWidth = 30;
static CGFloat const kMiniMusicImageHeight = 30;
static CGFloat const kMiniMusicPlayWidth = 32;
static CGFloat const kMiniMusicPlayHeight = 32;

@interface GLMiniMusicView()<UIGestureRecognizerDelegate>

@property (nonatomic,strong) UITapGestureRecognizer *tapGesture;

@end

@implementation GLMiniMusicView

+ (instancetype)shareInstance
{
    static GLMiniMusicView *miniMusicView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        miniMusicView = [[GLMiniMusicView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kShowBarHeight)];
    });
    
    return miniMusicView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UICOLOR_FROM_RGB_OxFF(0xdedede);
        [self addViews];
        [self addViewConstraint];
        
        self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTouch:)];
        self.tapGesture.delegate = (id)self;
        [self addGestureRecognizer:self.tapGesture];
    }
    return self;
}

- (void)addViews
{
    [self addSubview:self.imageView];
    [self addSubview:self.titleLable];
    [self addSubview:self.palyButton];
}

- (void)addViewConstraint
{
    [self.imageView makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(kMiniMusicImageWidth, kMiniMusicImageHeight));
        make.centerY.equalTo(self.centerY);
        make.left.equalTo(self.left).offset(20);
    }];
    
    [self.titleLable makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView.right).offset(20);
        make.centerY.equalTo(self.centerY);
        make.right.equalTo(self.palyButton.left).offset(-20);
    }];
    
    [self.palyButton makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(kMiniMusicPlayWidth, kMiniMusicPlayHeight));
        make.right.equalTo(self.right).offset(-20);
        make.centerY.equalTo(self.centerY);
    }];
}


#pragma mark == UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]])
    {
        return NO;
    }
    return YES;
}


#pragma mark == event response
- (void)tapTouch:(UITapGestureRecognizer *)tap
{
    UIViewController *vc = nil;
    if ([APP.window.rootViewController isKindOfClass:[UINavigationController class]]) {
        vc = ((UINavigationController *)APP.window.rootViewController).topViewController;
        
    }else if ([APP.window.rootViewController isKindOfClass:[UIViewController class]]){
        vc = ((UIViewController *)APP.window.rootViewController);
        
    }
    
    if ([GLMusicPlayer defaultPlayer].currentTitle.length == 0) {
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示" message:@"你还没有播放歌曲" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alter addAction:action];
        
        [vc presentViewController:alter animated:YES completion:^{
            
        }];
        return;
    }
    
    [self hiddenView];
    GLMusicPlayViewController *playerVc = [[GLMusicPlayViewController alloc] init];

    [vc presentViewController:playerVc animated:YES completion:^{
        
    }];
}

- (void)play:(UIButton *)sender
{
    if ([GLMusicPlayer defaultPlayer].currentTitle.length == 0) {
        return;
    }
    sender.selected = !sender.selected;
    //pause对应pause
    /*
     如果流播放，则在调用暂停时暂停流播放。
     否则(流暂停)，调用暂停将继续播放。
     */
    [[GLMusicPlayer defaultPlayer] pause];
}


#pragma mark == public method
- (void)showView
{
    [APP.window addSubview:self];
    [self makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(kScreenWidth, kShowBarHeight));
        make.bottom.equalTo(APP.window.bottom);
        make.left.equalTo(APP.window.left);
    }];
}

- (void)hiddenView
{
    [self removeFromSuperview];
}

#pragma mark == 懒加载
- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.image = [UIImage imageNamed:@"rr_recent"];
        //设置圆角 当然可以选择设置cornerRadius
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, kMiniMusicImageWidth, kMiniMusicImageHeight) cornerRadius:kMiniMusicImageWidth/2.0];
        CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
        shapeLayer.frame = CGRectMake(0, 0, kMiniMusicImageWidth, kMiniMusicImageHeight);
        shapeLayer.path = path.CGPath;
        _imageView.layer.mask = shapeLayer;
    }
    return _imageView;
}

- (UILabel *)titleLable
{
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] init];
        _titleLable.font = [UIFont systemFontOfSize:14];
        _titleLable.textColor = UICOLOR_FROM_RGB(45, 185, 105);
        _titleLable.text = @"当前暂无歌曲~";
    }
    return _titleLable;
}

- (UIButton *)palyButton
{
    if (!_palyButton) {
        _palyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_palyButton setImage:[UIImage imageNamed:@"miniplayer_btn_play_normal"] forState:UIControlStateNormal];
        [_palyButton setImage:[UIImage imageNamed:@"miniplayer_btn_pause_normal"] forState:UIControlStateSelected];
        [_palyButton addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _palyButton;
}

@end
