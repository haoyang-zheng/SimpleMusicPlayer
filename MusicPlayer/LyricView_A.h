//
//  LyricView_A.h
//  MusicPlayer
//
//  Created by haoyang_zheng on 16/4/9.
//  Copyright © 2016年 DAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LyricView_A : UIView

@property (nonatomic,copy)NSString *text;//歌词内容

@property (nonatomic,strong)UIColor *textColor;//字体颜色

@property (nonatomic,strong)UIColor *textLoadColor;//加载字体

@property (nonatomic,strong)UIFont *textFont;//字体大小样式

@property (nonatomic,assign)BOOL isPlayer;//是否播放

@property (nonatomic,assign)BOOL isShow;//是否正在显示

//开启歌词  传入单条歌词时间(当前播放的歌词与下一条歌词的时间间隔)

-(void)startLyric:(CGFloat)time;

//从指定时间开启歌词  总共需要的时间

-(void)startLyricWithTime:(CGFloat)time TotalTime:(CGFloat)totalTime;

//恢复歌词样式

-(void)restoreLyric;

@end