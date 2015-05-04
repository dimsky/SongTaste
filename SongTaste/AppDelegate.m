//
//  AppDelegate.m
//  SongTaste
//
//  Created by William on 15/4/18.
//  Copyright (c) 2015年 dimsky. All rights reserved.
//

#import "AppDelegate.h"
#import "STNavigationController.h"
#import "MainViewController.h"
#import "STPlayBarView.h"
#import "MediaPlayer/MediaPlayer.h"
#import "MusicDetailModel.h"
#import "AVFoundation/AVFoundation.h"
#import "MusicLocalModel.h"

#import "FMDB.h"


@interface AppDelegate ()


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    MainViewController *mainViewController = [[MainViewController alloc] init];
//    TestViewController *testViewController = [[TestViewController alloc] init];
    self.window.rootViewController = [[STNavigationController alloc] initWithRootViewController:mainViewController];
    [self becomeFirstResponder];

    //后台播放音频设置
//    AVAudioSession *session = [AVAudioSession sharedInstance];
//    [session setActive:YES error:nil];
//    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
//    
//    //让app支持接受远程控制事件
//    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
//     [self becomeFirstResponder];
    
    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    
//    NSString *documentDirectory = [paths objectAtIndex:0];
//    
//    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"SongTaste.sqlite"];
//    
//    FMDatabase *db = [FMDatabase databaseWithPath:dbPath] ;
//    
//    if (![db open]) {
//        
//        NSLog(@"Could not open db.");
//        
//        
//    }
    [MusicLocalModel initTable];
    


    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    

//        [[NSNotificationCenter defaultCenter] postNotificationName:STPlayerEnterBackground object:nil];


//    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
//    UIApplication*   app = [UIApplication sharedApplication];
//    __block    UIBackgroundTaskIdentifier bgTask;
//    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (bgTask != UIBackgroundTaskInvalid)
//            {
//                bgTask = UIBackgroundTaskInvalid;
//            }
//        });
//    }];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (bgTask != UIBackgroundTaskInvalid)
//            {
//                bgTask = UIBackgroundTaskInvalid;
//            }
//        });
//    });

    [application beginReceivingRemoteControlEvents];

    
//    __block UIBackgroundTaskIdentifier background_task;
//    //注册一个后台任务，告诉系统我们需要向系统借一些事件
//    background_task = [application beginBackgroundTaskWithExpirationHandler:^ {
//        
//        //不管有没有完成，结束background_task任务
//        [application endBackgroundTask: background_task];
//        background_task = UIBackgroundTaskInvalid;
//    }];
//    
//    /*
//     尽量用异步，如果像这样 你会发现主线程会被阻塞
//     while(TRUE)
//     {
//     NSLog(@"Background time Remaining: %f",[[UIApplication sharedApplication] backgroundTimeRemaining]);
//     [NSThread sleepForTimeInterval:1]; //wait for 1 sec
//     }
//     */
//    //异步
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        
//        //### background task starts
//        NSLog(@"Running in the background\n");
//        
//        static int i = 0;
//        while(i < 5)
//        {
//            NSLog(@"Background time Remaining: %f",[[UIApplication sharedApplication] backgroundTimeRemaining]);
//            [NSThread sleepForTimeInterval:1]; //wait for 1 sec
//            i++;
//        }
//        /*
//         while(TRUE)
//         {
//         NSLog(@"Background time Remaining: %f",[[UIApplication sharedApplication] backgroundTimeRemaining]);
//         [NSThread sleepForTimeInterval:1]; //wait for 1 sec
//         i++;
//         }
//         */
//        
//        //我们自己完成任务后，结束background_task任务
//        //如果我们用while（TRUE）的话，下面这两行代码应该不会执行
//        [application endBackgroundTask: background_task];
//        background_task = UIBackgroundTaskInvalid;
//    });
    
    
//    [[STPlayBarView sharedInstance] updateControlNowPlayingInfo];

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    
//    NSLog(@"%@", event.subtype);
    if(event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPlay:
                [[STPlayBarView sharedInstance] playAndStopMusic];
                NSLog(@"RemoteControlEvents: play");
                break;
            case UIEventSubtypeRemoteControlPause:
                [[STPlayBarView sharedInstance] playAndStopMusic];
                NSLog(@"RemoteControlEvents: pause");
                break;
            case UIEventSubtypeRemoteControlTogglePlayPause:
                [[STPlayBarView sharedInstance] playAndStopMusic];
                NSLog(@"RemoteControlEvents: pause");
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                [[STPlayBarView sharedInstance] playMusicNext];
                NSLog(@"RemoteControlEvents: playModeNext");
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                [[STPlayBarView sharedInstance] playMusicPrev];
                NSLog(@"RemoteControlEvents: playPrev");
                break;
            default:
            break;
        }
    }
}
- (void)updateControlNowPlayingInfo {
   
    NSMutableDictionary *dict = nil;
    if ([[MPNowPlayingInfoCenter defaultCenter] nowPlayingInfo]) {
        
        dict = [NSMutableDictionary dictionaryWithDictionary:[[MPNowPlayingInfoCenter defaultCenter] nowPlayingInfo]];
    } else {
        dict = [[NSMutableDictionary alloc] init];
    }
    
    [dict setObject:@"歌名" forKey:MPMediaItemPropertyTitle];
    [dict setObject:@"作者"  forKey:MPMediaItemPropertyArtist];
    [dict setObject:@(12) forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
   
        [dict setObject:[NSNumber numberWithFloat:1.0] forKey:MPNowPlayingInfoPropertyPlaybackRate];

        [dict setObject:[NSNumber numberWithFloat:0.0] forKey:MPNowPlayingInfoPropertyPlaybackRate];

    //    [dict setObject:[NSNumber numberWithFloat:1.0] forKey:MPNowPlayingInfoPropertyPlaybackRate];
    [dict setObject:@(120) forKey:MPMediaItemPropertyPlaybackDuration];
//    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:nil];
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
    
}


@end
