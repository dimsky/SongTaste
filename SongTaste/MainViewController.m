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
#import "MJRefresh/MJRefresh.h"
#import "MusicDiscoverView.h"
#import "MyMusicView.h"
#import "FXBlurView.h"

// http://songtaste.com/api/android/rec_list.php?p=1&n=20&tmp=0.8110623725224286&callback=dm.st.fmNew


static NSString *get_music_url = @"http://songtaste.com/api/android/rec_list.php";

@interface MainViewController ()<UIScrollViewDelegate, NCMusicEngineDelegate>

@property (nonatomic, strong)UIScrollView *mainScrollView;

// 发现音乐
@property (nonatomic, strong)UIImageView *backgroundImageView;
@property (nonatomic, strong)FXBlurView *headerView;
@property (nonatomic, strong)UIButton *musicDiscoverBtn;
@property (nonatomic, strong)UIButton *myMusicBtn;


//我的ST
@property (nonatomic, strong)UIView *mySTMainView;
@property (nonatomic, strong)UITableView *mySTTableView;

@property (nonatomic, strong)STPlayBarView *playBarView;
@property (nonatomic, strong)NSArray *musicArray;
@property (nonatomic, strong)NCMusicEngine *musicEngine;
@end

@implementation MainViewController {
    CGFloat _statusBarOffset;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    [self initView];

}




#pragma mark private

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}


#pragma mark --- init
- (void)initView{

    _playBarView = ((STNavigationController *)self.navigationController).playBarView;
    
    _backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    _backgroundImageView.clipsToBounds = YES;
    [_backgroundImageView setImage:[UIImage imageNamed:@"img003.jpg"]];
    [self.view addSubview:_backgroundImageView];
    [self.view sendSubviewToBack:_backgroundImageView];
    
    _headerView = [FXBlurView newAutoLayoutView];
//    _headerView.alpha = 0.8;
    _headerView.tintColor = [UIColor orangeColor];
    [self.view addSubview:_headerView];
    
    [_headerView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [_headerView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [_headerView autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH, MainViewControllerHeaderHeight)];
    
    
    _musicDiscoverBtn = [UIButton newAutoLayoutView];
    _musicDiscoverBtn.tag = 0;
    [_musicDiscoverBtn setTitle:@"发现音乐" forState:UIControlStateNormal];
    [_musicDiscoverBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_musicDiscoverBtn addTarget:self action:@selector(viewIndexChange:) forControlEvents:UIControlEventTouchUpInside];
//    UILabel *leftLabel = [UILabel newAutoLayoutView];
//    leftLabel.textAlignment = NSTextAlignmentCenter;
//    leftLabel.text = @"发现音乐";

    [_headerView addSubview:_musicDiscoverBtn];
    [_musicDiscoverBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [_musicDiscoverBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20];
    [_musicDiscoverBtn autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [_musicDiscoverBtn autoSetDimension:ALDimensionWidth toSize:SCREEN_WIDTH/2 - 1];
    
    
    _myMusicBtn = [UIButton newAutoLayoutView];
    _myMusicBtn.tag = 1;
    [_myMusicBtn addTarget:self action:@selector(viewIndexChange:) forControlEvents:UIControlEventTouchUpInside];
    [_myMusicBtn setTitle:@"我的ST" forState:UIControlStateNormal];
    [_myMusicBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_headerView addSubview:_myMusicBtn];
    [_myMusicBtn autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [_myMusicBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20];
    [_myMusicBtn autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [_myMusicBtn autoSetDimension:ALDimensionWidth toSize:SCREEN_WIDTH/2 - 1];

    
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:_mainScrollView];
    _mainScrollView.delegate = self;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.scrollsToTop = NO;
    
    MusicDiscoverView *discoverView = [[MusicDiscoverView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [_mainScrollView addSubview:discoverView];
   
    
    
    MyMusicView *myMusicView = [[MyMusicView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [_mainScrollView addSubview:myMusicView];
    
    _mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 2, SCREEN_HEIGHT);
    
        [self.view bringSubviewToFront:_headerView];

}


- (void)viewIndexChange:(UIButton *)sender {
    if (sender.tag == 0) {
        
    } else if (sender.tag == 1) {
        
    } else {
        
    }
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

@end
