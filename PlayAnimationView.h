//
//  PlayAnimationView.h
//  MusicPlayer
//
//  Created by haoyang_zheng on 16/4/9.
//  Copyright © 2016年 DAC. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface PlayAnimationView : UIView

@property (nonatomic,assign) CGFloat animationTime;//动画时长

//播放歌曲

-(void)playMusic;

//暂停歌曲

-(void)pauserMusic;
@end