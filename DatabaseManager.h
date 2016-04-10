//
//  DatabaseManager.h
//  musicPlayer
//
//  Created by haoyang_zheng on 16/4/9.
//  Copyright © 2016年 DAC. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <FMDB.h>

#import "Music.h"

@interface DatabaseManager : NSObject

@property (nonatomic,strong)FMDatabase *db;

+(DatabaseManager*)shareDatabaseManager;

/// @brief 获取documents路径

-(NSString *)documentsPath;

///  @brief 创建数据库对象

-(void)createDB;

///  @brief 创建音乐播放表

-(void)createMusicPlayer;

///  @brief  查询播放列表所有音乐

-(NSMutableArray*)selectMusicPlayer;

/// @brief 根据数据库ID查询

-(Music*)selectMusicPlayer:(NSInteger)dbID;

///  @brief 根据音乐ID查询

-(Music*)selectMusicPlayerWithMID:(NSInteger)mID;

/// @brief  添加音乐

-(BOOL)insertMusicPlayer:(Music *)musicItem;

/// @brief  删除音乐

-(BOOL)deleteMusicPlayer:(NSInteger)dbID;

/// @brief  删除全部

-(BOOL)deleteMusicPlayer;

//收藏列表

-(void)createCollectMusicPlayer;

- (NSMutableArray *)selectCollectMusicPlayer;

- (Music *)selectCollectMusicPlayer:(NSInteger)dbID;

- (BOOL)insertCollectMusicPlayer:(Music *)musicItem;

- (BOOL)deleteCollcetMusicPlayer:(NSInteger)dbID;

- (Music *)selectCollectMusicPlayerWithMID:(NSInteger)mID;

- (BOOL)deleteCollectMusicPlayer;

@end
