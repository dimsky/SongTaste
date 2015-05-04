//
//  FMDBManager.h
//  SongTaste
//
//  Created by William on 15/5/4.
//  Copyright (c) 2015年 dimsky. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMDatabaseQueue;

@interface FMDBManager : NSObject

+ (instancetype)sharedManager;

- (FMDatabaseQueue *)databaseQueue;

@end
