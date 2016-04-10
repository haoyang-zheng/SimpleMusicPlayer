//
//  LyricTableViewCell.h
//  MusicPlayer
//
//  Created by haoyang_zheng on 16/4/9.
//  Copyright © 2016年 DAC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LyricView_A.h"

#import "LyricView_T.h"

@interface LyricTableViewCell : UITableViewCell

@property (nonatomic ,strong)LyricView_A *lyricView;//歌词视图

@property (nonatomic,assign)CGFloat time;//当前播放时间

@property (nonatomic,copy)NSString *text;//当前播放歌词

@property (nonatomic,assign)BOOL isPlaying;//是否为正在播放的歌词cell

@end
