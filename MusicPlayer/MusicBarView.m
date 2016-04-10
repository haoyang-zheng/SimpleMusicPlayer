//
//  MusicBarView.m
//  MusicPlayer
//
//  Created by haoyang_zheng on 16/4/9.
//  Copyright © 2016年 DAC. All rights reserved.
//

#import "MusicBarView.h"

#import <UIImageView+WebCache.h>

@implementation MusicBarView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 5, CGRectGetWidth(self.frame)-60, 25)];
        
        _titleLabel.textColor = [UIColor whiteColor];
        
        _titleLabel.font = [UIFont systemFontOfSize:18];
        
        [self addSubview:_titleLabel];
        
        _singerLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 30, CGRectGetWidth(self.frame) -60, 20)];
        
        _singerLabel.textColor = [UIColor lightGrayColor];
        
        _singerLabel.font = [UIFont systemFontOfSize:14];
        
        [self addSubview:_singerLabel];
        
        
        
        _PicImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 50, 50)];
        
        _PicImageView.layer.cornerRadius = 25;
        
        _PicImageView.clipsToBounds = YES;
        
        _PicImageView.backgroundColor = [UIColor redColor];
        
        _PicImageView.image = [UIImage imageNamed:@"music_small"];//默认图片
        
        [self addSubview:_PicImageView];
        
    }
    
    return self;
}
-(void)setMusic:(Music *)music
{
    //专辑图旋转归0
    
    self.PicImageView.transform = CGAffineTransformMakeRotation(0);
    
    //为控件添加数据
    
    [_PicImageView sd_setImageWithURL:[NSURL URLWithString:music.picUrl] placeholderImage:[UIImage imageNamed:@"music_small"]];
    
    _titleLabel.text = music.name;
    
    _singerLabel.text = music.singer;
}

//旋转专辑图

-(void)rotatePicImageView
{
    
    self.PicImageView.transform = CGAffineTransformRotate(self.PicImageView.transform, M_PI_4 / 225);
    
}








@end
