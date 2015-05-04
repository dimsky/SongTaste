//
//  NCMusicEngine.m
//  NCMusicEngine
//
//  Created by nickcheng on 12-12-2.
//  Copyright (c) 2012年 NC. All rights reserved.
//

#import "NCMusicEngine.h"
#import "AFDownloadRequestOperation.h"
#import <AVFoundation/AVFoundation.h>
//#import "Mp3PlayerButton.h"


#define DDLogInfo

@interface NCMusicEngine () <AVAudioPlayerDelegate>
@property (nonatomic, assign, readwrite) NCMusicEnginePlayState playState;
@property (nonatomic, assign, readwrite) NCMusicEngineDownloadState downloadState;
@property (nonatomic, strong, readwrite) NSError *error;
@property (nonatomic, strong) AFDownloadRequestOperation *operation;
@property (nonatomic, assign) BOOL _pausedByUser;

- (void)playLocalFile;

@end

@implementation NCMusicEngine {
    NSString *_localFilePath;
    NSTimer *_playCheckingTimer;
}

@synthesize operation = _operation;
@synthesize player = _player;
@synthesize playState = _playState;
@synthesize downloadState = _downloadState;
@synthesize error = _error;
@synthesize delegate;
@synthesize _pausedByUser;

#pragma mark -
#pragma mark Init

- (id)init {
    return [self initWithSetBackgroundPlaying:YES];
}


- (id)initWithSetBackgroundPlaying:(BOOL)setBGPlay {
    //
	if((self = [super init]) == nil) return nil;
    
    // Custom initialization
    _playState = NCMusicEnginePlayStateStopped;
    _downloadState = NCMusicEngineDownloadStateNotDownloaded;
    _pausedByUser = NO;
    
    //
    if (setBGPlay) {
        //后台播放
        [[AVAudioSession sharedInstance] setActive: YES error: nil];
        NSError *error = nil;
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    }
    
    //
    [[NSNotificationCenter defaultCenter] addObserverForName:AFNetworkingOperationDidStartNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                      NSLog(@"Operation Started: %@", [note object]);
                                                  }];
    return self;
}

#pragma mark -
#pragma mark Public Methods

- (void)playUrl:(NSURL*)url {
    NSString *cacheKey = [self cacheKeyFromUrl:url];
    [self playUrl:url withCacheKey:cacheKey];
}

