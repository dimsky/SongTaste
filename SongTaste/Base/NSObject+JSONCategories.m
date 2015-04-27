//
//  NSObject+JSONCategories.m
//  SongTaste
//
//  Created by William on 15/4/27.
//  Copyright (c) 2015年 dimsky. All rights reserved.
//

#import "NSObject+JSONCategories.h"

@implementation NSObject (JSONCategories)


-(NSString *)JSONString;
{
    NSError* error = nil;
    id result = [NSJSONSerialization dataWithJSONObject:self
                                                options:kNilOptions error:&error];
    if (error != nil) return nil;
    NSString *str = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    return str;
}

@end
