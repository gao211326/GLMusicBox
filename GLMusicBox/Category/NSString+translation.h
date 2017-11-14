//
//  NSString+translation.h
//  GLMusicBox
//
//  Created by 高磊 on 2017/10/30.
//  Copyright © 2017年 高磊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (translation)


/**
 时间转换

 @param minutes 分
 @param seconds 秒
 @return 返回 00:01格式
 */
+ (NSString *)translationWithMinutes:(unsigned)minutes seconds:(unsigned)seconds;

@end
