//
//  MusicLocalModel.m
//  SongTaste
//
//  Created by William on 15/5/3.
//  Copyright (c) 2015年 dimsky. All rights reserved.
//

#import "MusicLocalModel.h"

@implementation MusicLocalModel

- (id)init {
    self = [super init];
    if (self) {
        self.Click = 0;
        self.DevType = 0;
        self.FavNum = 0;
        self.GradeNum = 0;
        self.MusicId = 0;
        self.Name = @"";
        self.RateDT = @"";
        self.RateUID = 0;
        self.RateUName = @"";
        self.Singer = @"";
        self.UpUIcon = @"";
        self.UpUName = @"";
        self.UserID = 0;
        self.localFileName = @"";
    }
    return self;
}

@end