- (void)playUrl:(NSURL *)url withCacheKey:(NSString *)cacheKey {
    //
    _fileSize = 0;
    self.downloadState = NCMusicEngineDownloadStateNotDownloaded;
    self.playState = NCMusicEnginePlayStateStopped;
    if (self.player) {
        [self.player stop];
        self.player = nil;
    }
    
    //
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSString *localFileName = [NSString stringWithFormat:@"%@.%@", cacheKey, url.pathExtension];
    NSString *localFilePath = [[[self class] cacheFolder] stringByAppendingPathComponent:localFileName];
    
    _localFilePath = localFilePath;
    
    //
    //  NSLog(@"Target: %@", _localFilePath);
    if (self.operation) {
        if (!self.operation.isCancelled) [self.operation cancel];
        self.operation = nil;
    }
    

    self.operation = [[AFDownloadRequestOperation alloc] initWithRequest:request fileIdentifier:nil targetPath:_localFilePath shouldResume:YES useTempFile:NO];
//    __typeof(&*self) __weak weakSelf = self;
    
//    __weak typeof(self) weakSelf = self;
//    __weak NSString *aa = @"";
    __block  __typeof(self) weakSelf = self;
    [self.operation setProgressiveDownloadProgressBlock:^(AFDownloadRequestOperation *ro, NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpected, long long totalBytesReadForFile, long long totalBytesExpectedToReadForFile) {
        //
#ifdef DDLogInfo
        DDLogInfo(@"[NCMusicEngine] Download Progress: %u, %lld, %lld, %lld, %lld",
                  bytesRead, totalBytesRead, totalBytesExpected, totalBytesReadForFile, totalBytesExpectedToReadForFile);
#else
        NSLog(@"[NCMusicEngine] Download Progress: %ld, %lld, %lld, %lld, %lld",
              bytesRead, totalBytesRead, totalBytesExpected, totalBytesReadForFile, totalBytesExpectedToReadForFile);
#endif
        //
        if (weakSelf.fileSize == 0) {
            weakSelf.fileSize = totalBytesExpectedToReadForFile;
        }
        if (weakSelf.delegate &&
            [weakSelf.delegate conformsToProtocol:@protocol(NCMusicEngineDelegate)] &&
            [weakSelf.delegate respondsToSelector:@selector(engine:downloadProgress:)]) {
            CGFloat p = (CGFloat)totalBytesReadForFile / (CGFloat)totalBytesExpectedToReadForFile;
            if (p > 1) p = 1;
            [weakSelf.delegate engine:weakSelf downloadProgress:p];
        }
        
        //
        if (weakSelf.downloadState != NCMusicEngineDownloadStateDownloading)
            weakSelf.downloadState = NCMusicEngineDownloadStateDownloading;
        
        //
        if (weakSelf.playState == NCMusicEnginePlayStatePaused) {
            NSTimeInterval playerCurrentTime = weakSelf.player.currentTime;
            NSTimeInterval playerDuration = weakSelf.player.duration;
            if (playerDuration - playerCurrentTime >= kNCMusicEnginePlayMargin && !weakSelf._pausedByUser)
                [weakSelf playLocalFile];
        }
        
        //
        if (totalBytesReadForFile > kNCMusicEngineSizeBuffer && !weakSelf.player) {
            [weakSelf playLocalFile];
        }
    }];
    
    [self.operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //
#ifdef DDLogInfo
        DDLogInfo(@"[NCMusicEngine] Music file downloaded successful.");
#else
        NSLog(@"[NCMusicEngine] Music file downloaded successful.");
#endif
        
        //
        if (weakSelf.delegate &&
            [weakSelf.delegate conformsToProtocol:@protocol(NCMusicEngineDelegate)] &&
            [weakSelf.delegate respondsToSelector:@selector(engine:downloadProgress:)]) {
            [weakSelf.delegate engine:weakSelf downloadProgress:1];
        }
        
        //
        weakSelf.downloadState = NCMusicEngineDownloadStateDownloaded;
        
        //
        if (weakSelf.playState != NCMusicEnginePlayStatePaused || !weakSelf._pausedByUser)
            [weakSelf playLocalFile];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
#ifdef DDLogError
        DDLogError(@"[NCMusicEngine] Music file download error: %@", error);
#else
        NSLog(@"[NCMusicEngine] Music file download error: %@", error);
#endif
        
        //
        if (error.code != -999) {
            weakSelf.error = error;
            weakSelf.downloadState = NCMusicEngineDownloadStateError;
            weakSelf.playState = NCMusicEnginePlayStateError;
        }
    }];
    
    [self.operation start];
//    [self.button setBackgroundImage:button.pauseImage forState:UIControlStateNormal];
}

- (void)pause {
    if (self.player && self.player.isPlaying) {
        [self.player pause];
//        [self.button setBackgroundImage:button.playImage forState:UIControlStateNormal];
        _pausedByUser = YES;
        self.playState = NCMusicEnginePlayStatePaused;
        [_playCheckingTimer invalidate];
    }
}

- (void)resume {
    if (self.player && !self.player.isPlaying) {
        [self.player play];
//        [self.button setBackgroundImage:button.pauseImage forState:UIControlStateNormal];
        self.playState = NCMusicEnginePlayStatePlaying;
        [self startPlayCheckingTimer];
    }
}

