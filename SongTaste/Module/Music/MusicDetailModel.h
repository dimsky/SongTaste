//
//  MusicDetailModel.h
//  SongTaste
//
//  Created by William on 15/4/28.
//  Copyright (c) 2015年 dimsky. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface MusicDetailModel : JSONModel

//<req>
//<code>1</code>
//<singer_name>1956.烟蒂</singer_name>
//<song_name>戴上耳机必听的节奏RNB丶这口技太赞了丶Keep It In The Closet</song_name>
//<url>
//http://ma.songtaste.com/201504281139/c1ad98a5773d7805546ee78ecf6d26b0/a/a0/a03bb1076afbc893b726c93d3eecb83d.mp3
//</url>
//<mlength>234.00</mlength>
//<msize>9403328</msize>
//<mbitrate>320000</mbitrate>
//<iscollection>0</iscollection>
//</req>


//<MusicDetailModel>
//[Msize]: 1711993
//[singer_name]: 菅野洋子
//[Mlength]: 106
//[code]: 1
//[song_name]: 心之树
//[Mbitrate]: 128000
//[iscollection]: 0
//[url]: http://mc.songtaste.com/201504281156/641ae5d4034df2326d706d...
//</MusicDetailModel>



@property (strong, nonatomic)NSString *code;
@property (strong, nonatomic)NSString *singer_name;
@property (strong, nonatomic)NSString *song_name;
@property (strong, nonatomic)NSString *url;
@property (assign, nonatomic)long Mlength; // 秒
@property (assign, nonatomic)long Msize;  //大小
@property (assign, nonatomic)long Mbitrate;
@property (assign, nonatomic)int iscollection;



@end
