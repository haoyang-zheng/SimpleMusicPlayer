//
//  LyricView_T.h
//  MusicPlayer
//
//  Created by haoyang_zheng on 16/4/9.
//  Copyright © 2016年 DAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LyricView_T : UIView

@property (nonatomic,assign)CGFloat time;//单条歌词时间（当前播放的歌词与下一条歌词的时间间隔）

@property (nonatomic,copy)NSString *text;//歌词内容

@property (nonatomic,strong)UIColor *textColor;//字体颜色

@property (nonatomic,strong)UIColor *textLoadColor;//加载字体颜色

@property (nonatomic,strong)UIFont *textFont;//字体大小样式；

//开启歌词

-(void)startLyric;

//恢复歌词样式

-(void)restoreLyric;

@end

