//
//  GLMusicLRCModel.m
//  GLMusicBox
//
//  Created by 高磊 on 2017/10/26.
//  Copyright © 2017年 高磊. All rights reserved.
//

#import "GLMusicLRCModel.h"

@implementation GLMusicLRCModel

+(id)musicLRCWithString:(NSString *)string
{
    GLMusicLRCModel *model = [[GLMusicLRCModel alloc] init];
    NSArray *lrcLines =[string componentsSeparatedByString:@"]"];
    if (lrcLines.count == 2) {
        model.title = lrcLines[1];
        NSString *timeString = lrcLines[0];
        timeString = [timeString stringByReplacingOccurrencesOfString:@"[" withString:@""];
        timeString = [timeString stringByReplacingOccurrencesOfString:@"]" withString:@""];
        NSArray *times = [timeString componentsSeparatedByString:@":"];
        if (times.count == 2) {
            NSTimeInterval time = [times[0] integerValue]*60 + [times[1] floatValue];
            model.time = time;
        }
    }else if(lrcLines.count == 1){
        
    }
    
    return model;
}


+(NSArray <GLMusicLRCModel *>*)musicLRCModelsWithLRCFileName:(NSString *)name
{
    NSString *lrcPath = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSString *lrcString = [NSString stringWithContentsOfFile:lrcPath encoding:NSUTF8StringEncoding error:nil];
    NSArray *lrcLines = [lrcString componentsSeparatedByString:@"\n"];

    NSMutableArray *lrcModels = [NSMutableArray array];
    for (NSString *lrcLineString in lrcLines) {

        if ([lrcLineString hasPrefix:@"[ti"] || [lrcLineString hasPrefix:@"[ar"] || [lrcLineString hasPrefix:@"[al"] || ![lrcLineString hasPrefix:@"["]) {
            continue;
        }
        GLMusicLRCModel *lrcModel = [GLMusicLRCModel musicLRCWithString:lrcLineString];
        [lrcModels addObject:lrcModel];
    }
    return lrcModels;
}

@end
