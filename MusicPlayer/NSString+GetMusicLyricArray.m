//
//  NSString+GetMusicLyricArray.m
//  MusicPlayer
//
//  Created by haoyang_zheng on 16/4/9.
//  Copyright © 2016年 DAC. All rights reserved.
//

#import "NSString+GetMusicLyricArray.h"

@implementation NSString (GetMusicLyricArray)

+(NSMutableArray*)getMusicLyricArrayWithString:(NSString *)string
{
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:[string componentsSeparatedByString:@"\n"]];
    
    //删除最后一个空元素
    
    [mutableArray removeLastObject];
    
    return mutableArray;
}

@end