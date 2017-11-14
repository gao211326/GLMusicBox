//
//  GLMusicLRCModel.h
//  GLMusicBox
//
//  Created by 高磊 on 2017/10/26.
//  Copyright © 2017年 高磊. All rights reserved.
//  解析歌词的模型

#import <Foundation/Foundation.h>


@interface GLMusicLRCModel : NSObject

//该段歌词对应的时间
@property (nonatomic,assign) NSTimeInterval time;
//歌词
@property (nonatomic,strong) NSString *title;


/**
 *
 将特点的歌词格式进行转换
 *
 **/
+ (id)musicLRCWithString:(NSString *)string;

/**
 *
 根据歌词的路径返回歌词模型数组
 *
 **/
+ (NSArray <GLMusicLRCModel *>*)musicLRCModelsWithLRCFileName:(NSString *)name;

@end
