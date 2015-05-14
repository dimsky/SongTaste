//
//  LoginViewController.m
//  SongTaste
//
//  Created by William on 15/5/7.
//  Copyright (c) 2015年 dimsky. All rights reserved.
//

#import "LoginViewController.h"
#import "PureLayout/PureLayout.h"
#import "MyNetWork.h"
#import "UserModel.h"
#import "SVProgressHUD/SVProgressHUD.h"

@interface LoginViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;


@end

@implementation LoginViewController {
    UITextField *userField;
    UITextField *passwordField;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    self.title = @"登录";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma  mark UITableViewDatasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else {
        return 1;
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identify = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (! cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    if (indexPath.section == 0) {
       
        if (indexPath.row == 0) {
            userField = [[UITextField alloc] init];
            userField.placeholder = @"账号";
            [cell.contentView addSubview:userField];
            
            [userField autoPinEdgeToSuperviewEdge: ALEdgeLeft withInset:20];
            [userField autoPinEdgeToSuperviewEdge: ALEdgeRight];
            [userField autoPinEdgeToSuperviewEdge: ALEdgeTop];
            [userField autoPinEdgeToSuperviewEdge: ALEdgeBottom];
            
        } else if (indexPath.row == 1) {
            passwordField = [[UITextField alloc] init];
            passwordField.placeholder = @"密码";
            passwordField.secureTextEntry = YES;
            [cell.contentView addSubview:passwordField];
            
            [passwordField autoPinEdgeToSuperviewEdge: ALEdgeLeft withInset:20];
            [passwordField autoPinEdgeToSuperviewEdge: ALEdgeRight];
            [passwordField autoPinEdgeToSuperviewEdge: ALEdgeTop];
            [passwordField autoPinEdgeToSuperviewEdge: ALEdgeBottom];
            
        }

   
    
//
    } else {
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:@"登录" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:button];
        
        [button autoPinEdgeToSuperviewEdge: ALEdgeLeft withInset:50];
        [button autoPinEdgeToSuperviewEdge: ALEdgeRight withInset:50];
        [button autoPinEdgeToSuperviewEdge: ALEdgeTop];
        [button autoPinEdgeToSuperviewEdge: ALEdgeBottom];
        
    }
    
    
    
    return cell;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 100;
}

#pragma mark Action

- (void)loginAction:(id)sender {
    NSLog(@"登录");
    NSString *userName = userField.text;
    NSString *password = passwordField.text;

    [SVProgressHUD showWithStatus:@"正在登录..."];

    [[MyNetWork sharedInstance] loginWithUserName:userName password:password success:^(UserModel *model) {
        
        [model saveUserAccountInformationToLocalDefaults];
        
        [SVProgressHUD showSuccessWithStatus:@"登录成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:nLoginSuccessNotification object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    } error:^(NSString *error) {
//        [SVProgressHUD dismiss];
        [SVProgressHUD showInfoWithStatus:error];
         
    }];
    
}



@end
