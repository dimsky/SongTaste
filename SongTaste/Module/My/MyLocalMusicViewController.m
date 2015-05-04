//
//  MyLocalMusicViewController.m
//  SongTaste
//
//  Created by William on 15/5/3.
//  Copyright (c) 2015年 dimsky. All rights reserved.
//

#import "MyLocalMusicViewController.h"
#import "NCMusicEngine.h"
#import "STPlayBarView.h"
#import "MusicLocalModel.h"
#import "MusicModel.h"

@interface MyLocalMusicViewController () <UITableViewDataSource ,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *localMusicArray;
@end

@implementation MyLocalMusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    _localMusicArray= [MusicLocalModel listAllObjects];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    _localMusicArray = [fileManager contentsOfDirectoryAtPath:[NCMusicEngine cacheFolder ] error:nil];
    
    
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _localMusicArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identify = @"localFileCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (! cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    MusicLocalModel *localmodel = _localMusicArray[indexPath.row];
    
    cell.textLabel.text = localmodel.Name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [STPlayBarView sharedInstance].musicArray =
    NSMutableArray *array = [NSMutableArray new];
    for (MusicLocalModel *model in _localMusicArray) {
        MusicModel *music = [[MusicModel alloc] init];
        music.ID = model.MusicId;
        [array addObject:music];
    }
        [STPlayBarView sharedInstance].musicArray =  array;
    [[STPlayBarView sharedInstance] playMusicWithIndex:indexPath.row];
//    [[STPlayBarView sharedInstance].musicEngine playLocalFileWithPath:localFilePath];
}

@end
