//
//  STPlayBarView.m
//  SongTaste
//
//  Created by William on 15/4/26.
//  Copyright (c) 2015年 dimsky. All rights reserved.
//

#import "STPlayBarView.h"
#import "PureLayout/PureLayout.h"
#import "NCMusicEngine.h"
#import "MusicDetailModel.h"
#import "MusicModel.h"
#import "MusicNetWork.h"
#import "MediaPlayer/MediaPlayer.h"
#import "AVFoundation/AVFoundation.h"


@interface STPlayBarView() <NCMusicEngineDelegate>

@end

@implementation STPlayBarView



+ (instancetype)sharedInstance {
    __strong static STPlayBarView *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[STPlayBarView alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initSubviews];
        [self initData];
        self.alpha = 0.8;
    }
    
    return self;
}

- (void)initSubviews{
    
    _playBtn = [UIButton newAutoLayoutView];
    _playBtn.tag = 1;
    [_playBtn addTarget:self action:@selector(musicAction:) forControlEvents:UIControlEventTouchUpInside];
    [_playBtn setTitle:@"播放" forState:UIControlStateNormal];
    [_playBtn setBackgroundColor:[UIColor greenColor]];
    [self addSubview:_playBtn];
    
    [_playBtn autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [_playBtn autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [_playBtn autoSetDimensionsToSize:CGSizeMake(60, 50)];
    
    
    _preBtn = [UIButton newAutoLayoutView];
    _preBtn.tag = 2;
    [_preBtn addTarget:self action:@selector(musicAction:) forControlEvents:UIControlEventTouchUpInside];
    [_preBtn setTitle:@"上一曲" forState:UIControlStateNormal];
//    [_preBtn setBackgroundColor:[UIColor yellowColor]];
    [self addSubview:_preBtn];
    
    [_preBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:50];
    [_preBtn autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
//    [_preBtn autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [_preBtn autoSetDimensionsToSize:CGSizeMake(60, 50)];
//
    _nextBtn = [UIButton newAutoLayoutView];
    _nextBtn.tag = 3;
    [_nextBtn addTarget:self action:@selector(musicAction:) forControlEvents:UIControlEventTouchUpInside];
    [_nextBtn setTitle:@"下一曲" forState:UIControlStateNormal];
    [self addSubview:_nextBtn];
    
    [_nextBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:50];
    [_nextBtn autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [_nextBtn autoSetDimensionsToSize:CGSizeMake(60, 50)];
    
}

- (void)initData {
    _musicEngine = [[NCMusicEngine alloc] initWithSetBackgroundPlaying:YES];
    _musicEngine.delegate = self;
}



#pragma private Action

- (void)musicAction:(UIButton *)sender {
    if (self.musicArray.count == 0) {
        return ;
    }
    
    switch (sender.tag) {
        case 1://播放
            if (self.musicEngine.playState == NCMusicEnginePlayStatePlaying) {
                [self.musicEngine pause];
                [_playBtn setTitle:@"播放" forState:UIControlStateNormal];
            } else if (self.musicEngine.playState == NCMusicEnginePlayStateStopped){
                [self playMusicWithIndex:_playingIndex];
                [_playBtn setTitle:@"暂停" forState:UIControlStateNormal];
            } else {
                [self.musicEngine resume];
                [_playBtn setTitle:@"暂停" forState:UIControlStateNormal];
            }
            break;
        case 2://上一曲
            
            --_playingIndex;
            if (_playingIndex == - 1) {
                _playingIndex = (int)(self.musicArray.count - 1);
            }

            [self playMusicWithIndex:_playingIndex];

            break;
        case 3://下一曲
            ++_playingIndex;
            if (_playingIndex == self.musicArray.count) {
                _playingIndex = 0;
            }
            [self playMusicWithIndex:_playingIndex];
            break;
        default:
            break;
    }
}

#pragma private method

- (NSArray *)musicArray {
    if (self.delegate) {
        _musicArray = [self.delegate musicArrayInPlayBarView:self];

    }
    return _musicArray;
}

- (void)playMusicWithURLStr:(NSString *)URLStr{
    [self.musicEngine playUrl:[NSURL URLWithString:URLStr]];
    
}


- (void)playMusicWithIndex:(NSInteger)index{
    _playingIndex = index;
    if (self.musicArray.count > 0) {
        if (!_playingIndex) {
            _playingIndex = 0;
        }
        MusicModel *music = self.musicArray[_playingIndex];
        __weak typeof(self) weakSelf = self;
        [[MusicNetWork sharedInstance] musicDetailWithId:music.ID success:^(MusicDetailModel *musicDetail) {
            self.playingMusicInfo = musicDetail;
            [weakSelf playMusicWithURLStr:musicDetail.url];
            [self updateControlNowPlayingInfo];
            [_playBtn setTitle:@"暂停" forState:UIControlStateNormal];
            
        } failed:^(NSError *error) {
            
        }];
    } else {
        
    }
}

///上一曲
- (void)playMusicPrev{
    --_playingIndex;
    if (_playingIndex == - 1) {
        _playingIndex = (int)(self.musicArray.count - 1);
    }
    
    [self playMusicWithIndex:_playingIndex];
    

}

///下一曲
- (void)playMusicNext{
    ++_playingIndex;
    if (_playingIndex == self.musicArray.count) {
        _playingIndex = 0;
    }
    [self playMusicWithIndex:_playingIndex];

}

///暂停
- (void)playAndStopMusic {
    if (self.musicEngine.playState == NCMusicEnginePlayStatePlaying) {
        [self.musicEngine pause];
    } else if (self.musicEngine.playState == NCMusicEnginePlayStatePaused){
        [self.musicEngine resume];
    } else {
        if (_musicArray.count > 0) {
            [self playMusicWithIndex:0];
        }
    }
    
}

- (void)updateControlNowPlayingInfo {
    if (!_playingMusicInfo) {
        return;
    }
    NSMutableDictionary *dict = nil;
    if ([[MPNowPlayingInfoCenter defaultCenter] nowPlayingInfo]) {
        
        dict = [NSMutableDictionary dictionaryWithDictionary:[[MPNowPlayingInfoCenter defaultCenter] nowPlayingInfo]];
    } else {
        dict = [[NSMutableDictionary alloc] init];
    }
    
    [dict setObject:_playingMusicInfo.song_name forKey:MPMediaItemPropertyTitle];
    [dict setObject:_playingMusicInfo.singer_name  forKey:MPMediaItemPropertyArtist];
    [dict setObject:[NSNumber numberWithDouble:self.musicEngine.player.currentTime] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    if (self.musicEngine.playState == NCMusicEnginePlayStatePlaying) {
         [dict setObject:[NSNumber numberWithFloat:1.0] forKey:MPNowPlayingInfoPropertyPlaybackRate];
    } else {
         [dict setObject:[NSNumber numberWithFloat:0.0] forKey:MPNowPlayingInfoPropertyPlaybackRate];
    }
//    [dict setObject:[NSNumber numberWithFloat:1.0] forKey:MPNowPlayingInfoPropertyPlaybackRate];
    [dict setObject:[NSNumber numberWithLong:_playingMusicInfo.Mlength] forKey:MPMediaItemPropertyPlaybackDuration];
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:nil];
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];

}


#pragma mark NCMusicEngineDelegate

- (void)engine:(NCMusicEngine *)engine didChangePlayState:(NCMusicEnginePlayState)playState {
    [self updateControlNowPlayingInfo];
    
}
- (void)engine:(NCMusicEngine *)engine didChangeDownloadState:(NCMusicEngineDownloadState)downloadState{
    
}
- (void)engine:(NCMusicEngine *)engine downloadProgress:(CGFloat)progress{
    
    
    
    
}
- (void)engine:(NCMusicEngine *)engine playProgress:(CGFloat)progress{
    if (progress == 1.0) {
        [self playMusicNext];
    }
}




@end
