//
//  MusicPlayerListTableViewCell.m
//  MusicPlayer
//
//  Created by haoyang_zheng on 16/4/9.
//  Copyright © 2016年 DAC. All rights reserved.
//

#import "MusicPlayerListTableViewCell.h"

#import "NSString+GetWidHeight.h"

#import "PCH.h"

@implementation MusicPlayerListTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        //获取音乐播放管理
        
        _avPlayer = [AVPlayerManager shareAVPlayerManage];
        
        
        //设置CELL点击样式
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //设置CELL背景颜色
        
        self.backgroundColor = [UIColor clearColor];
        
        //设置CELL宽度为屏幕宽
        
        self.frame = CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen]bounds]), CGRectGetHeight(self.frame));
        
        self.contentView.frame = self.frame;
        
        //初始化控件
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20 , 0, 0, 40)];
        
        _titleLabel.backgroundColor = [UIColor clearColor];
        
        _titleLabel.numberOfLines = 0;
        
        [self.contentView addSubview:_titleLabel];
        
        
        _playAnimationView = [[PlayAnimationView alloc]initWithFrame:CGRectMake(10, 10, 25, 20)];
        
        _playAnimationView.hidden = YES;
        
        [self.contentView addSubview:_playAnimationView];
        
        
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _deleteButton.frame = CGRectMake(CGRectGetWidth(self.contentView.frame) - 40 , 0 , 40, 40);
        
        _deleteButton.tintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
        
        [_deleteButton setImage: [[UIImage imageNamed:@"iconfont-delete"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        
        [_deleteButton addTarget:self action:@selector(deleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:_deleteButton];
        
    }
    
    return self;
    
}

- (void)loadMusicData:(Music *)music TextColor:(UIColor *)tc PlayViewHidden:(BOOL)pvHidden{
    
    //为标题label添加数据 并设置2种样式
    
    NSString *titleString = [NSString stringWithFormat:@"%@ - %@",music.name , music.singer];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:titleString];
    
    NSRange range = [titleString rangeOfString:@"-"];
    
    [str addAttribute:NSForegroundColorAttributeName value:tc range:NSMakeRange(0 , range.location  )];
    
    [str addAttribute:NSForegroundColorAttributeName value:[tc colorWithAlphaComponent:0.8] range:NSMakeRange(range.location , titleString.length - range.location )];
    
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, range.location )];
    
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange( range.location , titleString.length - range.location  )];
    
    _titleLabel.attributedText = str;
    
    //计算label所需要的宽度
    
    CGFloat title_width = [NSString getWidthWithstirng:titleString Width:CGRectGetWidth(self.contentView.frame) FonSize:18];
    
    
    //限制过大宽度
    
    if (title_width > CGRectGetWidth( self.contentView.frame ) - 100) {
        
        title_width = CGRectGetWidth( self.contentView.frame ) - 100;
        
    }
    
    _titleLabel.frame = CGRectMake(20 , 0 , title_width , 40);
    
    _playAnimationView.frame = CGRectMake(CGRectGetWidth(_titleLabel.frame) + 20, 10, 25, 20);
    
    _playAnimationView.hidden = pvHidden;//是否隐藏播放动画视图
    
}

-(void)setMusic:(Music *)music{
    
    if (_music != music) {
        
        
        _music = music;
        
    }
    
}


-(void)setPlayingMusic:(Music *)playingMusic{
    
    if (_playingMusic != playingMusic) {
        
        
        _playingMusic = playingMusic;
        
    }
    
    //如果歌曲数据库id与正在播放的歌曲数据库id一致 说明该歌曲正在被播放
    
    if (self.music.db_id == playingMusic.db_id) {
        
        [self loadMusicData:self.music TextColor:BUTTONTINTCOLOR PlayViewHidden:NO];
        
        self.playAnimationView.animationTime = self.music.duration;
        
        //判断当前歌曲的播放状态 是否要进行动画
        
        if ([self.avPlayer isPlay]) {
            
            [self.playAnimationView playMusic];
            
        } else {
            
            [self.playAnimationView pauserMusic];
            
        }
        
        
        
    }else{
        
        [self loadMusicData:self.music TextColor:[UIColor whiteColor] PlayViewHidden:YES];
        
    }
    
    
}

#pragma mark ---删除按钮事件

- (void)deleteButtonAction:(UIButton *)sender{
    
    //调用删除Block 传入要删除的music
    
    self.deleteBlock(self.music);
    
}




@end


