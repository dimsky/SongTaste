//
//  ViewController.m
//  SongTaste
//
//  Created by William on 15/4/18.
//  Copyright (c) 2015年 dimsky. All rights reserved.
//

#import "MainViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "AFNetworking/AFNetworking.h"
#import "PureLayout/PureLayout.h"
#import "STPlayBarView.h"
#import "AFNetworking/AFNetworking.h"
#import "MusicModel.h"
#import "NSString+JSONCategories.h"
#import "NSObject+JSONCategories.h"
#import "MusicNetWork.h"
#import "NCMusicEngine.h"
#import "MusicDetailModel.h"
#import "STNavigationController.h"
#import "MainTableViewCell.h"


// http://songtaste.com/api/android/rec_list.php?p=1&n=20&tmp=0.8110623725224286&callback=dm.st.fmNew


static NSString *get_music_url = @"http://songtaste.com/api/android/rec_list.php";


@interface MainViewController ()<UITableViewDataSource, UITableViewDelegate, NCMusicEngineDelegate>


@property (nonatomic, strong)UIImageView *backgroundImageView;
@property (nonatomic, strong)UIView *headerView;
@property (nonatomic, strong)STPlayBarView *playBarView;
@property (nonatomic, strong)UITableView *mainTableView;

@property (nonatomic, strong)NSArray *musicArray;

@property (nonatomic, strong)NCMusicEngine *musicEngine;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    [self initView];
    [self initData];
}




#pragma mark private

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}


#pragma mark --- init
- (void)initView{

//    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"backimg1"]]];
    
    _playBarView = ((STNavigationController *)self.navigationController).playBarView;
    
    _backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    _backgroundImageView.clipsToBounds = YES;
    [_backgroundImageView setImage:[UIImage imageNamed:@"img003.jpg"]];
    [self.view addSubview:_backgroundImageView];
//    [self.view sendSubviewToBack:_backgroundImageView];
    [self.view bringSubviewToFront:_backgroundImageView];
    
    _headerView = [UIView newAutoLayoutView];
    _headerView.alpha = 0.8;
    [_headerView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_headerView];
    [_headerView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [_headerView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [_headerView autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH, 64)];
    
    UILabel *leftLabel = [UILabel newAutoLayoutView];
    leftLabel.textAlignment = NSTextAlignmentCenter;
    leftLabel.text = @"发现音乐";
    [_headerView addSubview:leftLabel];
    [leftLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [leftLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10];
    [leftLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [leftLabel autoSetDimension:ALDimensionWidth toSize:SCREEN_WIDTH/2 - 1];
    
    UILabel *rightLabel = [UILabel newAutoLayoutView];
    rightLabel.textAlignment = NSTextAlignmentCenter;
    rightLabel.text = @"我的ST";
    [_headerView addSubview:rightLabel];
    [rightLabel autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [rightLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10];
    [rightLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [rightLabel autoSetDimension:ALDimensionWidth toSize:SCREEN_WIDTH/2 - 1];
    
    
//    _playBarView = [STPlayBarView newAutoLayoutView];
//    [_playBarView setBackgroundColor:[UIColor redColor]];
//    [self.view addSubview:_playBarView];
//    
//    [_playBarView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
//    [_playBarView autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH, 50)];
    
    
    _mainTableView = [UITableView newAutoLayoutView];
    _mainTableView.alpha = 0.7;
    _mainTableView.dataSource = self;
    _mainTableView.delegate = self;
    [self.view addSubview:_mainTableView];
    [_mainTableView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_headerView];
    [_mainTableView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
//    [_mainTableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_playBarView];
    [_mainTableView autoSetDimension:ALDimensionWidth toSize:SCREEN_WIDTH];

    
}

- (void)initData{

    _musicEngine = [[NCMusicEngine alloc] initWithSetBackgroundPlaying:YES];
    _musicEngine.delegate = self;
    
    [[MusicNetWork sharedInstance] recommendMusicListWithCount:20 success:^(NSArray *result) {
        NSLog(@"%@", result);
        self.musicArray = result;
        [_mainTableView reloadData];
    } failed:^(NSError *error) {
        
    }];

}

- (void)setMusicArray:(NSArray *)musicArray {
    _musicArray = musicArray;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MUSICARRAY_CHANGE_NOTIFICATION object:_musicArray];
}

- (void)playWithMusicURLStr:(NSString *)musicURLStr {
    [self.musicEngine playUrl:[NSURL URLWithString:musicURLStr]];
}


- (IBAction)requestAction:(id)sender {
    
//    NSDictionary *param = @{@"op":@"dmlogin", @"f": @"st", @"user": @"dimsky%40163.com", @"pass": @"xiaotian02", @"rmbr": @"true"};
//    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:@"http://2012.songtaste.com/act" parameters:param error:nil];
//    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"dddd");
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            
//    }];
    NSURL *url=[[NSURL alloc]initWithString:@"http://2012.songtaste.com/act"];
    
    NSMutableData *postBody=[NSMutableData data];
    [postBody appendData:[@"op=dmlogin&f=st&user=dimsky%40163.com&pass=xiaotian02&rmbr=true&tmp=0.5915272135753185" dataUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url
                                                             cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                         timeoutInterval:20.0f];
    [request setHTTPMethod: @"POST"];
    [request setValue: @"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postBody];
    NSError *error = nil;
    NSHTTPURLResponse* urlResponse = nil;
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//   [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
//       NSLog(@"%@", responseObject);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%@", error);
//    }];
    
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:&urlResponse error:&error];
    NSString *result = [[NSString alloc] initWithData:responseData
                                             encoding:NSUTF8StringEncoding];
    NSLog(@"结果：%@",result);
     [[urlResponse allHeaderFields] valueForKey:@"Set-Cookie"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _musicArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identity = @"musicCell";
    
//    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identity];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
//    }
//    
    MusicModel *model = _musicArray[indexPath.row];
    
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (!cell) {
        cell = [[MainTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
    }
    cell.model = model;
    
//    cell.textLabel.text = model.Name;    
    return cell;
}

#pragma mark UITableViewDelegate 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [_playBarView playMusicWithIndex:indexPath.row];
    
//    NCMusicEngine *music = [[NCMusicEngine alloc] initWithSetBackgroundPlaying:YES];
//    [music playUrl:[NSURL URLWithString:@"http://ma.songtaste.com/201504281050/7a8cb1cce5b1e63e22b525019db1c0d6/a/a0/a03bb1076afbc893b726c93d3eecb83d.mp3"]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64.0;
}


#pragma mark NCMusicEngineDelegate
- (void)engine:(NCMusicEngine *)engine didChangePlayState:(NCMusicEnginePlayState)playState {
    NSLog(@"%d", playState);
}
- (void)engine:(NCMusicEngine *)engine didChangeDownloadState:(NCMusicEngineDownloadState)downloadState {
        NSLog(@"%d", downloadState);
}
- (void)engine:(NCMusicEngine *)engine downloadProgress:(CGFloat)progress {
    NSLog(@"下载进度%f", progress);
}
- (void)engine:(NCMusicEngine *)engine playProgress:(CGFloat)progress {
    NSLog(@"播放进度%f", progress);
}


@end
