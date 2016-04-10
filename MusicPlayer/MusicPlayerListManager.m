//
//  MusicPlayerListManager.m
//  musicPlayer
//
//  Created by haoyang_zheng on 16/4/9.
//  Copyright © 2016年 DAC. All rights reserved.
//

#import "MusicPlayerListManager.h"

#import "AVPlayerManager.h"

#import "DatabaseManager.h"

@interface MusicPlayerListManager ()<AVPlayerManageDelegate>

@property (nonatomic,strong)AVPlayerManager *avPlayer;//音乐播放管理

@property (nonatomic,strong)DatabaseManager *db; //数据库

@property (nonatomic,strong)NSMutableArray *datatArray;//数据源数组

@property (nonatomic,strong)Music *music;//当前播放的歌曲

@end

@implementation MusicPlayerListManager

+(MusicPlayerListManager *)shareMusicPlayerListManage{
    
    static MusicPlayerListManager *manage = nil;
    
    //GCD
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        manage=  [[MusicPlayerListManager alloc]init];
        
    });
    
    
    //    //同步锁
    //
    //    @synchronized(self){
    //
    //        if(manage == nil){
    //
    //            manage=  [[MusicPlayerListManage alloc]init];
    //
    //        }
    //
    //    }
    
    return manage;
    
}

#pragma mark ---lazyLoading

-(DatabaseManager *)db{
    
    if (_db == nil) {
        
        //获取数据库管理对象
        
        _db = [DatabaseManager shareDatabaseManager];
        
        //创建数据库对象
        
        [_db createDB];
        
        //创建音乐播放表
        
        [_db createMusicPlayer];
        
    }
    
    return _db;
    
}

- (AVPlayerManager *)avPlayer{
    
    if (_avPlayer == nil) {
        
        _avPlayer = [AVPlayerManager shareAVPlayerManage];
        
        _avPlayer.delegateMPLM = self;//设置播放列表代理
        
    }
    
    return _avPlayer;
    
}

- (NSMutableArray *)datatArray{
    
    if (_datatArray == nil) {
        
        _datatArray = [self selectAllMusic];
        
    }
    
    if (_datatArray.count == 0) {
        
        _datatArray = [self selectAllMusic];//查询全部
        
    }
    
    return _datatArray;
    
}



#pragma mark ---AVPlayerManageDelegate

-(void)musicPlayEnd:(Music *)music{
    
    //当前歌曲播放完
    
    //根据播放模式执行下一次播放
    
    //--获取本地循环类型
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    NSInteger cycleType = [defaults integerForKey:@"cycleType"];
    
    switch (cycleType) {
            
        case 0:
            
            //单曲循环
            
            [self musicIsSingleCycle:music];
            
            break;
            
        case 1:
            
            //顺序播放
            
            [self musicIsSequentialCycle:music];
            
            break;
            
        case 2:
            
            //随机播放
            
            [self musicIsRandomCycle:music];
            
            break;
            
        default:
            
            break;
    }
    
}

#pragma mark ---循环播放

//单曲循环

- (void)musicIsSingleCycle:(Music *)music{
    
    //重复播放上一首
    
    [self.avPlayer repeatPlayMusic];
    
}

//顺序循环

- (void)musicIsSequentialCycle:(Music *)music{
    
    //调用播放下一首方法
    
    [self nextPlayMusic:music];
    
}

//随机循环

- (void)musicIsRandomCycle:(Music *)music{
    
    //生成0 - 数据原数组元素个数的随机一个下标
    
    NSInteger index = arc4random() % (self.datatArray.count - 1);
    
    //获取随机歌曲
    
    Music *randomMusic = [self.datatArray objectAtIndex:index];
    
    //将随机歌曲通过代理发送给播放控制器
    
    [self sendMusicToAVPlayerManage:randomMusic];
    
}




#pragma mark ---列表全部歌曲

- (NSMutableArray *)selectAllMusic{
    
    return  [self.db selectMusicPlayer];
    
}

#pragma mark ---删除单首歌曲

- (BOOL)deleteMusicWithMusic:(Music *)music{
    
    BOOL result = [self.db deleteMusicPlayer:music.db_id];
    
    if (result) {
        
        NSLog(@"删除'%@'歌曲成功",music.name);
        
        //更新数据源数组
        
        self.datatArray = [self selectAllMusic];
        
        //判断删除的歌曲是否为正在播放的歌曲 如果是播放下一首歌
        
        if (self.music.db_id == music.db_id) {
            
            //播放下一首歌曲
            
            [self lastPlayMusic:self.music];
            
        }
        
    }else{
        
        NSLog(@"删除'%@'歌曲失败",music.name);
        
    }
    
    return result;
}

#pragma mark ---删除全部歌曲

- (BOOL)deleteAllMusic{
    
    BOOL result = [self.db deleteMusicPlayer];
    
    if (result) {
        
        NSLog(@"删除全部歌曲成功");
        
        //更新数据源数组
        
        self.datatArray = [self selectAllMusic];
        
        //清空当前播放的歌曲
        
        self.music = nil;
        
        //向播放控制器发送空歌曲信息
        
        [self sendMusicToAVPlayerManage:self.music];
        
        
    }else{
        
        NSLog(@"删除全部歌曲失败");
        
    }
    
    
    
    return result;
    
}


#pragma mark ---播放指定歌曲

- (void)playMusicWithMusic:(Music *)music{
    
    //通过代理给播放控制器发送歌曲播放
    
    [self sendMusicToAVPlayerManage:music];
    
}




