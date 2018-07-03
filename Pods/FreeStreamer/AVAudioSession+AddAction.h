//
//  AVAudioSession+AddAction.h
//  GLMusicBox
//
//  Created by 高磊 on 2018/5/23.
//  Copyright © 2018年 高磊. All rights reserved.
//  针对Deactivating an audio session that has running I/O. All I/O should be stopped or paused prior to deactivating the audio session 该bug  强制将 .m文件中的方法返回yes

#import <AVFoundation/AVFoundation.h>

@interface AVAudioSession (AddAction)

@end
