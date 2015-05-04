//
//  FMDBManager.m
//  SongTaste
//
//  Created by William on 15/5/4.
//  Copyright (c) 2015年 dimsky. All rights reserved.
//

#import "FMDBManager.h"
#import "FMDataBaseQueue.h"


static  NSString *DBName = @"SongTaste.sqlite";

@implementation FMDBManager{
    FMDatabaseQueue *queue;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [paths objectAtIndex:0];
        NSString *dbPath = [documentDirectory stringByAppendingPathComponent:DBName];
        queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    }
    return self;
}

+ (instancetype)sharedManager {
    static dispatch_once_t token = 0;
    __strong static FMDBManager *_sharedManager = nil;
    dispatch_once(&token, ^() {
        _sharedManager = [[FMDBManager alloc] init];
    });
    return _sharedManager;
}

- (FMDatabaseQueue *)databaseQueue {
    if (!queue) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [paths objectAtIndex:0];
        NSString *dbPath = [documentDirectory stringByAppendingPathComponent:DBName];
        queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];

    }
    return queue;
}



@end
