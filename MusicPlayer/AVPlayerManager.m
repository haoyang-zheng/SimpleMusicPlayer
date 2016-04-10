//
//  AVPlayerManager.m
//  musicPlayer
//
//  Created by haoyang_zheng on 16/4/9.
//  Copyright © 2016年 DAC. All rights reserved.
//

#import "AVPlayerManager.h"

#import <AVFoundation/AVFoundation.h>

@interface AVPlayerManager ()

@property (nonatomic,strong) AVPlayer *musicPlayer;

@property (nonatomic,strong,nullable) AVPlayerItem *currentItem;

@property (nonatomic,strong) NSTimer *timer;//定时器

@property (nonatomic,strong) Music *music;

@property (nonatomic,assign) BOOL isPlayMusic;//是否可以播放 （用与控制第一次打开后不会自动播放音乐，暂停时不会因为缓冲处理自动播放）

@end

@implementation AVPlayerManager
+(AVPlayerManager *)shareAVPlayerManage{
    
    static AVPlayerManager *avPlayerManage = nil;
    
    //GCD
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        avPlayerManage=  [[AVPlayerManager alloc]init];
        
    });
    
    //    //同步锁
    //
    //    @synchronized(self){
    //
    //        if(avPlayerManage == nil){
    //
    //            avPlayerManage=  [[AVPlayerManage alloc]init];
    //
    //        }
    //
    //    }
    
    return avPlayerManage;
    
    
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        
        //通过URL初始化一个AVPayer的播放器 但是  没有视图
        
        _musicPlayer = [[AVPlayer alloc]init];
        
        //初始化计时器
        
        //初始化一个NSTimer  每秒执行一次  作用：改变播放进度的UISlider的value
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(LogCurrentTime:) userInfo:nil repeats:YES];
        
        
        //默认刚初始化时暂停定时器
        
        _timer.fireDate = [NSDate distantFuture];
        
        //默认
        
        _isPlayMusic = NO;
        
    }
    return self;
}

//添加播放的歌曲

- (void)addMusic:(Music *)music{
    
    _music = music;
    
    //如果添加的音乐不为空
    
    if(_music != nil){
        
        if (_music.mp3Url != nil) {
            
            //清除之前的监控
            
            [self removeObserverFromPlayerItem:self.musicPlayer.currentItem];
            
            NSURL *url = [NSURL URLWithString:music.mp3Url];
            
            //因为AVPlayer替换歌曲只能通过AVPlayerItem替换 所以需要初始化一个AVPlayerItem
            
            self.currentItem = [AVPlayerItem playerItemWithURL:url];
            
            //通过replaceCurrentItemWithPlayerItem方法替换当前播放的歌曲
            
            [self.musicPlayer replaceCurrentItemWithPlayerItem:self.currentItem];
            
            //添加KVO监控
            
            [self addObserverToPlayerItem:self.musicPlayer.currentItem];
            
        }
        
        
    } else {
        
        //清除之前的监控
        
        [self removeObserverFromPlayerItem:self.musicPlayer.currentItem];
        
        
        self.currentItem = nil;
        
        [self.musicPlayer replaceCurrentItemWithPlayerItem:self.currentItem];
        //
        //        //清除之前的监控
        //
        //        [self removeObserverFromPlayerItem:self.musicPlayer.currentItem];
        
        
        //暂停
        
        [_musicPlayer pause];
        
        //暂停定时器，注意不能调用invalidate方法，此方法会取消，之后无法恢复
        
        self.timer.fireDate = [NSDate distantFuture];
        
    }
    
    //先判断代理是否存在 并且 是否实现了方法<音乐栏>
    
    if (self.delegateMB && [self.delegateMB respondsToSelector:@selector(playingMusic:)]) {
        
        //通过代理传递当前播放的歌曲信息
        
        [self.delegateMB playingMusic:music];
        
    }
    
    //先判断代理是否存在 并且 是否实现了方法<音乐播放视图>
    
    if (self.delegateMP && [self.delegateMP respondsToSelector:@selector(playingMusic:)]) {
        
        //通过代理传递当前播放的歌曲信息
        
        [self.delegateMP playingMusic:music];
        
    }
    
    //先判断代理是否存在 并且 是否实现了方法<音乐播放视图>
    
    if (self.delegateMPL && [self.delegateMPL respondsToSelector:@selector(playingMusic:)]) {
        
        //通过代理传递当前播放的歌曲信息
        
        [self.delegateMPL playingMusic:music];
        
    }
    
}

