//
//  MyMusicView.m
//  SongTaste
//
//  Created by William on 15/5/2.
//  Copyright (c) 2015年 dimsky. All rights reserved.
//

#import "MyMusicView.h"
#import "PureLayout/PureLayout.h"
#import "MyLocalMusicViewController.h"
#import "UIView+ViewControllerCategories.h"

@interface MyMusicView() <UITableViewDataSource , UITableViewDelegate>

@end

@implementation MyMusicView

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
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}


- (void)initSubviews {
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    lable.text = @"我的音乐";
    [self addSubview:lable];
    
    _tableView = [[UITableView alloc] initWithFrame:self.bounds];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView setContentInset:UIEdgeInsetsMake(MainViewControllerHeaderHeight, 0, MainViewControllerFooterHeight, 0)];
    [_tableView setScrollIndicatorInsets:UIEdgeInsetsMake(MainViewControllerHeaderHeight, 0, MainViewControllerFooterHeight, 0)];
    
    [self addSubview:_tableView];
    

    
}


#pragma mark UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identify = @"myCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"我的收藏";
    } else if (indexPath.row == 1) {
        cell. textLabel.text = @"我的下载";
    } else if (indexPath.row == 2) {
        cell. textLabel.text = @"最近播放";
    }
    
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {

    } else if (indexPath.row == 1) {
        MyLocalMusicViewController *localMusicViewController = [[MyLocalMusicViewController alloc] init];
        
        [[self viewController].navigationController pushViewController:localMusicViewController animated:YES];
    } else if (indexPath.row == 2) {
        
    } else if (indexPath.row == 3) {
        
    } else if (indexPath.row == 4) {
        
    } else {
        
    }
    
}
@end
