//
//  MainTableViewCell.h
//  SongTaste
//
//  Created by William on 15/4/27.
//  Copyright (c) 2015年 dimsky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MusicModel;
@class MusicDetailModel;
@interface MainTableViewCell : UITableViewCell

@property (strong, nonatomic)UIImageView *titleIcon;

@property (strong, nonatomic)UILabel *titleLabel;

@property (strong, nonatomic)UILabel *timeLabel;

@property (strong, nonatomic)UILabel *rateUNameLabel;

@property (strong, nonatomic)UIImageView *niceIcon;

@property (strong, nonatomic)UILabel *niceCountLabel;

@property (strong, nonatomic)UIImageView *collectIcon;

@property (strong, nonatomic)UILabel *collectCountLabel;

@property (strong, nonatomic)MusicModel *model;

@property (weak, nonatomic)MusicDetailModel *detailModel;

@end
