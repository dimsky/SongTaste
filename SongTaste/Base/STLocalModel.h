//
//  STLocalModel.h
//  SongTaste
//
//  Created by William on 15/5/3.
//  Copyright (c) 2015年 dimsky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STLocalModel : NSObject 

@property (nonatomic, assign) long long Id;

+ (void) initTable ;

+ (NSArray *)listAllObjects;

- (BOOL)insert;

+ (NSArray *)findObjectsByProperty:(NSString *)propertyName equalValue:(id)value;
@end
