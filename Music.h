//
//  Music.h
//  musicPlayer
//
//  Created by haoyang_zheng on 16/4/9.
//  Copyright © 2016年 DAC. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface Music : NSObject

@property (nonatomic , assign) NSInteger mid;//歌曲ID

@property (nonatomic , copy) NSString *album;//专辑名

@property (nonatomic , copy) NSString *name;//歌曲名称

@property (nonatomic , copy) NSString *artistsName;//作者名

@property (nonatomic , copy) NSString *singer;//歌手

@property (nonatomic , copy) NSString *blurPicUrl;//模糊图片URL

@property (nonatomic , copy) NSString *picUrl;//专辑图片URL

@property (nonatomic , assign) CGFloat duration;//播放时长

@property (nonatomic , copy) NSString *lyric;//歌词

@property (nonatomic , copy) NSString *mp3Url;//歌曲URL

@property (nonatomic , assign) NSInteger db_id;//数据库ID

@property (nonatomic , assign) NSInteger like;//是否为喜欢 0 - 1

@property (nonatomic , assign) NSInteger newly;//是否为最近播放 0 - 1

@property (nonatomic , assign) NSInteger download;//是否已经下载 0 - 1

@property (nonatomic , copy) NSString *downloadPath;//下载本地路径
@end
