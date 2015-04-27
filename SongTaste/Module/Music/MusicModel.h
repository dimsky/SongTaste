//
//  MusicModel.h
//  SongTaste
//
//  Created by William on 15/4/27.
//  Copyright (c) 2015年 dimsky. All rights reserved.
//

#import "STModel.h"

@interface MusicModel : STModel

//Click = 73;
//DevType = 0;
//FavNum = 0;
//GradeNum = 1;
//ID = 1600420;
//Name = "1996 Marilyn Manson";
//RateDT = "19\U79d2\U524d";
//RateUID = 7382041;
//RateUName = black1983;
//Singer = "Marilyn Manson";
//UpUIcon = "http://image.songtaste.com/images/usericon/s/01/126001.jpg";
//UpUName = jd50;
//UserID = 126001;

//<MusicModel>
//[RateUName]: 灰灰狼了
//[Name]: 别走DEMO
//[Singer]: 未知
//[ID]: 2484723
//[RateDT]: 52秒前
//[Click]: 31013
//[RateUID]: 3254167
//[DevType]: 0
//[UpUIcon]: http://image.songtaste.com/images/usericon/s/default.gif
//[FavNum]: 117
//[UpUName]: 99pr
//[GradeNum]: 87
//[UserID]: 4222189
//</MusicModel>


@property(assign, nonatomic)int Click;
@property(assign, nonatomic)int DevType;
@property(assign, nonatomic)int FavNum;
@property(assign, nonatomic)int GradeNum;
@property(assign, nonatomic)int ID;
@property(strong, nonatomic)NSString *Name;
@property(strong, nonatomic)NSString *RateDT;
@property(assign, nonatomic)int RateUID;
@property(strong, nonatomic)NSString *RateUName;
@property(strong, nonatomic)NSString *Singer;
@property(strong, nonatomic)NSString *UpUIcon;
@property(strong, nonatomic)NSString *UpUName;
@property(assign, nonatomic)int UserID;


@end