#pragma mark ---添加歌曲到播放列表

- (void)addMusicToPlayerList:(Music *)music{
    
    //查询要添加的歌曲是否已经存在
    
    Music *tempMusic = [self.db selectMusicPlayerWithMID:music.mid];
    
    if (tempMusic == nil) {
        
        if ([self.db insertMusicPlayer:music]) {
            
            NSLog(@"歌曲添加成功");
            
            //通过代理给播放控制器发送歌曲播放
            
            [self sendMusicToAVPlayerManage:[self.db selectMusicPlayerWithMID:music.mid]];
            
            //更新数据源数组
            
            self.datatArray = [self.db selectMusicPlayer];
            
            
        } else {
            
            NSLog(@"歌曲添加失败");
            
        }
        
    } else {
        
        NSLog(@"要添加的歌曲已经存在列表中");
        
        //通过代理给播放控制器发送歌曲播放
        
        [self sendMusicToAVPlayerManage:tempMusic];
        
    }
    
    
}

//查找当前播放歌曲在列表的数据源数组中的下标位置

- (NSInteger)selectMusicIndexWithMusic:(Music *)music{
    
    NSInteger index = 0;
    
    //遍历查找当前播放歌曲在列表的数据源数组中的下标位置
    
    for (int i = 0; i < self.datatArray.count ; i++) {
        
        Music *item = [self.datatArray objectAtIndex:i];
        
        if (item.db_id == music.db_id) {
            
            index = i;
            
        }
        
    }
    
    return index;
    
}

#pragma mark ---播放上一首

- (void)lastPlayMusic:(Music *)music{
    
    //查找当前播放歌曲在列表的数据源数组中的下标位置
    
    NSInteger index = [self selectMusicIndexWithMusic:music];
    
    if (index > 0 ) {
        
        index--;
        
    } else {
        
        index = self.datatArray.count - 1;
    }
    
    //获取上一首歌曲
    
    Music *lastMusic = [self.datatArray objectAtIndex:index];
    
    //将上一首歌曲通过代理发送给播放控制器
    
    [self sendMusicToAVPlayerManage:lastMusic];
    
    
}

#pragma mark ---播放下一首

- (void)nextPlayMusic:(Music *)music{
    
    
    //查找当前播放歌曲在列表的数据源数组中的下标位置
    
    NSInteger index = [self selectMusicIndexWithMusic:music];
    
    if (index < self.datatArray.count - 1 ) {
        
        index++;
        
    } else {
        
        index = 0;
    }
    
    //获取下一首歌曲
    
    Music *nextMusic = [self.datatArray objectAtIndex:index];
    
    //将下一首歌曲通过代理发送给播放控制器
    
    [self sendMusicToAVPlayerManage:nextMusic];
    
}


#pragma mark ---当前歌曲的上一首 (如果没有上一首 返回nil)

- (Music *)lastPlayingMusic{
    
    
    //查找当前播放歌曲在列表的数据源数组中的下标位置
    
    NSInteger index = [self selectMusicIndexWithMusic:self.music];
    
    if (index > 0 ) {
        
        index--;
        
    } else if(index == 0){
        
        index = 0;
        
    } else {
        
        index = self.datatArray.count - 1;
    }
    
    //获取上一首歌曲
    
    Music *lastMusic = [self.datatArray objectAtIndex:index];
    
    return lastMusic;
    
}

#pragma mark ---当前歌曲的下一首 (如果没有下一首 返回nil)

- (Music *)nextPlayingMusic{
    
    //查找当前播放歌曲在列表的数据源数组中的下标位置
    
    NSInteger index = [self selectMusicIndexWithMusic:self.music];
    
    if (index < self.datatArray.count - 1 ) {
        
        index++;
        
    } else {
        
        index = 0;
    }
    
    //获取下一首歌曲
    
    Music *nextMusic = [self.datatArray objectAtIndex:index];
    
    return nextMusic;
    
}


#pragma mark ---当前正在播放的歌曲

- (Music *)playingMusic{
    
    return self.music;
    
}


#pragma mark ---获取上一次关闭应用时的歌曲信息

- (Music *)newlyPlayMusic{
    
    //--获取上次关闭应用前播放的歌曲
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    NSInteger musicDBID = [defaults integerForKey:@"music_db_id"];
    
    self.music = [self.db selectMusicPlayer:musicDBID];
    
    //为AVPlayer添加歌曲
    
    [self.avPlayer addMusic:self.music];
    
    [self.avPlayer pauseMusic];
    
    return self.music;
    
    
}





#pragma mark ---通过代理向播放控制器发送歌曲

- (void)sendMusicToAVPlayerManage:(Music *)music{
    
    //如果要播放的歌曲url与当前播放的歌曲的url相同 直接重新播放上一首
    
    if ([music.mp3Url isEqualToString:self.music.mp3Url]) {
        
        //重新播放上一首
        
        [self.avPlayer repeatPlayMusic];
        
    } else {
        
        self.music = music;
        
        //为AVPlayer添加歌曲
        
        [self.avPlayer addMusic:music];
        
        //AVPlayer播放歌曲
        
        [self.avPlayer playMusic];
        
        //持久化存播放歌曲的数据库ID
        
        //1.获取NSUserDefaults对象
        
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        
        //2.读取保存的数据
        
        [defaults setInteger:music.db_id forKey:@"music_db_id"];
        
        //3.强制让数据立刻保存
        
        [defaults synchronize];
        
    }
    
    
    
    
    
    
}



@end
