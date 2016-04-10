//
//  NSString+GetMusicLyricArray.h
//  MusicPlayer
//
//  Created by haoyang_zheng on 16/4/9.
//  Copyright © 2016年 DAC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (GetMusicLyricArray)

//将歌词字符串转换成歌词数组

+(NSMutableArray*)getMusicLyricArrayWithString:(NSString *)string;

@end
