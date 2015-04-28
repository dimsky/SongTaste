//
//  STNavigationController.h
//  SongTaste
//
//  Created by William on 15/4/28.
//  Copyright (c) 2015年 dimsky. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MUSICARRAY_CHANGE_NOTIFICATION @"musicArrayChangeNotification"
@class STPlayBarView;
@interface STNavigationController : UINavigationController

@property (nonatomic, strong)STPlayBarView *playBarView;

@end