// Stop music and stop download.
- (void)stop {
//    [self.button setProgress:0.0];
    if (self.player) {
        [self.player stop];
//        [self.button setBackgroundImage:button.playImage forState:UIControlStateNormal];
        self.playState = NCMusicEnginePlayStateStopped;
        [_playCheckingTimer invalidate];
    }
    if (self.operation && !self.operation.isCancelled)
        [self.operation cancel];
}

#pragma mark -
#pragma mark Private

- (void)handlePlayCheckingTimer:(NSTimer *)timer {
    //
    NSTimeInterval playerCurrentTime = self.player.currentTime;
    NSTimeInterval playerDuration = self.player.duration;
#ifdef DDLogInfo
    DDLogInfo(@"[NCMusicEngine] Music playing progress: %f / %f", playerCurrentTime, playerDuration);
#else
//    NSLog(@"[NCMusicEngine] Music playing progress: %f / %f", playerCurrentTime, playerDuration);
#endif
    
//    [self.button setProgress:playerCurrentTime/playerDuration];

    if (self.delegate &&
        [self.delegate conformsToProtocol:@protocol(NCMusicEngineDelegate)] &&
        [self.delegate respondsToSelector:@selector(engine:playProgress:)]) {
        if (playerDuration <= 0)
            [self.delegate engine:self playProgress:0];
        else
            [self.delegate engine:self playProgress:playerCurrentTime / playerDuration];
    }
    
    //
    if (playerDuration - playerCurrentTime < kNCMusicEnginePauseMargin && self.downloadState != NCMusicEngineDownloadStateDownloaded && self.downloadState != NCMusicEngineDownloadStateError) {
        [self pause];
        _pausedByUser = NO;
    }
}


- (void)playLocalMusicWithName:(NSString *)name {
    if (self.player) {
        [self.player stop];
        self.player = nil;
    }
    
    if (!self.player) {
        NSString *localFilePath = [[[self class] cacheFolder] stringByAppendingPathComponent:name];
        NSURL *musicUrl = [[NSURL alloc] initFileURLWithPath:localFilePath isDirectory:NO];
        NSError *error = nil;
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:musicUrl error:&error];
        self.player.delegate = self;
        if (error) {
#ifdef DDLogError
            DDLogError(@"[NCMusicEngine] AVAudioPlayer initial error: %@", error);
#else
            NSLog(@"[NCMusicEngine] AVAudioPlayer initial error: %@", error);
#endif
            self.error = error;
            self.playState = NCMusicEnginePlayStateError;
        }
    }
    //
 
    if (self.player) {
        if (!self.player.isPlaying) {
            //
            if ([self.player prepareToPlay]) NSLog(@"prepareToPlay");
            if ([self.player play]) NSLog(@"play");
            
            //
            self.playState = NCMusicEnginePlayStatePlaying;
            
            //
            [self startPlayCheckingTimer];
        }
    }
}
- (void)playLocalFileWithPath:(NSString *)path {
    //
    if (!self.player) {
        NSURL *musicUrl = [[NSURL alloc] initFileURLWithPath:path isDirectory:NO];
        NSError *error = nil;
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:musicUrl error:&error];
        self.player.delegate = self;
        if (error) {
#ifdef DDLogError
            DDLogError(@"[NCMusicEngine] AVAudioPlayer initial error: %@", error);
#else
            NSLog(@"[NCMusicEngine] AVAudioPlayer initial error: %@", error);
#endif
            self.error = error;
            self.playState = NCMusicEnginePlayStateError;
        }
    }
    //
    if (self.player) {
        if (!self.player.isPlaying) {
            //
            if ([self.player prepareToPlay]) NSLog(@"prepareToPlay");
            if ([self.player play]) NSLog(@"play");
            
            //
            self.playState = NCMusicEnginePlayStatePlaying;
            
            //
            [self startPlayCheckingTimer];
        }
    }
}