//重复播放上一首

- (void)repeatPlayMusic{
    
    //CMTime 是一个结构体 需要用CMTimeMakeWithSeconds去返回CMTime这个结构体 ,需要填写两个参数
    
    //参数一 具体的数值(要播放的时间)
    
    //参数二 跨度，如果改变频率的话 需要填写AVPlayer的播放频率属性
    
    [self setPlayToTime:CMTimeMakeWithSeconds(0, 1)];
    
    //播放
    
    [self playMusic];
    
}

//播放歌曲

- (BOOL)playMusic{
    
    if (self.music != nil) {
        
        [self playMusicFunction];
        
        self.isPlayMusic = YES;
        
        return YES;
        
    } else {
        
        return  NO;
        
    }
    
}

- (void)playMusicFunction{
    
    //继续开启定时器
    
    [self.timer setFireDate:[NSDate date]];
    
    [_musicPlayer play];
    
    //通过代理方法更新播放状态
    
    [self updatePlayState:YES];
    
}


//暂停歌曲

- (BOOL)pauseMusic{
    
    if (self.music != nil) {
        
        [self pauseMusicFunction];
        
        self.isPlayMusic = NO;
        
        return YES;
        
    } else {
        
        return NO;
        
    }
    
}

- (void)pauseMusicFunction{
    
    //暂停定时器，注意不能调用invalidate方法，此方法会取消，之后无法恢复
    
    self.timer.fireDate = [NSDate distantFuture];
    
    [_musicPlayer pause];
    
    //通过代理方法更新播放状态
    
    [self updatePlayState:NO];
    
}


//通过代理方法更新播放状态

- (void)updatePlayState:(BOOL)isPlay{
    
    //先判断代理是否存在 并且 是否实现了方法<音乐栏>
    
    if (self.delegateMB && [self.delegateMB respondsToSelector:@selector(isPlay:)]) {
        
        [self.delegateMB isPlay:isPlay];
        
    }
    
    //先判断代理是否存在 并且 是否实现了方法<音乐播放视图控制器>
    
    if (self.delegateMP && [self.delegateMP respondsToSelector:@selector(isPlay:)]) {
        
        [self.delegateMP isPlay:isPlay];
        
    }
    
}

//通过代理方法更新缓冲进度 nowProgress当前缓冲进度 . totalBuffer 总进度

- (void)updateBufferProgress:(CGFloat)nowBufferProgress TotalBuffer:(CGFloat)totalBufferProgress{
    
    if (totalBufferProgress > 0) {
        
        //计算进度百分比 0 - 1
        
        CGFloat percentProgress= nowBufferProgress / totalBufferProgress;
        
        
        
        //先判断代理是否存在 并且 是否实现了方法<音乐栏>
        
        if (self.delegateMB && [self.delegateMB respondsToSelector:@selector(returnNowBufferProgress:)]) {
            
            [self.delegateMB returnNowBufferProgress:percentProgress];
            
        }
        
        //先判断代理是否存在 并且 是否实现了方法<音乐播放视图控制器>
        
        if (self.delegateMP && [self.delegateMP respondsToSelector:@selector(isPlay:)]) {
            
            [self.delegateMP returnNowBufferProgress:percentProgress];
            
        }
        
    }
    
    
}


//当前播放状态 播放/暂停

- (BOOL)isPlay{
    
    //rate 等于0 说明暂停 等于1 正在播放
    
    return _musicPlayer.rate;
    
}


//当前正在播放的歌曲

- (Music *)playingMusic{
    
    return self.music;
    
}


