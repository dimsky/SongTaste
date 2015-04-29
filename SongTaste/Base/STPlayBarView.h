//
//  STPlayBarView.h
//  SongTaste
//
//  Created by William on 15/4/26.
//  Copyright (c) 2015年 dimsky. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol STPlayBarViewDelegate;

@class NCMusicEngine;
@class MusicDetailModel;

@interface STPlayBarView : UIView
@property (nonatomic,strong) UIButton *playBtn; //播放
@property (nonatomic,strong) UIButton *preBtn;  //上一曲
@property (nonatomic,strong) UIButton *nextBtn; //下一曲
@property (nonatomic,strong) UIButton *niceBtn; //好听
@property (nonatomic,strong) UIButton *collectBtn; //收藏

@property (nonatomic,strong)NCMusicEngine *musicEngine;

@property (nonatomic,strong)NSArray *musicArray;

@property (nonatomic,assign)NSInteger playingIndex;

@property (nonatomic,assign) id<STPlayBarViewDelegate> delegate;

@property (nonatomic,strong)MusicDetailModel *playingMusicInfo;


+ (instancetype)sharedInstance;
- (void)playMusicWithIndex:(NSInteger)index;
///上一曲
- (void)playMusicPrev;
///下一曲
- (void)playMusicNext;
///暂停
//- (void)pauseMusic;

- (void)playAndStopMusic;

- (void)updateControlNowPlayingInfo;
@end




@protocol STPlayBarViewDelegate <NSObject>

@required
- (NSArray *)musicArrayInPlayBarView:(STPlayBarView *)playBarView;

@end

