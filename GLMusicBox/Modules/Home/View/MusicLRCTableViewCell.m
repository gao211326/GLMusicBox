//
//  MusicLRCTableViewCell.m
//  GLMusicBox
//
//  Created by 高磊 on 2017/10/26.
//  Copyright © 2017年 高磊. All rights reserved.
//

#import "MusicLRCTableViewCell.h"

#import "GLMusicLrcLable.h"
#import "GLMusicLRCModel.h"
@implementation MusicLRCTableViewCell

- (void)setLrcModel:(GLMusicLRCModel *)lrcModel
{
    _lrcModel = lrcModel;
    _lrcLable.text = lrcModel.title;
}

- (void)reloadCellForSelect:(BOOL)select
{
    if (select) {
        _lrcLable.font = [UIFont systemFontOfSize:17];
    }else{
        _lrcLable.font = [UIFont systemFontOfSize:14];
        _lrcLable.progress = 0;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