- (void)playLocalFile {
    //
    if (!self.player) {
        NSURL *musicUrl = [[NSURL alloc] initFileURLWithPath:_localFilePath isDirectory:NO];
        NSError *error = nil;
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:musicUrl error:&error];
        self.player.delegate = self;
        if (error) {
#ifdef DDLogError
            DDLogError(@"[NCMusicEngine] AVAudioPlayer initial error: %@", error);
#else
            NSLog(@"[NCMusicEngine] AVAudioPlayer initial error: %@", error);
#endif
            self.error = error;
            self.playState = NCMusicEnginePlayStateError;
        }
    }
    //
    if (self.player) {
        if (!self.player.isPlaying) {
            //
            if ([self.player prepareToPlay]) NSLog(@"prepareToPlay");
            if ([self.player play]) NSLog(@"play");
            
            //
            self.playState = NCMusicEnginePlayStatePlaying;
            
            //
            [self startPlayCheckingTimer];
        }
    }
}

- (void)startPlayCheckingTimer {
    //
    if (_playCheckingTimer) {
        [_playCheckingTimer invalidate];
        _playCheckingTimer = nil;
    }
    _playCheckingTimer = [NSTimer scheduledTimerWithTimeInterval:kNCMusicEngineCheckMusicInterval
                                                          target:self
                                                        selector:@selector(handlePlayCheckingTimer:)
                                                        userInfo:nil
                                                         repeats:YES];
}

- (NSString *)cacheKeyFromUrl:(NSURL *)url {
    NSString *key = [NSString stringWithFormat:@"%lx", url.absoluteString.hash];
    return key;
}

- (void)setPlayState:(NCMusicEnginePlayState)playState {
    _playState = playState;
    if (self.delegate &&
        [self.delegate conformsToProtocol:@protocol(NCMusicEngineDelegate)] &&
        [self.delegate respondsToSelector:@selector(engine:didChangePlayState:)])
        [self.delegate engine:self didChangePlayState:_playState];
}

- (void)setDownloadState:(NCMusicEngineDownloadState)downloadState {
    _downloadState = downloadState;
    if (self.delegate &&
        [self.delegate conformsToProtocol:@protocol(NCMusicEngineDelegate)] &&
        [self.delegate respondsToSelector:@selector(engine:didChangeDownloadState:)])
        [self.delegate engine:self didChangeDownloadState:_downloadState];
}

#pragma mark -
#pragma mark Static

+ (NSString *)cacheFolder {
    static NSString *cacheFolder;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *cacheDir = (NSString *)[[[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject] path];
        cacheFolder = [cacheDir stringByAppendingPathComponent:kNCMusicEngineCacheFolderName];
        
        // ensure all cache directories are there (needed only once)
        NSError *error = nil;
        if(![[NSFileManager new] createDirectoryAtPath:cacheFolder withIntermediateDirectories:YES attributes:nil error:&error]) {
#ifdef DDLogError
            DDLogError(@"[NCMusicEngine] Failed to create cache directory at %@", cacheFolder);
#else
            NSLog(@"[NCMusicEngine] Failed to create cache directory at %@", cacheFolder);
#endif
        }
    });
    return cacheFolder;
}

#pragma mark -
#pragma mark AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (flag) {
        //
        [self stop];
        self.playState = NCMusicEnginePlayStateEnded;
        //
        if (self.delegate &&
            [self.delegate conformsToProtocol:@protocol(NCMusicEngineDelegate)] &&
            [self.delegate respondsToSelector:@selector(engine:playProgress:)]) {
            [self.delegate engine:self playProgress:1.f];
        }
    }
}


- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    NSLog(@"audioplayerDecodeError");
}



- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
    // 会自动暂停  do nothing ...
    NSLog(@"audioPlayerBeginInterruption---被打断");
}

//  音乐播放器打断终止 (如结束 打、接电话)
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags
{
    // 手动恢复播放
    [player play];
    NSLog(@"audioPlayerEndInterruption---打断终止");
}


@end
