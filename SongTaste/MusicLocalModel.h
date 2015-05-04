//
//  MusicLocalModel.h
//  SongTaste
//
//  Created by William on 15/5/3.
//  Copyright (c) 2015年 dimsky. All rights reserved.
//

#import "STLocalModel.h"

@interface MusicLocalModel : STLocalModel


@property(assign, nonatomic)int Click;
@property(assign, nonatomic)int DevType;
@property(assign, nonatomic)int FavNum;
@property(assign, nonatomic)int GradeNum;
@property(assign, nonatomic)int MusicId;
@property(strong, nonatomic)NSString *Name;
@property(strong, nonatomic)NSString *RateDT;
@property(assign, nonatomic)int RateUID;
@property(strong, nonatomic)NSString *RateUName;
@property(strong, nonatomic)NSString *Singer;
@property(strong, nonatomic)NSString *UpUIcon;
@property(strong, nonatomic)NSString *UpUName;
@property(assign, nonatomic)int UserID;

@property(strong, nonatomic)NSString *localFileName;
@property(assign, nonatomic)long fileSize;
@property(assign, nonatomic)long fileDuration;

@end
