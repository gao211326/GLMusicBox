//
//  GLMusicPlayViewController.m
//  GLMusicBox
//
//  Created by 高磊 on 2017/10/24.
//  Copyright © 2017年 高磊. All rights reserved.
//

#import "GLMusicPlayViewController.h"
#import "GLMusicLRCModel.h"
#import "MusicLRCTableViewCell.h"
#import "GLMusicLrcLable.h"
#import "GLMusicPlayer.h"
#import "GLSlider.h"
#import "GLMusicPlayerControlView.h"
#import "NSString+translation.h"

@interface GLMusicPlayViewController ()<UITableViewDelegate,UITableViewDataSource,GLMusicPlayerDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) UIImageView *backImageView;

@property (nonatomic,strong) UIButton *disMissButton;

@property (nonatomic,strong) UITableView *lrcTableView;

@property (nonatomic,strong) GLMusicPlayerControlView *playerControlView;
//当前歌词所在行
@property (nonatomic,assign) NSInteger currentLcrIndex;

@property (nonatomic,assign) BOOL isDrag;
@end

@implementation GLMusicPlayViewController
- (id)init
{
    self = [super init];
    if (self) {
        self.currentLcrIndex = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeViewComponents];
    [self addViewConstraints];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [GLMusicPlayer defaultPlayer].glPlayerDelegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [GLMusicPlayer defaultPlayer].glPlayerDelegate = nil;
}
#pragma mark == private method

- (void)initializeViewComponents
{
    [self.view addSubview:self.backImageView];
    [self.view addSubview:self.disMissButton];
    [self.view addSubview:self.lrcTableView];
    [self.view addSubview:self.playerControlView];
}

- (void)addViewConstraints
{
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.disMissButton makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(60, 44));
        make.left.equalTo(self.view.left).offset(10);
        make.top.equalTo(self.view.top).offset(30);
    }];
    
    [self.lrcTableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top).offset(100);
        make.bottom.equalTo(self.view.bottom).offset(-150);
        make.left.right.equalTo(self.view);
    }];
    
    [self.playerControlView makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(CURRENT_VIEW_WIDTH, 120));
        make.top.equalTo(self.lrcTableView.bottom).offset(20);
        make.left.equalTo(self.view.left);
    }];
}

//逐行更新歌词
- (void)updateMusicLrcForRowWithCurrentTime:(NSTimeInterval)currentTime
{
    for (int i = 0; i < [GLMusicPlayer defaultPlayer].musicLRCArray.count; i ++) {
        GLMusicLRCModel *model = [GLMusicPlayer defaultPlayer].musicLRCArray[i];
        
        NSInteger next = i + 1;
        
        GLMusicLRCModel *nextLrcModel = nil;
        if (next < [GLMusicPlayer defaultPlayer].musicLRCArray.count) {
            nextLrcModel = [GLMusicPlayer defaultPlayer].musicLRCArray[next];
        }
        
        if (self.currentLcrIndex != i && currentTime >= model.time)
        {
            BOOL show = NO;
            if (nextLrcModel) {
                if (currentTime < nextLrcModel.time) {
                    show = YES;
                }
            }else{
                show = YES;
            }
            
            if (show) {
                NSIndexPath *currentIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
                NSIndexPath *previousIndexPath = [NSIndexPath indexPathForRow:self.currentLcrIndex inSection:0];
                
                self.currentLcrIndex = i;
                
                MusicLRCTableViewCell *currentCell = [self.lrcTableView cellForRowAtIndexPath:currentIndexPath];
                MusicLRCTableViewCell *previousCell = [self.lrcTableView cellForRowAtIndexPath:previousIndexPath];
                
                //设置当前行的状态
                [currentCell reloadCellForSelect:YES];
                //取消上一行的选中状态
                [previousCell reloadCellForSelect:NO];
    
    
                if (!self.isDrag) {
                    [self.lrcTableView scrollToRowAtIndexPath:currentIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                }
            }
        }
        
        if (self.currentLcrIndex == i) {
            MusicLRCTableViewCell *cell = [self.lrcTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            
            CGFloat totalTime = 0;
            if (nextLrcModel) {
                totalTime = nextLrcModel.time - model.time;
            }else{
                totalTime = [GLMusicPlayer defaultPlayer].duration.minute * 60 +  [GLMusicPlayer defaultPlayer].duration.second - model.time;
            }
            CGFloat progressTime = currentTime - model.time;
            cell.lrcLable.progress = progressTime / totalTime;
        }
    }
}

#pragma mark == event response
- (void)disMiss:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark == UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [GLMusicPlayer defaultPlayer].musicLRCArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MusicLRCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"musicLrc" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    cell.lrcModel = [GLMusicPlayer defaultPlayer].musicLRCArray[indexPath.row];
    
    if (indexPath.row == self.currentLcrIndex) {
        [cell reloadCellForSelect:YES];
    }else{
        [cell reloadCellForSelect:NO];
    }
    
    return cell;
}

#pragma mark == UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


#pragma mark == UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.isDrag = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    self.isDrag = NO;
    [self.lrcTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentLcrIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

#pragma mark == GLMusicPlayerDelegate
- (void)updateProgressWithCurrentPosition:(FSStreamPosition)currentPosition endPosition:(FSStreamPosition)endPosition
{
    //更新进度条
    self.playerControlView.slider.value = currentPosition.position;
    
    self.playerControlView.leftTimeLable.text = [NSString translationWithMinutes:currentPosition.minute seconds:currentPosition.second];
    self.playerControlView.rightTimeLable.text = [NSString translationWithMinutes:endPosition.minute seconds:endPosition.second];
    
    //更新歌词
    [self updateMusicLrcForRowWithCurrentTime:currentPosition.position *(endPosition.minute *60 + endPosition.second)];

    self.playerControlView.palyMusicButton.selected = [GLMusicPlayer defaultPlayer].isPause;
}

- (void)updateMusicLrc
{
    [_lrcTableView reloadData];
}

#pragma mark == 懒加载
- (UIImageView *)backImageView
{
    if (nil == _backImageView) {
        _backImageView = [[UIImageView alloc] init];
        _backImageView.image = [UIImage imageNamed:@"dahua3"];
    }
    return _backImageView;
}

- (UIButton *)disMissButton
{
    if (nil == _disMissButton) {
        _disMissButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_disMissButton setImage:[UIImage imageNamed:@"player_btn_close_normal"] forState:UIControlStateNormal];
        [_disMissButton setImage:[UIImage imageNamed:@"player_btn_close_highlight"] forState:UIControlStateHighlighted];
        [_disMissButton addTarget:self action:@selector(disMiss:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _disMissButton;
}

- (UITableView *)lrcTableView
{
    if (nil == _lrcTableView) {
        _lrcTableView = [[UITableView alloc] init];
        _lrcTableView.dataSource = (id)self;
        _lrcTableView.delegate = (id)self;
        _lrcTableView.separatorColor = [UIColor clearColor];
        _lrcTableView.tableFooterView = [[UITableView alloc] init];
        [_lrcTableView registerNib:[UINib nibWithNibName:@"MusicLRCTableViewCell" bundle:nil] forCellReuseIdentifier:@"musicLrc"];
        _lrcTableView.backgroundColor = [UIColor clearColor];
    }
    return _lrcTableView;
}

- (GLMusicPlayerControlView*)playerControlView
{
    if (nil == _playerControlView) {
        _playerControlView = [[[NSBundle mainBundle] loadNibNamed:@"GLMusicPlayerControlView" owner:nil options:nil] lastObject];
        _playerControlView.backgroundColor = [UIColor clearColor];
    }
    return _playerControlView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
