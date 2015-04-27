//
//  MusicNetWork.h
//  SongTaste
//
//  Created by William on 15/4/27.
//  Copyright (c) 2015年 dimsky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MusicModel.h"

@interface MusicNetWork : NSObject

+ (instancetype)sharedInstance;

- (void)recommendMusicList1WithCount:(int)count success:(void(^)(NSArray *result))successBlock failed:(void(^)(NSError *error))failedBlock;


///获取推荐音乐列表
- (void)recommendMusicListWithCount:(int)count success:(void(^)(NSArray *result))successBlock failed:(void(^)(NSError *error))failedBlock;


- (void)musicURLWithId:(int)musicId success:(void(^)(MusicModel *music))successBlock failed:(void(^)(NSError *error))failedBlock;

@end
