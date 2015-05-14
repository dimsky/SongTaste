//
//  UserModel.h
//  SongTaste
//
//  Created by William on 15/5/8.
//  Copyright (c) 2015年 dimsky. All rights reserved.
//

#import "STModel.h"

@interface UserModel : STModel


//            CookDmID = 23880646;
//            CookID = 4775792;
//            CookIcon = deleted;
//            CookName = "william%2C.";
//            CookSES = 02BFDgPHbO0Vi27vi1oXHwGxMi3;
//            PHPSESSID = 433d85f0ed1903959dd09c0febcc52b3;
//            domain = ".songtaste.com";
//            expires = Mon;
//            path = "/";



@property (nonatomic, strong)NSString *userName;
@property (nonatomic, strong)NSString *password;

@property (nonatomic, strong)NSNumber *cookID;
@property (nonatomic, strong)NSString *cookName;


+ (UserModel *)currentUserAccount;

- (BOOL)isValidUser;

- (void)loadUserAccountInformationFromLocalDefaults;

- (void)saveUserAccountInformationToLocalDefaults;

- (void)logout;

@end
