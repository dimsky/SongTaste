//
//  STLocalModel.m
//  SongTaste
//
//  Created by William on 15/5/3.
//  Copyright (c) 2015年 dimsky. All rights reserved.
//

#import "STLocalModel.h"
#import "FMDB.h"
#import <objc/runtime.h>
#import "FMDBManager.h"

@implementation STLocalModel




+ (NSString *)tableSql {
    NSString *className = [self tableName];
    NSMutableString *sql = [NSMutableString stringWithFormat:@"create table %@", className];
    NSArray *columbs = [self allColumbs];
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSString *col in columbs) {
        if ([self isColumbUniqueIndex:col]) {
            [array addObject:[NSString stringWithFormat:@"%@ UNIQUE", col]];
        }
        else {
            [array addObject:col];
        }
    }
    [sql appendFormat:@"(Id INTEGER PRIMARY KEY  AUTOINCREMENT NOT NULL,%@);", [array componentsJoinedByString:@","]];
    return sql;
}

+ (void) initTable {
    FMDatabaseQueue *queue = [[FMDBManager sharedManager] databaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        NSString *className = [self tableName];
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"select 1 from %@", className], nil];
        if ([db hadError]) {
            NSString *sql = [self tableSql];
            
            BOOL result = [db executeUpdate:sql, nil];
            if ([db hadError]) {
                NSLog(@"result %d:%@", result, [db lastErrorMessage]);
            }
        }
        [rs close];
    }];
}


- (NSString *)tableName {
    return NSStringFromClass([self class]);
}

+ (id)object {
    return [[self alloc] init];
}

+ (NSString *)tableName {
    return [[self object] tableName];
}

+ (NSMutableArray *)allColumbs {
    return [self runtimeProperties:YES baseClass:NSStringFromClass([STLocalModel class])];
}

- (NSMutableArray *)allColumbs {
    return [self runtimeProperties:YES baseClass:NSStringFromClass([STLocalModel class])];
}

