//
//  MusicDiscoverView.m
//  SongTaste
//
//  Created by William on 15/5/2.
//  Copyright (c) 2015年 dimsky. All rights reserved.
//

#import "MusicDiscoverView.h"
#import "PureLayout/PureLayout.h"
#import "STPlayBarView.h"
#import "MainTableViewCell.h"
#import "MusicNetWork.h"
#import "MJRefresh/MJRefresh.h"

static int loadMorePage = 2;

@interface MusicDiscoverView()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation MusicDiscoverView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initSubviews];
        [self initData];
        [self initObservers];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
        [self initData];
        [self initObservers];
    }
    return self;
}

- (void)initSubviews {
    
    _playBarView = [STPlayBarView sharedInstance];
    
    _backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    _backgroundImageView.clipsToBounds = YES;
    [_backgroundImageView setImage:[UIImage imageNamed:@"img003.jpg"]];
    [self addSubview:_backgroundImageView];
    [self sendSubviewToBack:_backgroundImageView];
    
    
    _mainTableView = [UITableView newAutoLayoutView];
    _mainTableView.alpha = 0.9;
    _mainTableView.dataSource = self;
    _mainTableView.delegate = self;
    [_mainTableView setContentInset:UIEdgeInsetsMake(MainViewControllerHeaderHeight, 0, MainViewControllerFooterHeight, 0)];
    [_mainTableView setScrollIndicatorInsets:UIEdgeInsetsMake(MainViewControllerHeaderHeight, 0, MainViewControllerFooterHeight, 0)];
    
    [self addSubview:_mainTableView];
    [_mainTableView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [_mainTableView autoPinEdgeToSuperviewEdge:ALEdgeBottom ];
    [_mainTableView autoSetDimension:ALDimensionWidth toSize:SCREEN_WIDTH];

    
    __weak typeof(self) weakSelf = self;
    [self.mainTableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
    [self.mainTableView.header beginRefreshing];
    
    [self.mainTableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
}

- (void)initData{
    _musicArray = [[NSMutableArray alloc] init];
}

- (void)setMusicArray:(NSMutableArray *)musicArray {
    _playBarView.musicArray = musicArray;
    _musicArray = musicArray;
}

- (void)initObservers {
//    NSKeyValueObservingOptions kvoOptions = NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew;
//    [self addObserver:self forKeyPath:@"musicArray" options:kvoOptions context:nil];
}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//    if ([keyPath isEqualToString:@"musicArray"]) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:MUSICARRAY_CHANGE_NOTIFICATION object:_musicArray];
//    }
//}

- (void)loadNewData {
    [[MusicNetWork sharedInstance] recommendMusicListWithCount:20 page:1 success:^(NSArray *result) {
        NSLog(@"获取数据%@", result);
        
        NSMutableArray *newArray = [NSMutableArray array];
        for (MusicModel *model in result) {
            if (![self.musicArray containsObject:model]) {
                [newArray addObject:model];
            }
        }
        self.musicArray = [newArray arrayByAddingObjectsFromArray:self.musicArray];
        [self.mainTableView reloadData];
        [self.mainTableView.header endRefreshing];
    } failed:^(NSError *error) {
        
    }];
}

- (void)loadMoreData {
    [[MusicNetWork sharedInstance] recommendMusicListWithCount:20 page:loadMorePage success:^(NSArray *result) {
        NSLog(@"%@", result);
        NSMutableArray *moreArray = [NSMutableArray array];
        for (MusicModel *model in result) {
            if (![self.musicArray containsObject:model]) {
                [moreArray addObject:model];
            }
        }
        self.musicArray = [self.musicArray arrayByAddingObjectsFromArray:moreArray];
        ++loadMorePage;
        [self.mainTableView.footer endRefreshing];
    } failed:^(NSError *error) {
        
    }];
    [self.mainTableView reloadData];
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
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    _playBarView.musicArray = self.musicArray;
    [_playBarView playMusicWithIndex:indexPath.row];
    
    //    NCMusicEngine *music = [[NCMusicEngine alloc] initWithSetBackgroundPlaying:YES];
    //    [music playUrl:[NSURL URLWithString:@"http://ma.songtaste.com/201504281050/7a8cb1cce5b1e63e22b525019db1c0d6/a/a0/a03bb1076afbc893b726c93d3eecb83d.mp3"]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64.0;
}

#pragma makr --
- (void) dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
