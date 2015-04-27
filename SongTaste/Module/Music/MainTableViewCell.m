//
//  MainTableViewCell.m
//  SongTaste
//
//  Created by William on 15/4/27.
//  Copyright (c) 2015年 dimsky. All rights reserved.
//

#import "MainTableViewCell.h"
#import "PureLayout/PureLayout.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MusicModel.h"

@interface MainTableViewCell()



@end

@implementation MainTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    _titleIcon = [UIImageView newAutoLayoutView];
    [self.contentView addSubview:_titleIcon];
    
    _rateUNameLabel = [UILabel newAutoLayoutView];
    [self.contentView addSubview:_rateUNameLabel];
    
    _timeLabel = [UILabel newAutoLayoutView];
    [self.contentView addSubview:_timeLabel];
    
    _titleLabel = [UILabel newAutoLayoutView];
    
    [self.contentView addSubview:_titleLabel];
    
    
    
    
    
}

- (void)setModel:(MusicModel *)model {
    [_titleIcon sd_setImageWithURL:[NSURL URLWithString:_model.UpUIcon]];
}






- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
