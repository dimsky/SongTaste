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


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
    }
    
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initSubViews];
    }
    
    return self;
}

- (void)initSubViews {
    _titleIcon = [UIImageView newAutoLayoutView];
    [self.contentView addSubview:_titleIcon];
    [_titleIcon autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:5];
    [_titleIcon autoSetDimensionsToSize:CGSizeMake(50, 50)];
    [_titleIcon autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    _rateUNameLabel = [UILabel newAutoLayoutView];
    [self.contentView addSubview:_rateUNameLabel];
    
    _timeLabel = [UILabel newAutoLayoutView];
    [self.contentView addSubview:_timeLabel];
    
    _titleLabel = [UILabel newAutoLayoutView];
    _titleLabel.font = [UIFont boldSystemFontOfSize:12];
    _titleLabel.numberOfLines = 0;
    [self.contentView addSubview:_titleLabel];
    [_titleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:70];
    [_titleLabel autoSetDimension:ALDimensionHeight toSize:40];
    [_titleLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [_titleLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
    
    
    _niceIcon = [UIImageView newAutoLayoutView];
    [self.contentView addSubview:_niceIcon];
    
    _niceCountLabel = [UILabel newAutoLayoutView];
    [self.contentView addSubview:_niceCountLabel];
    
    
    _collectIcon = [UIImageView newAutoLayoutView];
    
    [self.contentView addSubview:_collectIcon];
    
    _collectCountLabel = [UILabel newAutoLayoutView];
    

}
- (void)awakeFromNib {
    // Initialization code
    
    
    
}

- (void)setModel:(MusicModel *)model {
    [_titleIcon sd_setImageWithURL:[NSURL URLWithString:model.UpUIcon]];
    _titleLabel.text = model.Name;

    _model = model;
}






- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
