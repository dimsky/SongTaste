//
//  STPlayBarView.m
//  SongTaste
//
//  Created by William on 15/4/26.
//  Copyright (c) 2015年 dimsky. All rights reserved.
//

#import "STPlayBarView.h"
#import "PureLayout/PureLayout.h"

@implementation STPlayBarView


- (instancetype)init {
    self = [super init];
    if (self) {
        [self initSubviews];
    }
    
    return self;
}

- (void)initSubviews{
    
    
    
    _playBtn = [UIButton newAutoLayoutView];
    [_playBtn setTitle:@"播放" forState:UIControlStateNormal];
    [_playBtn setBackgroundColor:[UIColor greenColor]];
    [self addSubview:_playBtn];
    
    [_playBtn autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [_playBtn autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [_playBtn autoSetDimensionsToSize:CGSizeMake(60, 50)];
    
    
    _preBtn = [UIButton newAutoLayoutView];
    [_preBtn setTitle:@"上一曲" forState:UIControlStateNormal];
//    [_preBtn setBackgroundColor:[UIColor yellowColor]];
    [self addSubview:_preBtn];
    
    [_preBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:50];
    [_preBtn autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
//    [_preBtn autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [_preBtn autoSetDimensionsToSize:CGSizeMake(60, 50)];
//
    _nextBtn = [UIButton newAutoLayoutView];
    [_nextBtn setTitle:@"下一曲" forState:UIControlStateNormal];
    [self addSubview:_nextBtn];
    
    [_nextBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:50];
    [_nextBtn autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [_nextBtn autoSetDimensionsToSize:CGSizeMake(60, 50)];
    
    
    
}
@end
