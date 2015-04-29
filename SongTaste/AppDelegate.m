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
#import "TestViewController.h"
#import "STPlayBarView.h"
#import "MediaPlayer/MediaPlayer.h"
#import "MusicDetailModel.h"

@interface AppDelegate ()


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    MainViewController *mainViewController = [[MainViewController alloc] init];
    TestViewController *testViewController = [[TestViewController alloc] init];
    self.window.rootViewController = [[STNavigationController alloc] initWithRootViewController:mainViewController];
    
    //接收远程事件
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    
    
    [[STPlayBarView sharedInstance] updateControlNowPlayingInfo];

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
            break;        }
    }
}

@end
