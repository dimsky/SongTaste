//
//  STGlobalUtils.m
//  SongTaste
//
//  Created by William on 15/5/2.
//  Copyright (c) 2015年 dimsky. All rights reserved.
//

#import "STGlobalUtils.h"

@implementation STGlobalUtils


+ (NSString *)timeFormatted:(int)totalSeconds
{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    if (hours > 0) {
        return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
    }
    
    return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}
@end
