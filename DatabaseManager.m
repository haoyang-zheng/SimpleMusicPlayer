//
//  DatabaseManager.m
//  musicPlayer
//
//  Created by haoyang_zheng on 16/4/9.
//  Copyright © 2016年 DAC. All rights reserved.
//
#import "DatabaseManager.h"

static DatabaseManager *manager = nil;

@implementation DatabaseManager


+(DatabaseManager *)shareDatabaseManager{
    
    @synchronized(self){
        
        if (manager == nil) {
            
            manager = [[DatabaseManager alloc]init];
            
        }
        
        return manager;
        
    }
    
}

#pragma mark -- 获取documents路径

- (NSString *)documentsPath{
    
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);         //返回程序Documents目录
    
    return array.firstObject;
    
}




//创建数据库对象

- (void)createDB{
    
    NSString *dbPath = [[self documentsPath] stringByAppendingPathComponent:@"MusicPlayerDB.sqlite"];
    
    self.db = [FMDatabase databaseWithPath:dbPath];
    
    NSLog(@"数据库地址 %@",dbPath);
    
}

#pragma mark --收藏
//创建收藏列表

-(void)createCollectMusicPlayer{
    
    //打开数据库
    
    if ([self.db open]) {
        
        //创建表
        
        [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS 'c_music' ('db_id' INTEGER NOT NULL , 'mid' INTEGER , 'album' TEXT, 'name' TEXT,'artistsName' TEXT,'singer' TEXT,'blurPicUrl' TEXT,'picUrl' TEXT,'duration' integer,'lyric' TEXT,'mp3Url' TEXT,'like' integer DEFAULT 0,'newly' integer DEFAULT 0,'download' integer DEFAULT 0 ,'downloadPath' TEXT, PRIMARY KEY('db_id') );"];
        
    }
    
}


//获取收藏列表所有歌曲信息
- (NSMutableArray *)selectCollectMusicPlayer{
    
    NSMutableArray *collectDataArray = [[NSMutableArray alloc]init];
    
    //打开数据库
    
    if ([self.db open]) {
        
        //得到结果集
        
        FMResultSet *set = [self.db executeQuery:@"SELECT * FROM c_music  ORDER BY db_id DESC ;"];
        
        while (set.next) {
            
            //创建对象赋值
            
            Music *item = [[Music alloc]init];
            
            item.mid = [[set stringForColumn:@"mid"] integerValue];
            
            item.album = [set stringForColumn:@"album"];
            
            item.name = [set stringForColumn:@"name"];
            
            item.artistsName = [set stringForColumn:@"artistsName"];
            
            item.singer = [set stringForColumn:@"singer"];
            
            item.blurPicUrl = [set stringForColumn:@"blurPicUrl"];
            
            item.picUrl = [set stringForColumn:@"picUrl"];
            
            item.duration = [[set stringForColumn:@"duration"] floatValue];
            
            item.lyric = [set stringForColumn:@"lyric"];
            
            item.mp3Url = [set stringForColumn:@"mp3Url"];
            
            item.db_id = [[set stringForColumn:@"db_id"] integerValue];
            
            item.like = [[set stringForColumn:@"like"] integerValue];
            
            item.newly = [[set stringForColumn:@"newly"] integerValue];
            
            item.download = [[set stringForColumn:@"download"] integerValue];
            
            item.downloadPath = [set stringForColumn:@"downloadPath"];
            
            [collectDataArray addObject:item];
            
        }
        
        NSLog(@" 数据库查询 : %@",collectDataArray);
        
    }
    
    
    return collectDataArray;
    
}

//根据数据库ID查询

- (Music *)selectCollectMusicPlayer:(NSInteger)dbID{
    
    Music *item = nil;
    
    //打开数据库
    
    if ([self.db open]) {
        
        //得到结果集
        
        FMResultSet *set = [self.db executeQueryWithFormat:@"SELECT * FROM c_music WHERE db_id = %ld ;",dbID];
        
        while (set.next) {
            
            //创建对象赋值
            
            item = [[Music alloc]init];
            
            item.mid = [[set stringForColumn:@"mid"] integerValue];
            
            item.album = [set stringForColumn:@"album"];
            
            item.name = [set stringForColumn:@"name"];
            
            item.artistsName = [set stringForColumn:@"artistsName"];
            
            item.singer = [set stringForColumn:@"singer"];
            
            item.blurPicUrl = [set stringForColumn:@"blurPicUrl"];
            
            item.picUrl = [set stringForColumn:@"picUrl"];
            
            item.duration = [[set stringForColumn:@"duration"] floatValue];
            
            item.lyric = [set stringForColumn:@"lyric"];
            
            item.mp3Url = [set stringForColumn:@"mp3Url"];
            
            item.db_id = [[set stringForColumn:@"db_id"] integerValue];
            
            item.like = [[set stringForColumn:@"like"] integerValue];
            
            item.newly = [[set stringForColumn:@"newly"] integerValue];
            
            item.download = [[set stringForColumn:@"download"] integerValue];
            
            item.downloadPath = [set stringForColumn:@"downloadPath"];
            
            
        }
        
    }
    
    return item;
    
    
}


//根据音乐ID查询

- (Music *)selectCollectMusicPlayerWithMID:(NSInteger)mID{
    
    Music *item = nil;
    
    //打开数据库
    
    if ([self.db open]) {
        
        //得到结果集
        
        FMResultSet *set = [self.db executeQueryWithFormat:@"SELECT * FROM c_music WHERE mid = %ld ;",mID];
        
        while (set.next) {
            
            //创建对象赋值
            
            item = [[Music alloc]init];
            
            item.mid = [[set stringForColumn:@"mid"] integerValue];
            
            item.album = [set stringForColumn:@"album"];
            
            item.name = [set stringForColumn:@"name"];
            
            item.artistsName = [set stringForColumn:@"artistsName"];
            
            item.singer = [set stringForColumn:@"singer"];
            
            item.blurPicUrl = [set stringForColumn:@"blurPicUrl"];
            
            item.picUrl = [set stringForColumn:@"picUrl"];
            
            item.duration = [[set stringForColumn:@"duration"] floatValue];
            
            item.lyric = [set stringForColumn:@"lyric"];
            
            item.mp3Url = [set stringForColumn:@"mp3Url"];
            
            item.db_id = [[set stringForColumn:@"db_id"] integerValue];
            
            item.like = [[set stringForColumn:@"like"] integerValue];
            
            item.newly = [[set stringForColumn:@"newly"] integerValue];
            
            item.download = [[set stringForColumn:@"download"] integerValue];
            
            item.downloadPath = [set stringForColumn:@"downloadPath"];
            
            
        }
        
    }
    
    return item;
    
    
}






//添加音乐

- (BOOL)insertCollectMusicPlayer:(Music *)musicItem{
    
    return [self.db executeUpdateWithFormat:@"INSERT INTO 'c_music' ( 'mid', 'album', 'name', 'artistsName', 'singer', 'blurPicUrl', 'picUrl', 'duration', 'lyric', 'mp3Url', 'like', 'newly', 'download', 'downloadPath') VALUES (  %ld , %@  , %@  ,%@  ,%@  ,%@  ,%@  ,%f ,%@  ,%@ , %ld ,%ld , %ld , %@ ) ;", musicItem.mid , musicItem.album , musicItem.name , musicItem.artistsName , musicItem.singer , musicItem.blurPicUrl , musicItem.picUrl  , musicItem.duration , musicItem.lyric , musicItem.mp3Url , musicItem.like  , musicItem.newly , musicItem.download , musicItem.downloadPath  ];
    
}



//删除音乐

- (BOOL)deleteCollcetMusicPlayer:(NSInteger)dbID{
    
    return [self.db executeUpdateWithFormat:@"DELETE FROM c_music WHERE  db_id = %ld;",dbID];
}

//删除全部

- (BOOL)deleteCollectMusicPlayer{
    
    return [self.db executeUpdateWithFormat:@"DELETE FROM c_music ;"];
    
}


#pragma mark --音乐播放列表

//创建音乐播放表

- (void)createMusicPlayer{
    
    //打开数据库
    
    if ([self.db open]) {
        
        //创建表
        
        [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS 't_music' ('db_id' INTEGER NOT NULL , 'mid' INTEGER , 'album' TEXT, 'name' TEXT,'artistsName' TEXT,'singer' TEXT,'blurPicUrl' TEXT,'picUrl' TEXT,'duration' integer,'lyric' TEXT,'mp3Url' TEXT,'like' integer DEFAULT 0,'newly' integer DEFAULT 0,'download' integer DEFAULT 0 ,'downloadPath' TEXT, PRIMARY KEY('db_id') );"];
        
    }
    
}

//查询播放列表所有音乐

- (NSMutableArray *)selectMusicPlayer{
    
    NSMutableArray *dataArray = [[NSMutableArray alloc]init];
    
    //打开数据库
    
    if ([self.db open]) {
        
        //得到结果集
        
        FMResultSet *set = [self.db executeQuery:@"SELECT * FROM t_music  ORDER BY db_id DESC ;"];
        
        while (set.next) {
            
            //创建对象赋值
            
            Music *item = [[Music alloc]init];
            
            item.mid = [[set stringForColumn:@"mid"] integerValue];
            
            item.album = [set stringForColumn:@"album"];
            
            item.name = [set stringForColumn:@"name"];
            
            item.artistsName = [set stringForColumn:@"artistsName"];
            
            item.singer = [set stringForColumn:@"singer"];
            
            item.blurPicUrl = [set stringForColumn:@"blurPicUrl"];
            
            item.picUrl = [set stringForColumn:@"picUrl"];
            
            item.duration = [[set stringForColumn:@"duration"] floatValue];
            
            item.lyric = [set stringForColumn:@"lyric"];
            
            item.mp3Url = [set stringForColumn:@"mp3Url"];
            
            item.db_id = [[set stringForColumn:@"db_id"] integerValue];
            
            item.like = [[set stringForColumn:@"like"] integerValue];
            
            item.newly = [[set stringForColumn:@"newly"] integerValue];
            
            item.download = [[set stringForColumn:@"download"] integerValue];
            
            item.downloadPath = [set stringForColumn:@"downloadPath"];
            
            [dataArray addObject:item];
            
        }
        
        NSLog(@" 数据库查询 : %@",dataArray);
        
    }
    
    
    return dataArray;
    
}

//根据数据库ID查询

- (Music *)selectMusicPlayer:(NSInteger)dbID{
    
    Music *item = nil;
    
    //打开数据库
    
    if ([self.db open]) {
        
        //得到结果集
        
        FMResultSet *set = [self.db executeQueryWithFormat:@"SELECT * FROM t_music WHERE db_id = %ld ;",dbID];
        
        while (set.next) {
            
            //创建对象赋值
            
            item = [[Music alloc]init];
            
            item.mid = [[set stringForColumn:@"mid"] integerValue];
            
            item.album = [set stringForColumn:@"album"];
            
            item.name = [set stringForColumn:@"name"];
            
            item.artistsName = [set stringForColumn:@"artistsName"];
            
            item.singer = [set stringForColumn:@"singer"];
            
            item.blurPicUrl = [set stringForColumn:@"blurPicUrl"];
            
            item.picUrl = [set stringForColumn:@"picUrl"];
            
            item.duration = [[set stringForColumn:@"duration"] floatValue];
            
            item.lyric = [set stringForColumn:@"lyric"];
            
            item.mp3Url = [set stringForColumn:@"mp3Url"];
            
            item.db_id = [[set stringForColumn:@"db_id"] integerValue];
            
            item.like = [[set stringForColumn:@"like"] integerValue];
            
            item.newly = [[set stringForColumn:@"newly"] integerValue];
            
            item.download = [[set stringForColumn:@"download"] integerValue];
            
            item.downloadPath = [set stringForColumn:@"downloadPath"];
            
            
        }
        
    }
    
    return item;
    
    
}


//根据音乐ID查询

- (Music *)selectMusicPlayerWithMID:(NSInteger)mID{
    
    Music *item = nil;
    
    //打开数据库
    
    if ([self.db open]) {
        
        //得到结果集
        
        FMResultSet *set = [self.db executeQueryWithFormat:@"SELECT * FROM t_music WHERE mid = %ld ;",mID];
        
        while (set.next) {
            
            //创建对象赋值
            
            item = [[Music alloc]init];
            
            item.mid = [[set stringForColumn:@"mid"] integerValue];
            
            item.album = [set stringForColumn:@"album"];
            
            item.name = [set stringForColumn:@"name"];
            
            item.artistsName = [set stringForColumn:@"artistsName"];
            
            item.singer = [set stringForColumn:@"singer"];
            
            item.blurPicUrl = [set stringForColumn:@"blurPicUrl"];
            
            item.picUrl = [set stringForColumn:@"picUrl"];
            
            item.duration = [[set stringForColumn:@"duration"] floatValue];
            
            item.lyric = [set stringForColumn:@"lyric"];
            
            item.mp3Url = [set stringForColumn:@"mp3Url"];
            
            item.db_id = [[set stringForColumn:@"db_id"] integerValue];
            
            item.like = [[set stringForColumn:@"like"] integerValue];
            
            item.newly = [[set stringForColumn:@"newly"] integerValue];
            
            item.download = [[set stringForColumn:@"download"] integerValue];
            
            item.downloadPath = [set stringForColumn:@"downloadPath"];
            
            
        }
        
    }
    
    return item;
    
    
}






//添加音乐

- (BOOL)insertMusicPlayer:(Music *)musicItem{
    
    return [self.db executeUpdateWithFormat:@"INSERT INTO 't_music' ( 'mid', 'album', 'name', 'artistsName', 'singer', 'blurPicUrl', 'picUrl', 'duration', 'lyric', 'mp3Url', 'like', 'newly', 'download', 'downloadPath') VALUES (  %ld , %@  , %@  ,%@  ,%@  ,%@  ,%@  ,%f ,%@  ,%@ , %ld ,%ld , %ld , %@ ) ;", musicItem.mid , musicItem.album , musicItem.name , musicItem.artistsName , musicItem.singer , musicItem.blurPicUrl , musicItem.picUrl  , musicItem.duration , musicItem.lyric , musicItem.mp3Url , musicItem.like  , musicItem.newly , musicItem.download , musicItem.downloadPath  ];
    
}



//删除音乐

- (BOOL)deleteMusicPlayer:(NSInteger)dbID{
    
    return [self.db executeUpdateWithFormat:@"DELETE FROM t_music WHERE  db_id = %ld;",dbID];
}

//删除全部

- (BOOL)deleteMusicPlayer{
    
    return [self.db executeUpdateWithFormat:@"DELETE FROM t_music ;"];
    
}

@end
