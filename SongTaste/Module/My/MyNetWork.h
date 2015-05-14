//
//  MyNetWork.h
//  SongTaste
//
//  Created by William on 15/5/8.
//  Copyright (c) 2015年 dimsky. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum:NSInteger{
    kcLoginSuccess = 0,
    kcLoginUserNameError = -203,
    kcLoginUserNotFound = -301,
    kcLoginPasswordError = -302,
}LOGIN_STATUS;



@class UserModel;

@interface MyNetWork : NSObject


+ (instancetype)sharedInstance;

- (void)loginWithUserName:(NSString *)userName password:(NSString *)password success:(void(^)(UserModel *model))successBlock error:(void(^)(NSString *error))errorBlock;

@end
