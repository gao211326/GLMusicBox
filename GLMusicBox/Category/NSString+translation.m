//
//  NSString+translation.m
//  GLMusicBox
//
//  Created by 高磊 on 2017/10/30.
//  Copyright © 2017年 高磊. All rights reserved.
//

#import "NSString+translation.h"

@implementation NSString (translation)

+ (NSString *)translationWithMinutes:(unsigned)minutes seconds:(unsigned)seconds
{
    NSString *minutesString = @"00";
    if (minutes < 10) {
        minutesString = [NSString stringWithFormat:@"0%d",minutes];
    }else{
        minutesString = [NSString stringWithFormat:@"%d",minutes];
    }
    
    NSString *secondsString = @"00";
    if (seconds < 10) {
        secondsString = [NSString stringWithFormat:@"0%d",seconds];
    }else{
        secondsString = [NSString stringWithFormat:@"%d",seconds];
    }
    
    return [NSString stringWithFormat:@"%@:%@",minutesString,secondsString];
}

@end
