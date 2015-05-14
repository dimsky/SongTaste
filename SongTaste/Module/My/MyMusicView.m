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
#import "LoginViewController.h"
#import "UserModel.h"

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
        [self initObservers];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
        [self initObservers];
    }
    return self;
}



- (void)initSubviews {
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    lable.text = @"我的音乐";
    [self addSubview:lable];
    
    _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.scrollsToTop = NO;
    _tableView.delegate = self;

    [_tableView setContentInset:UIEdgeInsetsMake(MainViewControllerHeaderHeight, 0, MainViewControllerFooterHeight, 0)];
    [_tableView setScrollIndicatorInsets:UIEdgeInsetsMake(MainViewControllerHeaderHeight, 0, MainViewControllerFooterHeight, 0)];
    
    [self addSubview:_tableView];
    

    
}

- (void)initObservers{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginHandler) name:nLoginSuccessNotification object:nil];
}

#pragma mark NSNotificationHandler 

- (void)loginHandler {
    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 3;
            break;
        case 2:
            return 1;
            break;
            
        default:
            break;
    }
    
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identify = @"myCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeConstraints:view.constraints];
        [view removeFromSuperview];
    }
    [cell.contentView removeConstraints: cell.constraints];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if ([[UserModel currentUserAccount] isValidUser]) {
                UIImageView *userIconView = [UIImageView newAutoLayoutView];
                [cell.contentView addSubview:userIconView];
                
                [userIconView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:stCellEdgeLeft];
                [userIconView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
                [userIconView autoSetDimensionsToSize:CGSizeMake(30, 30)];
                
                UILabel *userNameLabel = [UILabel newAutoLayoutView];
                [cell.contentView addSubview:userNameLabel];
                
                userNameLabel.text = [UserModel currentUserAccount].cookName;
                
                [userNameLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:userIconView];
                [userNameLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
                
            } else {
                UIButton *loginButton = [UIButton newAutoLayoutView];
                [cell.contentView addSubview:loginButton];
                [loginButton setTitle:@"立即登录" forState:UIControlStateNormal];
                loginButton.userInteractionEnabled = NO;
                [loginButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
                [loginButton autoCenterInSuperview];
                
            }
            
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"我的收藏";
        } else if (indexPath.row == 1) {
            cell. textLabel.text = @"我的下载";
        } else if (indexPath.row == 2) {
            cell. textLabel.text = @"最近播放";
        }
    } else {
        
    }
    
    return cell;
}

#pragma mark UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        
        [[self viewController].navigationController pushViewController:loginViewController animated:YES];
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            
        } else if (indexPath.row == 1) {
            MyLocalMusicViewController *localMusicViewController = [[MyLocalMusicViewController alloc] init];
            
            [[self viewController].navigationController pushViewController:localMusicViewController animated:YES];
        } else if (indexPath.row == 2) {
            
        } else if (indexPath.row == 3) {
            
        } else if (indexPath.row == 4) {
            
        } else {
            
        }
    } else if (indexPath.section == 2) {
        
    } else {
        
    }
    
}





@end
