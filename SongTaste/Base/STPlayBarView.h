//
//  STPlayBarView.h
//  SongTaste
//
//  Created by William on 15/4/26.
//  Copyright (c) 2015年 dimsky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STPlayBarView : UIView
@property (nonatomic,strong) UIButton *playBtn; //播放
@property (nonatomic,strong) UIButton *preBtn;  //上一曲
@property (nonatomic,strong) UIButton *nextBtn; //下一曲
@property (nonatomic,strong) UIButton *niceBtn; //好听
@property (nonatomic,strong) UIButton *collectBtn; //收藏

@end