+ (NSMutableArray *)runtimeProperties:(BOOL)deepCopy baseClass:(NSString *)baseClassName {
    NSMutableArray* propertyArray = [NSMutableArray array];
    
    Class clazz = [self class];
    do {
        u_int count;
        objc_property_t* properties = class_copyPropertyList(clazz, &count);
        for (int i = 0; i < count ; i++) {
            const char* propertyName = property_getName(properties[i]);
            [propertyArray addObject:[NSString  stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
        }
        free(properties);
        clazz = clazz.superclass;
        
        if (clazz == NULL || [NSStringFromClass(clazz) compare:baseClassName] == NSOrderedSame) {
            break;
        }
    } while (deepCopy);
    
    return propertyArray;
}

- (NSMutableArray *)runtimeProperties:(BOOL)deepCopy baseClass:(NSString *)baseClassName {
    NSMutableArray* propertyArray = [NSMutableArray array];
    
    Class clazz = [self class];
    do {
        u_int count;
        objc_property_t * properties = class_copyPropertyList(clazz, &count);
        for (int i = 0; i < count ; i++) {
            const char* propertyName = property_getName(properties[i]);
            [propertyArray addObject:[NSString  stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
        }
        free(properties);
        
        clazz = clazz.superclass;
        if (clazz == NULL || [NSStringFromClass(clazz) compare:baseClassName] == NSOrderedSame) {
            break;
        }
    } while (deepCopy);
    
    return propertyArray;
}

+ (BOOL)isColumbUniqueIndex:(NSString *)columb {
    return [columb isEqualToString:@"Id"];
}

- (BOOL)insert {
    __block BOOL result = NO;
    FMDatabaseQueue *_queue = [[FMDBManager sharedManager] databaseQueue];
    if (_queue) {
        [_queue inDatabase:^(FMDatabase *db) {
            NSArray      *properties = [self allColumbs];
            NSDictionary *valueDict  = [self dictionaryWithValuesForKeys:properties];
            NSMutableString *sql = [NSMutableString stringWithFormat:@"insert into %@ ", [self tableName]];
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:[properties count]];
            for (NSString *p in properties) {
                [array addObject:[NSString stringWithFormat:@":%@", p]];
            }
            [sql appendFormat:@"(%@) values (%@)",[properties componentsJoinedByString:@","], [array componentsJoinedByString:@","]];
            result = [db executeUpdate:sql withParameterDictionary:valueDict];
            if (!result) {
                NSLog(@"%@", [db lastErrorMessage]);
            }
            self.Id = [db lastInsertRowId];
        }];
    }
    return result;
}

- (BOOL)remove {
    __block BOOL result = NO;
    FMDatabaseQueue *_queue = [[FMDBManager sharedManager] databaseQueue];
    
    
    if (_queue) {
        [_queue inDatabase:^(FMDatabase *db) {
            NSString *sql = [NSString stringWithFormat:@"delete from %@ where Id = ?", [self tableName]];
            result = [db executeUpdate:sql, [NSNumber numberWithLongLong:self.Id]];
            if (!result) {
                NSLog(@"%@", [db lastErrorMessage]);
            }
        }];
    }
    return result;
}

+ (BOOL)removeAll {
    __block BOOL result = NO;
    FMDatabaseQueue *_queue = [[FMDBManager sharedManager] databaseQueue];
    if (_queue) {
        [_queue inDatabase:^(FMDatabase *db) {
            NSString *sql = [NSString stringWithFormat:@"delete from %@", [self tableName]];
            result = [db executeUpdate:sql];
            
            if (result) {
                sql = [NSString stringWithFormat:@"UPDATE sqlite_sequence SET seq=0 where name='%@'", [self tableName]];
                result = [db executeUpdate:sql];
            }
            if (!result) {
                NSLog(@"%@", [db lastErrorMessage]);
            }
        }];
    }
    return result;
}


+ (NSArray *)findObjectsByProperty:(NSString *)propertyName equalValue:(id)value {
    return [self findObjectsByProperty:propertyName equalValue:value orderBy:nil];
}

+ (NSArray *)findObjectsByProperty:(NSString *)propertyName equalValue:(id)value orderBy:(NSString *)orderByProperty {
    __block NSMutableArray *result = [NSMutableArray array];
    FMDatabaseQueue *_queue = [[FMDBManager sharedManager] databaseQueue];
    if (_queue) {
        [_queue inDatabase:^(FMDatabase *db) {
            NSMutableString *sql = [NSMutableString stringWithFormat:@"select * from %@ where %@ = ?", [self tableName], propertyName];
            if (orderByProperty && [orderByProperty length] > 0) {
                [sql appendFormat:@" order by %@", orderByProperty];
            }
            
            FMResultSet *rs = [db executeQuery:sql, value, nil];
            while ([rs next]) {
                id obj = [self object];
                [obj setValuesForKeysWithProperties:[rs resultDictionary]];
                [result addObject:obj];
            }
            if ([db hadError]){
                NSLog(@"%@", [db lastErrorMessage]);
            }
            [rs close];
        }];
    }
    return result;
}

+ (NSArray *)listAllObjects {
    __block NSMutableArray *result = [NSMutableArray array];
    FMDatabaseQueue *_queue = [[FMDBManager sharedManager] databaseQueue];
    if (_queue) {
        [_queue inDatabase:^(FMDatabase *db) {
            NSString *sql = [NSString stringWithFormat:@"select * from %@", [self tableName]];
            FMResultSet *rs = [db executeQuery:sql, nil];
            while ([rs next]) {
                id obj = [self object];
                [obj setValuesForKeysWithProperties:[rs resultDictionary]];
                [result addObject:obj];
            }
            if ([db hadError]) {
                NSLog(@"%@", [db lastErrorMessage]);
            }
            [rs close];
        }];
    }
    return result;
}


- (void)setValuesForKeysWithProperties:(NSDictionary *)keyedValues {
    NSMutableArray *allProperties = [self runtimeProperties:YES baseClass:NSStringFromClass([STLocalModel class])];
    [allProperties addObject:@"Id"];
    
    NSMutableDictionary *formatDict = [NSMutableDictionary dictionary];
    
    for (NSString *property in allProperties) {
        id value = [keyedValues objectForKey:property];
        if (value && ![value isKindOfClass:[NSNull class]]) {
            NSString *propertyAttribute = [NSString stringWithCString:property_getAttributes(class_getProperty([self class], [property UTF8String])) encoding:NSUTF8StringEncoding];
            NSArray  *attributes = [propertyAttribute componentsSeparatedByString:@","];
            if ([attributes count] > 0) {
                NSString *typeAttribute = [attributes objectAtIndex:0];
                if ([typeAttribute length] > 0) {
                    NSString *propertyType = [typeAttribute substringFromIndex:1];
                    if ([propertyType hasPrefix:@"@"] && [propertyType length] > 2) {
                        NSRange range = (NSRange){2,[propertyType length] - 3};
                        NSString *typeName = [propertyType substringWithRange:range];
                        if ([typeName isEqualToString:@"NSDate"] && ![value isKindOfClass:[NSDate class]]) {
                            [formatDict setObject:[NSDate dateWithTimeIntervalSince1970:[value longLongValue] / 1000.0] forKey:property];
                        }
                        else {
                            [formatDict setObject:value forKey:property];
                        }
                    }
                    else {
                        [formatDict setObject:value forKey:property];
                    }
                }
            }
        }
    }
    [self setValuesForKeysWithDictionary:formatDict];
}

@end
