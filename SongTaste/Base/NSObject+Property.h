//
//  NSObject+Property.h
//  CalendarLib
//
//  Created by  on 12-3-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Property)
- (NSArray*)allKeys;
+ (id)customClassWithProperties:(NSDictionary *)properties;
- (id)initWithProperties:(NSDictionary *)properties;
+ (id)objectWithProperties:(NSDictionary *)properties;
- (NSDictionary*)objectProperties;
- (id)jsonObject;
@end


