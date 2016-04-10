//
//  MusicBarView.h
//  MusicPlayer
//
//  Created by haoyang_zheng on 16/4/9.
//  Copyright © 2016年 DAC. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "Music.h"

@interface MusicBarView : UIView;

@property (nonatomic,strong)Music *music;

@property (nonatomic,strong)UIImageView *PicImageView;//专辑图

@property (nonatomic,strong)UILabel *titleLabel;//标题

@property (nonatomic,strong)UILabel *singerLabel;// 歌手

//旋转专辑图

-(void)rotatePicImageView;

@end