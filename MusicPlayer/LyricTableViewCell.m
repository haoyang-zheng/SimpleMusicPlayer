//
//  LyricTableViewCell.m
//  MusicPlayer
//
//  Created by haoyang_zheng on 16/4/9.
//  Copyright © 2016年 DAC. All rights reserved.
//

#import "LyricTableViewCell.h"


@implementation LyricTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        //设置CELL的透明度
        
        self.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0];
        
        _lyricView = [[LyricView_A alloc]init];
        
        [self.contentView addSubview:_lyricView];
        
    }
    
    return self;
}

//获取到歌词

-(void)setText:(NSString *)text
{
    //为LyricView传入要播放的歌词
    
    _lyricView.text = text;
    
}


@end
