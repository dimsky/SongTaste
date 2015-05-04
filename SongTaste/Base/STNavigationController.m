//
//  STNavigationController.m
//  SongTaste
//
//  Created by William on 15/4/28.
//  Copyright (c) 2015年 dimsky. All rights reserved.
//

#import "STNavigationController.h"
#import "STPlayBarView.h"
#import "PureLayout/PureLayout.h"
@interface STNavigationController ()

@property (nonatomic, strong)NSArray *musicArray;

@end

@implementation STNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _playBarView = [STPlayBarView sharedInstance];
    [_playBarView setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:_playBarView];
    
    [_playBarView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [_playBarView autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH, MainViewControllerFooterHeight)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(musicArrayChange:) name:MUSICARRAY_CHANGE_NOTIFICATION object:nil];
}

- (void)musicArrayChange:(NSNotification *)notifi {

    _playBarView.musicArray = notifi.object;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
