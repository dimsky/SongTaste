//
//  UserModel.m
//  SongTaste
//
//  Created by William on 15/5/8.
//  Copyright (c) 2015年 dimsky. All rights reserved.
//

#import "UserModel.h"
#import "NSObject+Property.h"

@implementation UserModel
__strong static UserModel *_currentUserAccount = nil;


+ (UserModel *)currentUserAccount {
    static dispatch_once_t token = 0;
    dispatch_once(&token, ^() {
        _currentUserAccount = [[UserModel alloc] init];
        [_currentUserAccount loadUserAccountInformationFromLocalDefaults];
    });
    return _currentUserAccount;
}

- (BOOL)isValidUser {
    return self.cookID != 0;
}

- (void)loadUserAccountInformationFromLocalDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *accountData = [defaults objectForKey:@"UserAccount"];
    if (accountData) {
        NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:accountData];
        if (dict) {
            [self setValuesForKeysWithDictionary:dict];
        }
    }
}


- (void)saveUserAccountInformationToLocalDefaults {
    @synchronized (self) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *dict = [self dictionaryWithValuesForKeys:[self allKeys]];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dict];
        if (data) {
            [defaults setObject:data forKey:@"UserAccount"];
            [defaults synchronize];
        }
    }
}

+ (UserModel *)emptyUserAccount {
    UserModel *account = [[UserModel alloc] init];
    return account;
}

- (void)logout {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"UserAccount"];
    [defaults synchronize];
    //    [[NSFileManager defaultManager] removeItemAtPath:[self getAvatarLocalStorePath] error:nil];
    [UserModel setUserAccountCurrentUserAccount:[UserModel emptyUserAccount]];
    [[UserModel currentUserAccount] saveUserAccountInformationToLocalDefaults];
}


+ (void)setUserAccountCurrentUserAccount:(UserModel *)account {
    @synchronized ([self class]) {
        _currentUserAccount.cookID = account.cookID;
        _currentUserAccount.cookName = account.cookName;
        _currentUserAccount.userName = account.userName;
        _currentUserAccount.password = account.password;
    }
}


@end
