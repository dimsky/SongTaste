//
//  MyNetWork.m
//  SongTaste
//
//  Created by William on 15/5/8.
//  Copyright (c) 2015年 dimsky. All rights reserved.
//

#import "MyNetWork.h"
#import "AFNetworking/AFNetworking.h"
#import "UserModel.h"

@implementation MyNetWork


+ (instancetype)sharedInstance{
    __strong static MyNetWork *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MyNetWork alloc] init];
    });
    return instance;
}

-(void)loginWithUserName:(NSString *)userName password:(NSString *)password success:(void (^)(UserModel *model))successBlock error:(void (^)(NSString *error))failedBlock {

    NSDictionary *param = @{@"op": @"dmlogin", @"f": @"st", @"user": userName, @"pass": password ,@"rmbr" : @"true", @"tmp": @"0.5915272135753185"};
    AFHTTPRequestOperationManager *manager =  [AFHTTPRequestOperationManager manager];
    //        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
       manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    manager.requestSerializer.acc
    [manager GET:@"http://2012.songtaste.com/act" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSNumber *ecode = responseObject[@"ecode"];
        if ([ecode isEqual: @(-203)]) {
            //账号长度不能小于4
            NSString *message = responseObject[@"message"];
            failedBlock(message);
        } else if ([ecode isEqual: @(-301)]) {
            //用户不存在
            NSString *message = responseObject[@"message"];
            NSLog(@"%@", message);
            failedBlock(message);
        } else if ([ecode isEqual: @(-302)]) {
            //密码错误
            NSString *message = responseObject[@"message"];
            NSLog(@"%@", message);
            failedBlock(message);

        } else if ([ecode isEqual: @(0)]) {
            //登陆成功
            NSLog(@"登陆成功");
            NSString *cookie = [operation.response.allHeaderFields valueForKey:@"Set-Cookie"];
            NSArray *cookieArray = [cookie componentsSeparatedByString:@"; "];
            NSMutableDictionary *cookieDic = [NSMutableDictionary new];
            for (NSString *inStr in cookieArray) {
                NSArray *instrArray =[inStr componentsSeparatedByString:@", "];
                for (NSString *inInStr in instrArray) {
                    NSArray *array = [inInStr componentsSeparatedByString:@"="];
                    if (array.count == 2) {
                        [cookieDic setObject:array[1] forKey:array[0]];
                    }
                }
                
            }
            
//            CookDmID = 23880646;
//            CookID = 4775792;
//            CookIcon = deleted;
//            CookName = "william%2C.";
//            CookSES = 02BFDgPHbO0Vi27vi1oXHwGxMi3;
//            PHPSESSID = 433d85f0ed1903959dd09c0febcc52b3;
//            domain = ".songtaste.com";
//            expires = Mon;
//            path = "/";

            
            UserModel *model = [[UserModel alloc] init];
            model.cookID = cookieDic[@"CookID"];
            model.cookName = cookieDic[@"CookName"];
            model.userName = userName;
            model.password = password;
            successBlock(model);
            
//            NSLog(@"%@",responseObject);
        } else {
            failedBlock(@"error");

        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failedBlock(error.description);
    }];
    
}
@end