//设置播放时间

- (void)setPlayToTime:(CMTime)time{
    
    //CMTime 是一个结构体 需要用CMTimeMakeWithSeconds去返回CMTime这个结构体 ,需要填写两个参数
    
    //参数一 具体的数值(slider的value)
    
    //参数二 跨度，如果改变频率的话 需要填写AVPlayer的播放频率属性
    
    [_musicPlayer seekToTime:time];
    
}

//总播放时长

- (CGFloat)getDurationTime{
    
    return self.music.duration;
    
}


//读取当前播放的音量

- (CGFloat)getPlayVolume{
    
    return _musicPlayer.volume;
    
}

//修改当前播放的音量

- (void)setPlayVolume:(CGFloat)volume{
    
    _musicPlayer.volume = volume;
    
}

#pragma mark ---AVPlayer监控

/**
 *  给AVPlayerItem添加监控
 *
 *  @param playerItem AVPlayerItem对象
 */

-(void)addObserverToPlayerItem:(AVPlayerItem *)playerItem{
    
    //监控状态属性，注意AVPlayer也有一个status属性，通过监控它的status也可以获得播放状态
    
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    //监控网络加载情况属性
    
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    
}

-(void)removeObserverFromPlayerItem:(AVPlayerItem *)playerItem{
    
    
    
    [playerItem removeObserver:self forKeyPath:@"status"];
    
    [playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    
}

/**
 *  通过KVO监控播放器状态
 *
 *  @param keyPath 监控属性
 *  @param object  监视器
 *  @param change  状态改变
 *  @param context 上下文
 */

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    AVPlayerItem *playerItem=object;
    
    if ([keyPath isEqualToString:@"status"]) {
        
        AVPlayerStatus status= [[change objectForKey:@"new"] intValue];
        
        if(status==AVPlayerStatusReadyToPlay){
            
            NSLog(@"正在播放...%@,总长度:%.2f" , self.music.name , CMTimeGetSeconds(playerItem.duration));
            
            //为当前播放的歌曲数据模型赋值歌曲总时长
            
            self.music.duration = [[NSString stringWithFormat:@"%.2f",CMTimeGetSeconds(playerItem.duration) ] floatValue] ;//保留小数点后两位
            
            //先判断代理是否存在 并且 是否实现了方法<音乐播放视图控制器>
            
            if (self.delegateMP && [self.delegateMP respondsToSelector:@selector(returnDurationTime:)]) {
                
                //通过代理传递歌曲总时长
                
                [self.delegateMP returnDurationTime:self.music.duration];
                
            }
            
        }
        
    }else if([keyPath isEqualToString:@"loadedTimeRanges"]){
        
        NSArray *array=playerItem.loadedTimeRanges;
        
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//本次缓冲时间范围
        
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        
        NSTimeInterval totalBuffer = startSeconds + durationSeconds;//缓冲总长度
        
        totalBuffer = [[NSString stringWithFormat:@"%.2f", totalBuffer] floatValue];//保留小数点后两位
        
        NSLog(@"共缓冲：%.2f",totalBuffer);
        
        //更新缓冲进度
        
        [self updateBufferProgress:totalBuffer TotalBuffer:CMTimeGetSeconds(playerItem.duration)];
        
        
        //缓冲进度处理
        
        [self bufferHandle:totalBuffer];
        
        
        
    }
    
}

//缓冲进度处理

