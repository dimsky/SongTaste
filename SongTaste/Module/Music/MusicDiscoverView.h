//
//  MusicDiscoverView.h
//  SongTaste
//
//  Created by William on 15/5/2.
//  Copyright (c) 2015年 dimsky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STPlayBarView;
@interface MusicDiscoverView : UIView

@property (nonatomic, strong)UIImageView *backgroundImageView;
@property (nonatomic, strong)UIView *headerView;
@property (nonatomic, strong)UITableView *mainTableView;
@property (nonatomic, strong)STPlayBarView *playBarView;


@property (nonatomic, strong)NSArray *musicArray;

@end
