//
//  STPlayBarView.h
//  SongTaste
//
//  Created by William on 15/4/26.
//  Copyright (c) 2015年 dimsky. All rights reserved.
//

#import <UIKit/UIKit.h>



#define STPlayerEnterBackground @"STPlayerEnterBackground"

@protocol STPlayBarViewDelegate;

@class NCMusicEngine;
@class MusicDetailModel;
@class MusicModel;
@class YDSlider;
@interface STPlayBarView : UIView

///播放控制
@property (nonatomic,strong) UIView *playControlView;
@property (nonatomic,strong) UIButton *playBtn; //播放
@property (nonatomic,strong) UIButton *preBtn;  //上一曲
@property (nonatomic,strong) UIButton *nextBtn; //下一曲
@property (nonatomic,strong) UIButton *niceBtn; //好听
@property (nonatomic,strong) UIButton *collectBtn; //收藏
@property (nonatomic,strong) UIButton *playArrayBtn; //打开播放列表
@property (nonatomic,strong) UIView *playArrayView; //正在播放列表


///播放信息
@property (nonatomic,strong) UIView *playInfoView;
@property (nonatomic, strong) YDSlider *progressSlider;
@property (nonatomic,strong) UIProgressView *playProgressView; //播放进度
@property (nonatomic,strong) UIProgressView *downloadProgressView; //下载进度
@property (nonatomic,strong) UILabel *playingCurrentTime; // 当前播放时间
@property (nonatomic,strong) UILabel *playingDuration; //歌曲总时间
@property (nonatomic,strong) UILabel *playInfoLabel; //播放歌曲信息


///
@property (nonatomic,strong)MusicDetailModel *playingMusicDetailInfo;
@property (nonatomic,strong)MusicModel *playingMusicInfo;
@property (nonatomic, strong)NSURL *playingMusicURL;
@property (nonatomic,strong)NCMusicEngine *musicEngine;

@property (nonatomic,strong)NSArray *musicArray;
@property (nonatomic,assign)NSInteger playingIndex;


@property (nonatomic,assign) id<STPlayBarViewDelegate> delegate;


+ (instancetype)sharedInstance;

- (void)playMusicWithIndex:(NSInteger)index;

///上一曲
- (void)playMusicPrev;

///下一曲
- (void)playMusicNext;

///播放或暂停
- (void)playAndStopMusic;

@end




@protocol STPlayBarViewDelegate <NSObject>

@required
- (NSArray *)musicArrayInPlayBarView:(STPlayBarView *)playBarView;

@end