- (void)bufferHandle:(CGFloat)totalBuffer{
    
    //判断起始播放
    
    if (totalBuffer > 10) {
        
        //判断是否可以播放 不可以不进行缓冲处理 不自动播放
        
        if (self.isPlayMusic == YES) {
            
            //缓冲大于10秒 播放歌曲
            
            [self playMusicFunction];
            
            //获取当前播放时间
            
            CGFloat nowTimeFloat = (float) self.musicPlayer.currentTime.value/self.musicPlayer.currentTime.timescale;
            
            //判断当前播放进度 是否将要等于缓冲的进度
            
            if (nowTimeFloat <= totalBuffer - 10) {
                
                //播放进度大于10秒接近缓冲进度 继续播放歌曲
                
                [self playMusicFunction];
                
            } else {
                
                //如果缓冲进度等于歌曲总时长 说明缓冲完成 如果不等于 说明没有缓冲完成
                
                if ((int)totalBuffer != (int)self.music.duration) {
                    
                    //播放进度小于10秒接近缓冲进度 暂停播放歌曲
                    
                    [self pauseMusicFunction];
                    
                }else{
                    
                    //播放进度大于10秒接近缓冲进度 继续播放歌曲
                    
                    [self playMusicFunction];
                    
                }
                
            }
            
            
        }
        
    } else {
        
        //缓冲小于10秒 先暂停 等待缓冲
        
        [self pauseMusicFunction];
        
    }
    
    
}



#pragma mark----定时器方法

-(void)LogCurrentTime:(NSTimer *)timer{
    
    //    AVPlayer的current的返回值是一个CNTime的结构体  如果想获取秒数  需要用结构体里面的value/timerscale
    
    //    NSLog(@"%lld",self.musicPlayer.currentTime.value/self.musicPlayer.currentTime.timescale);
    
    //    NSInteger nowTimeInteger = self.musicPlayer.currentTime.value/self.musicPlayer.currentTime.timescale;
    
    CGFloat nowTimeFloat = (float) self.musicPlayer.currentTime.value/self.musicPlayer.currentTime.timescale;
    
    nowTimeFloat = [[NSString stringWithFormat:@"%.2f",nowTimeFloat ] floatValue];
    
    //先判断代理是否存在 并且 是否实现了方法<音乐栏>
    
    if (self.delegateMB && [self.delegateMB respondsToSelector:@selector(returnNowPlayTime:)]) {
        
        //返回当前播放时间
        
        [self.delegateMB returnNowPlayTime:nowTimeFloat];
        
    }
    
    //先判断代理是否存在 并且 是否实现了方法<音乐栏>
    
    if (self.delegateMB && [self.delegateMB respondsToSelector:@selector(returnNowPlayProgress:)]) {
        
        //返回当前播放进度
        
        [self.delegateMB returnNowPlayProgress: (nowTimeFloat / self.music.duration)];
        
    }
    
    
    //先判断代理是否存在 并且 是否实现了方法<音乐播放视图控制器>
    
    if (self.delegateMP && [self.delegateMP respondsToSelector:@selector(returnNowPlayTime:)]) {
        
        //返回当前播放时间
        
        [self.delegateMP returnNowPlayTime:nowTimeFloat];
        
    }
    
    //先判断代理是否存在 并且 是否实现了方法<音乐播放视图控制器>
    
    if (self.delegateMP && [self.delegateMP respondsToSelector:@selector(returnNowPlayProgress:)]) {
        
        //返回当前播放进度
        
        [self.delegateMP returnNowPlayProgress: (nowTimeFloat / self.music.duration)];
        
    }
    
    
    
    //如果当前播放时间等于歌曲时长 表示已经该歌曲已经播放完
    
    if (self.musicPlayer.rate == 0) {
        
        //先判断代理是否存在 并且 是否实现了方法
        
        if (self.delegateMPLM && [self.delegateMPLM respondsToSelector:@selector(musicPlayEnd:)]) {
            
            //歌曲已播放完 (参数当前播放的歌曲)
            
            [self.delegateMPLM musicPlayEnd:self.music];
            
        }
        
    }
    
}


#pragma mark ---LazyLoading

- (AVPlayer *)musicPlayer{
    
    if (_musicPlayer == nil) {
        
        _musicPlayer = [[AVPlayer alloc]initWithPlayerItem:self.currentItem];
        
    }
    
    return _musicPlayer;
    
}

- (AVPlayerItem *)currentItem{
    
    if (_currentItem == nil) {
        
        _currentItem = [[AVPlayerItem alloc] initWithURL:nil];
        
    }
    
    return _currentItem;
    
}




@end
