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
#import "STGlobalUtils.h"
#import "MusicLocalModel.h"
#import "YDSlider.h"


@interface STPlayBarView() <NCMusicEngineDelegate, YDSliderDelegate>

@end

@implementation STPlayBarView{
    UIImage *playBackImage;
    UIImage *playPauseImage;
    AVAudioPlayer *player;
    BOOL isLocal;
}
@synthesize  musicArray = _musicArray ;

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
        [self initObservers];
        
    }
    
    return self;
}

- (void)initSubviews{
    
    self.alpha = 0.95;
    _playInfoView = [UIView newAutoLayoutView];
    [self addSubview:_playInfoView];
    [_playInfoView setBackgroundColor:[UIColor whiteColor]];
    
    [_playInfoView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [_playInfoView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [_playInfoView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [_playInfoView autoSetDimension:ALDimensionHeight toSize:20];
    
    _progressSlider = [YDSlider newAutoLayoutView];
    _progressSlider.minimumTrackTintColor = [UIColor orangeColor];
    [_progressSlider setThumbImage:[UIImage imageNamed:@"player-progress-point"] forState:UIControlStateNormal];
    [_progressSlider setThumbImage:[UIImage imageNamed:@"player-progress-point"]  forState:UIControlStateHighlighted];
     [_progressSlider setMinimumTrackImage:[[UIImage imageNamed:@"player-progress-h"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 3, 5, 4) resizingMode:UIImageResizingModeStretch]];
    
    [_progressSlider setMiddleTrackImage:[[UIImage imageNamed:@"player-progress-loading"]resizableImageWithCapInsets:UIEdgeInsetsMake(4, 3, 5, 4) resizingMode:UIImageResizingModeStretch]];
    [_progressSlider setMaximumTrackImage:[[UIImage imageNamed:@"player-progress"]resizableImageWithCapInsets:UIEdgeInsetsMake(4, 3, 5, 4) resizingMode:UIImageResizingModeStretch]];

    [_playInfoView addSubview:_progressSlider];
    
    _progressSlider.delegate = self;
    [_progressSlider autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [_progressSlider autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [_progressSlider autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [_progressSlider autoSetDimension:ALDimensionHeight toSize:6];
    
    _downloadProgressView = [UIProgressView newAutoLayoutView];
//    _downloadProgressView.tintColor = [UIColor greenColor];
//    [_playInfoView addSubview:_downloadProgressView];
//    [_downloadProgressView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
//    [_downloadProgressView autoPinEdgeToSuperviewEdge:ALEdgeRight];
//    [_downloadProgressView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
//    [_downloadProgressView autoSetDimension:ALDimensionHeight toSize:3];
//    
    _playProgressView = [UIProgressView newAutoLayoutView];
//    _playProgressView.alpha = 0.6;
//    [_playInfoView addSubview:_playProgressView];
//    [_playProgressView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
//    [_playProgressView autoPinEdgeToSuperviewEdge:ALEdgeRight];
//    [_playProgressView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
//    [_playProgressView autoSetDimension:ALDimensionHeight toSize:3];
    
    _playingCurrentTime = [UILabel newAutoLayoutView];
    _playingCurrentTime.font = [UIFont systemFontOfSize:8];
    [_playInfoView addSubview:_playingCurrentTime];
    [_playingCurrentTime autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [_playingCurrentTime autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [_playingCurrentTime autoSetDimension:ALDimensionWidth toSize:30];
    [_playingCurrentTime autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_progressSlider];
    
    _playingDuration = [UILabel newAutoLayoutView];
    _playingDuration.font = [UIFont systemFontOfSize:8];
    _playingDuration.textAlignment = NSTextAlignmentRight;
    [_playInfoView addSubview:_playingDuration];
    [_playingDuration autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [_playingDuration autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [_playingDuration autoSetDimension:ALDimensionWidth toSize:30];
    [_playingDuration autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_progressSlider];
    
    _playInfoLabel = [UILabel newAutoLayoutView];
    _playInfoLabel.textAlignment = NSTextAlignmentCenter;
    _playInfoLabel.font = [UIFont systemFontOfSize:12];
    [_playInfoView addSubview:_playInfoLabel];
    [_playInfoLabel autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [_playInfoLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:30];
    [_playInfoLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:30];
    [_playInfoLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_progressSlider];
    
    _playControlView = [UIView newAutoLayoutView];
    [self addSubview:_playControlView];
    
    [_playControlView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [_playControlView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [_playControlView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_playInfoView];
    [_playControlView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    
    
    _playBtn = [UIButton newAutoLayoutView];
    _playBtn.tag = 1;
    [_playBtn addTarget:self action:@selector(musicAction:) forControlEvents:UIControlEventTouchUpInside];
//    [_playBtn setTitle:@"播放" forState:UIControlStateNormal];
    playBackImage = [UIImage imageNamed:@"play"];
    playPauseImage = [UIImage imageNamed:@"play_pause"];
    //[_playBtn setContentMode:UIViewContentModeScaleAspectFill];
    [_playBtn setBackgroundImage: playBackImage forState:UIControlStateNormal];
    [_playControlView addSubview:_playBtn];
    
    [_playBtn autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [_playBtn autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [_playBtn autoSetDimensionsToSize:CGSizeMake(20, 20)];
    
    
    _preBtn = [UIButton newAutoLayoutView];
    _preBtn.tag = 2;
    [_preBtn addTarget:self action:@selector(musicAction:) forControlEvents:UIControlEventTouchUpInside];
    [_preBtn setBackgroundImage:[UIImage imageNamed:@"prev"] forState:UIControlStateNormal];
    [_playControlView addSubview:_preBtn];
    
    [_preBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:50];
    [_preBtn autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [_preBtn autoSetDimensionsToSize:CGSizeMake(30, 20)];

    _nextBtn = [UIButton newAutoLayoutView];
    _nextBtn.tag = 3;
    [_nextBtn addTarget:self action:@selector(musicAction:) forControlEvents:UIControlEventTouchUpInside];
    [_nextBtn setBackgroundImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
    [_playControlView addSubview:_nextBtn];
    
    [_nextBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:50];
    [_nextBtn autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [_nextBtn autoSetDimensionsToSize:CGSizeMake(30, 20)];
    
    
    
}

- (void)initData {
    _musicEngine = [[NCMusicEngine alloc] initWithSetBackgroundPlaying:YES];
    _musicEngine.delegate = self;
    
    
//    
//    NSString *musicPath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp3"];
//    NSURL *url = [[NSURL alloc] initFileURLWithPath:musicPath];
//    
//    // 创建播放器
//    NSError *error;
//    player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
//    
//    NSLog(@"dddd%@", error);
//    [player prepareToPlay];
    
}

- (void)initObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateControlNowPlayingInfo) name:STPlayerEnterBackground object:nil];
    
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
            } else if (self.musicEngine.playState == NCMusicEnginePlayStateStopped){
                [self playMusicWithIndex:_playingIndex];
            } else {
                [self.musicEngine resume];
            }
            break;
        case 2://上一曲
            
            [self playMusicPrev];
            break;
        case 3://下一曲
            [self playMusicNext];
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

- (void)setMusicArray:(NSArray *)musicArray {
    if (musicArray && _playingMusicDetailInfo) {
        _playingIndex = [musicArray indexOfObject:_playingMusicDetailInfo];
    }
    _musicArray = musicArray;
}



- (void)playMusicWithURLStr:(NSString *)URLStr{
    _playingMusicURL = [NSURL URLWithString:URLStr];
    [self.musicEngine playUrl:_playingMusicURL];
    
}

- (void)playMusicWithLocalName:(NSString *)localName{

    [self.musicEngine playLocalMusicWithName:localName];
}


- (void)playMusicWithIndex:(NSInteger)index{
    _playingIndex = index;
    if (self.musicArray.count > 0) {
        if (!_playingIndex) {
            _playingIndex = 0;
        }
        _playingMusicInfo = self.musicArray[_playingIndex];
        
        NSArray *array = [MusicLocalModel findObjectsByProperty:@"MusicId" equalValue:@(_playingMusicInfo.ID)];
        //是否播放本地文件
        if (array.count > 0) {
            isLocal = YES;
            MusicLocalModel *localModel = array[0];
            [self playMusicWithLocalName:localModel.localFileName];
            _downloadProgressView.progress = 1;
        } else {
            __weak typeof(self) weakSelf = self;
            [[MusicNetWork sharedInstance] musicDetailWithId:_playingMusicInfo.ID success:^(MusicDetailModel *musicDetail) {
                self.playingMusicDetailInfo = musicDetail;
                [self updateControlNowPlayingInfo];
                [weakSelf playMusicWithURLStr:musicDetail.url];
                isLocal = NO;
            } failed:^(NSError *error) {
                
            }];
        }
       
        
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
    if (!_playingMusicDetailInfo) {
        return;
    }
    NSMutableDictionary *dict = nil;
    if ([[MPNowPlayingInfoCenter defaultCenter] nowPlayingInfo]) {
        
        dict = [NSMutableDictionary dictionaryWithDictionary:[[MPNowPlayingInfoCenter defaultCenter] nowPlayingInfo]];
    } else {
        dict = [[NSMutableDictionary alloc] init];
    }
    
    [dict setObject:_playingMusicDetailInfo.song_name forKey:MPMediaItemPropertyTitle];
    [dict setObject:_playingMusicDetailInfo.singer_name  forKey:MPMediaItemPropertyArtist];
    [dict setObject:[NSNumber numberWithDouble:self.musicEngine.player.currentTime] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    if (self.musicEngine.playState == NCMusicEnginePlayStatePlaying) {
         [dict setObject:[NSNumber numberWithFloat:1.0] forKey:MPNowPlayingInfoPropertyPlaybackRate];
    } else {
         [dict setObject:[NSNumber numberWithFloat:0.0] forKey:MPNowPlayingInfoPropertyPlaybackRate];
    }

    [dict setObject:[NSNumber numberWithLong:_playingMusicDetailInfo.Mlength] forKey:MPMediaItemPropertyPlaybackDuration];
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];

}

#pragma mark NCMusicEngineDelegate

- (void)engine:(NCMusicEngine *)engine didChangePlayState:(NCMusicEnginePlayState)playState {
    [self updateControlNowPlayingInfo];
    _playInfoLabel.text = self.playingMusicDetailInfo.song_name;
    switch (engine.playState) {
        case NCMusicEnginePlayStatePlaying:
            NSLog(@"开始播放");
            [_playBtn setBackgroundImage:playPauseImage forState:UIControlStateNormal];
            break;
        case NCMusicEnginePlayStateEnded:
            NSLog(@"播放结束");
            [_playBtn setBackgroundImage:playBackImage forState:UIControlStateNormal];
            break;
        case NCMusicEnginePlayStatePaused:
            NSLog(@"暂停播放");
            [_playBtn setBackgroundImage:playBackImage forState:UIControlStateNormal];
            break;
        case NCMusicEnginePlayStateStopped:
            NSLog(@"停止");
            [_playBtn setBackgroundImage:playBackImage forState:UIControlStateNormal];
            break;
        case NCMusicEnginePlayStateError:
            NSLog(@"播放错误");
            [_playBtn setBackgroundImage:playBackImage forState:UIControlStateNormal];
//            [self playMusicNext];
            break;
  
        default:
            break;
    }
    
}
- (void)engine:(NCMusicEngine *)engine didChangeDownloadState:(NCMusicEngineDownloadState)downloadState{
    if (downloadState == NCMusicEngineDownloadStateDownloaded) {

        NSArray *array = [MusicLocalModel findObjectsByProperty:@"MusicId" equalValue:@(_playingMusicInfo.ID)];
        if (array.count == 0) {
            MusicLocalModel *localModel = [[MusicLocalModel alloc] init];

            localModel.MusicId = _playingMusicInfo.ID;
            localModel.Name = _playingMusicInfo.Name;
            localModel.Click = _playingMusicInfo.Click;
            localModel.DevType = _playingMusicInfo.DevType;
            localModel.FavNum = _playingMusicInfo.FavNum;
            localModel.GradeNum = _playingMusicInfo.GradeNum;
            localModel.RateDT = _playingMusicInfo.RateDT;
            localModel.RateUID = _playingMusicInfo.RateUID;
            localModel.RateUName = _playingMusicInfo.RateUName;
            localModel.Singer = _playingMusicInfo.Singer;
            localModel.UpUIcon = _playingMusicInfo.UpUIcon;
            localModel.UpUName = _playingMusicInfo.UpUName;
            localModel.UserID = _playingMusicInfo.UserID;
            
            NSString *musicUrl =  _playingMusicDetailInfo.url;
            
            NSString *cacheKey = [engine cacheKeyFromUrl:_playingMusicURL];
            NSString *localFileName = [NSString stringWithFormat:@"%@.%@", cacheKey, musicUrl.pathExtension];
            localModel.localFileName = localFileName;
            localModel.fileSize =  engine.fileSize;
            localModel.fileDuration = engine.player.duration;
            [localModel insert];
            NSLog(@"插入成功");
        }
        NSLog(@"下载完成 %ld" ,        engine.fileSize);
    } else if (downloadState == NCMusicEngineDownloadStateDownloading){
        NSLog(@"下载中");
    } else if (downloadState == NCMusicEngineDownloadStateError) {
        NSLog(@"下载错误");
    } else {
        NSLog( @"没有下载");
    }
}
- (void)engine:(NCMusicEngine *)engine downloadProgress:(CGFloat)progress{
    if (!isLocal) {
//        _downloadProgressView.progress = progress;
        _progressSlider.middleValue = progress;
    }
    
}

- (void)engine:(NCMusicEngine *)engine playProgress:(CGFloat)progress{
//    _playProgressView.progress = progress;
    
    _playingCurrentTime.text =  [STGlobalUtils timeFormatted: engine.player.currentTime];
    _playingDuration.text = [STGlobalUtils timeFormatted:engine.player.duration];
    _progressSlider.value = engine.player.currentTime;
    _progressSlider.maximumValue = engine.player.duration;
    
    if (progress == 1.0) {
        
        UIBackgroundTaskIdentifier bgTask = 0;
        
        if([UIApplication sharedApplication].applicationState== UIApplicationStateBackground) {
            
            NSLog(@"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx后台播放");
            
            [self playMusicNext];
            
            UIApplication*app = [UIApplication sharedApplication];
            
            UIBackgroundTaskIdentifier newTask = [app beginBackgroundTaskWithExpirationHandler:nil];
            
            if(bgTask!= UIBackgroundTaskInvalid) {
                
                [app endBackgroundTask: bgTask];
                
            }
            
            bgTask = newTask;
            
        } else {
            NSLog(@"前台播放");
            [self playMusicNext];
            
        }
    }
}


-(void)sliderChanging:(YDSlider *)slider {
    if ([self.musicEngine.player isPlaying]) {
        [self.musicEngine pause];
    }
    _playingCurrentTime.text =  [STGlobalUtils timeFormatted: slider.value];
}

-(void)sliderChanged:(YDSlider *)slider {
        NSLog(@"changed");
    [self.musicEngine.player setCurrentTime:slider.value];
    [self.musicEngine resume];
   
}




@end
