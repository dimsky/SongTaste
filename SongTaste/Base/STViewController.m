//
//  STViewController.m
//  SongTaste
//
//  Created by William on 15/4/28.
//  Copyright (c) 2015年 dimsky. All rights reserved.
//

#import "STViewController.h"
#import "PureLayout/PureLayout.h"

@interface STViewController ()

@end

@implementation STViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self.view autoSetDimension:ALDimensionHeight toSize:SCREEN_HEIGHT - 50];
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 50);
    
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
