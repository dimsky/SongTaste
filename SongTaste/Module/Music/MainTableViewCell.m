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
#import "MusicNetWork.h"
#import "MusicDetailModel.h"

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
    _titleIcon.layer.masksToBounds =YES;
    
    _titleIcon.layer.cornerRadius =25;
    [self.contentView addSubview:_titleIcon];
    [_titleIcon autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
    [_titleIcon autoSetDimensionsToSize:CGSizeMake(50, 50)];
    [_titleIcon autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    _rateUNameLabel = [UILabel newAutoLayoutView];
    _rateUNameLabel.font = [UIFont systemFontOfSize:9];
    [self.contentView addSubview:_rateUNameLabel];
    [_rateUNameLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:70];
    [_rateUNameLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5];
    [_rateUNameLabel autoSetDimensionsToSize:CGSizeMake(100, 11)];
    
    
    _timeLabel = [UILabel newAutoLayoutView];
    _timeLabel.font = [UIFont systemFontOfSize:9];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_timeLabel];
    [_timeLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5];
    [_timeLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
    [_timeLabel autoSetDimensionsToSize:CGSizeMake(100, 11)];
    
    _titleLabel = [UILabel newAutoLayoutView];
    
    _titleLabel.font = [UIFont boldSystemFontOfSize:12];
    _titleLabel.numberOfLines = 0;
    [self.contentView addSubview:_titleLabel];
    [_titleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:70];
    [_titleLabel autoSetDimension:ALDimensionHeight toSize:40];
    [_titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10];
//    [_titleLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [_titleLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
    
    
    _niceIcon = [UIImageView newAutoLayoutView];
    [self.contentView addSubview:_niceIcon];
    
    _niceCountLabel = [UILabel newAutoLayoutView];
    _niceCountLabel.font = [UIFont systemFontOfSize:11];
    [self.contentView addSubview:_niceCountLabel];
    [_niceCountLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset: 70];
    [_niceCountLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset: 50];
    [_niceCountLabel autoSetDimensionsToSize:CGSizeMake(100, 10)];
    
    _collectIcon = [UIImageView newAutoLayoutView];
    
    [self.contentView addSubview:_collectIcon];
    
    _collectCountLabel = [UILabel newAutoLayoutView];
    _collectCountLabel.font = [UIFont systemFontOfSize:11];
    [self.contentView addSubview:_collectCountLabel];
    [_collectCountLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset: 170];
    [_collectCountLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset: 50];
    [_collectCountLabel autoSetDimensionsToSize:CGSizeMake(100, 10)];

    

}
- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setModel:(MusicModel *)model {
    [_titleIcon sd_setImageWithURL:[NSURL URLWithString:model.UpUIcon] placeholderImage:[UIImage imageNamed:@"user_pic"]];
    _titleLabel.text = model.Name;

    _timeLabel.text = model.RateDT;
    
    _rateUNameLabel.text = model.UpUName;
    
    _niceCountLabel.text = [NSString stringWithFormat:@"%d", model.GradeNum];
    
    _collectCountLabel.text = [NSString stringWithFormat:@"%d", model.FavNum];
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [[MusicNetWork sharedInstance] musicDetailWithId:model.ID success:^(MusicDetailModel *music) {
//            NSLog(@"%@", music);
//        } failed:^(NSError *error) {
//            
//        }];
//
//    });
    
    
    _model = model;
    
    
    
}






- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
