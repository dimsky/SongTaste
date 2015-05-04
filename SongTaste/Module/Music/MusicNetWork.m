//
//  MusicNetWork.m
//  SongTaste
//
//  Created by William on 15/4/27.
//  Copyright (c) 2015年 dimsky. All rights reserved.
//

#import "MusicNetWork.h"
#import "AFNetworking/AFNetworking.h"
#import "NSObject+JSONCategories.h"
#import "NSString+JSONCategories.h"
#import "MusicModel.h"
#import "MusicDetailModel.h"
#import "Ono/Ono.h"

@implementation MusicNetWork

+ (instancetype)sharedInstance{
    __strong static MusicNetWork *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MusicNetWork alloc] init];
    });
    return instance;
}

- (void)recommendMusicList1WithCount:(int)count success:(void(^)(NSArray *result))successBlock failed:(void(^)(NSError *error))failedBlock {
    NSDictionary *param = @{@"p": @"1", @"n": @(count), @"tmp": @"0.819292892893892", @"callback": @"dm.st.fmNew"};
    AFHTTPRequestOperationManager *manager =  [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:@"http://songtaste.com/api/android/rec_list.php" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSRange startRange = [str rangeOfString:@"("];
        str = [str substringFromIndex:startRange.location + 1];
        NSRange endRange = [str rangeOfString:@")"];
        str = [str substringToIndex:endRange.location];
        NSDictionary *dict = [str JSONValue];
        NSMutableArray *array = [NSMutableArray new];
        for (id obj in dict[@"data"]) {
            MusicModel *musicModel = [[MusicModel alloc] initWithString:[obj JSONString] error:nil] ;
            [array addObject:musicModel];
        }
        
        
        successBlock(array);
        
        //        NSLog(@"%@---%d", dict[@"data"][0], [dict[@"data"] count]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        failedBlock(error);
    }];
}



- (void)recommendMusicListWithCount:(int)count page:(int)page success:(void(^)(NSArray *result))successBlock failed:(void(^)(NSError *error))failedBlock {
    NSDictionary *param = @{@"p": @(page), @"n": @(count), @"tmp": @"0.819292892893892", @"callback": @" "};
    AFHTTPRequestOperationManager *manager =  [AFHTTPRequestOperationManager manager];
//        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:@"http://songtaste.com/api/android/rec_list.php" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *array = [NSMutableArray new];
//        NSLog(@"%@",responseObject[@"data"]);
        for (id obj in responseObject[@"data"]) {
            MusicModel *musicModel = [[MusicModel alloc] initWithString:[obj JSONString] error:nil] ;
            [array addObject:musicModel];
        }
        
        successBlock(array);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failedBlock(error);
    }];

}


- (void)musicDetailWithId:(int)musicId success:(void(^)(MusicDetailModel *music))successBlock failed:(void(^)(NSError *error))failedBlock {
    NSDictionary *param = @{@"songid": @(musicId)};
    AFHTTPRequestOperationManager *manager =  [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:@"http://songtaste.com/api/android/songurl.php" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", operation.responseString);
        ONOXMLDocument *document = [ONOXMLDocument XMLDocumentWithData:responseObject error:nil];
        NSString *jsonStr = @"{";
        for (ONOXMLElement *element in document.rootElement.children) {
            jsonStr = [jsonStr stringByAppendingFormat:@"\"%@\": \"%@\", ", element.tag, element.stringValue];
        }
        jsonStr = [jsonStr stringByAppendingString:@"}"];
        NSLog(@" 歌曲详细信息%@",jsonStr);
        NSError *error = nil;
        MusicDetailModel *musicDetailModel = [[MusicDetailModel alloc] initWithString:jsonStr error:&error];
        successBlock(musicDetailModel);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failedBlock(error);
    }];
}

@end
