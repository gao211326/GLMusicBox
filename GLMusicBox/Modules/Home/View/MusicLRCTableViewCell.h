//
//  MusicLRCTableViewCell.h
//  GLMusicBox
//
//  Created by 高磊 on 2017/10/26.
//  Copyright © 2017年 高磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GLMusicLrcLable;
@class GLMusicLRCModel;

@interface MusicLRCTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet GLMusicLrcLable *lrcLable;

@property (nonatomic,strong) GLMusicLRCModel *lrcModel;

//是否选中该行
- (void)reloadCellForSelect:(BOOL)select;

@end
