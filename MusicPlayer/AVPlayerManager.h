//
//  AVPlayerManager.h
//  musicPlayer
//
//  Created by haoyang_zheng on 16/4/9.
//  Copyright © 2016年 DAC. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

#import "Music.h"

#import <CoreMedia/CMTime.h>

@protocol AVPlayerManageDelegate <NSObject>

@optional //代表以下方法可实现 可不实现

// 歌曲总时长

-(void)returnDurationTime:(CGFloat)time;

// 当前播放时间

- (void)returnNowPlayTime:(CGFloat)time;

// 当前播放进度

- (void)returnNowPlayProgress:(CGFloat)Progress;

// 当前缓冲进度

- (void)returnNowBufferProgress:(CGFloat)Progress;


// 当前播放状态 播放/暂停 YES/NO

- (void)isPlay:(BOOL)isPlay;

// 当前正在播放的歌曲

- (void)playingMusic:(Music *)music;

// 当前歌曲播放完

- (void)musicPlayEnd:(Music *)music;


@end


@interface AVPlayerManager : NSObject
// 音乐栏代理对象
@property (nonatomic,weak) id<AVPlayerManageDelegate> delegateMB;

// 音乐播放视图控制器代理对象
@property (nonatomic,weak) id<AVPlayerManageDelegate> delegateMP;

// 音乐列表代理对象
@property (nonatomic,weak) id<AVPlayerManageDelegate> delegateMPL;

// 播放列表管理代理对象
@property (nonatomic,weak) id<AVPlayerManageDelegate> delegateMPLM;

// AVPlayerMAnager单列
+(AVPlayerManager*)shareAVPlayerManage;

// 添加播放的歌曲
-(void)addMusic:(Music*)music;

// 重新播放上一首
-(void)repeatPlayMusic;

// 播放歌曲
-(BOOL)playMusic;

// 暂停歌曲
-(BOOL)pauseMusic;

// 当前播放状态  播放／暂停
-(BOOL)isPlay;

// 当前播放状态  播放／暂停
-(Music *)playingMusic;

// 设置播放时间
-(void)setPlayToTime:(CMTime)time;

// 总播放时间
-(CGFloat)getDurationTime;

// 读取当前播放的音量
-(CGFloat)getPlayVolume;

// 修改当前播放的音量
-(void)setPlayVolume:(CGFloat)volume;

@end
