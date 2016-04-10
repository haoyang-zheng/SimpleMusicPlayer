//
//  LyricView_T.m
//  MusicPlayer
//
//  Created by haoyang_zheng on 16/4/9.
//  Copyright © 2016年 DAC. All rights reserved.
//


#import "LyricView_T.h"

#import "NSString+GetWidHeight.h"

#define VIEW_WIDTH CGRectGetWidth(self.frame)

#define VIEW_HEIGHT CGRectGetHeight(self.frame)

@interface LyricView_T ()

@property (nonatomic,strong)NSTimer *timer;// 定时器

@property (nonatomic,strong)UILabel *topLabel;//上层label

@property (nonatomic,strong)UILabel *downLabel;//底层label

@end

@implementation LyricView_T

//初始化View

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        //设置默认属性
        
        _textColor = [UIColor grayColor];
        
        _textLoadColor = [UIColor redColor];
        
        _textFont = [UIFont systemFontOfSize:16];
        
        //初始化
        
        _downLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, VIEW_HEIGHT)];
        
        _downLabel.textAlignment = NSTextAlignmentCenter;
        
        _downLabel.textColor = _textColor;
        
        _downLabel.font = _textFont;
        
        [self addSubview:_downLabel];
        
        _topLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        
        _topLabel.textAlignment = NSTextAlignmentCenter;
        
        _topLabel.textColor = _textLoadColor;
        
        _topLabel.font = _textFont;
        
        //剪切与文本宽度相同的内容长度，后半部分被删除
        
        _topLabel.lineBreakMode = NSLineBreakByClipping;
        
        [self addSubview:_topLabel];
    }
    
    return self;
}

#pragma mark -- 开启歌词

-(void)startLyric
{
    //初始化计时器
    
    CGFloat addWidth = CGRectGetWidth(self.downLabel.frame) / self.time;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(playLyricTime:) userInfo:[NSNumber numberWithFloat:addWidth / 10] repeats:YES];
    
    [self.timer fire];
    
    
}

//计时器事件  播放歌词

-(void)playLyricTime:(NSTimer *)timer{
    
    //获取每次执行的进度
    
    NSNumber *addWidth = timer.userInfo;
    
    //判断进度是否越界
    
    if (CGRectGetWidth(self.downLabel.frame) >= CGRectGetWidth(self.topLabel.frame) + [addWidth floatValue]) {
        
        //增加顶层label宽度
        
        self.topLabel.frame = CGRectMake(self.downLabel.frame.origin.x , 0 , CGRectGetWidth(self.topLabel.frame) + [addWidth floatValue], VIEW_HEIGHT);
        
    }
    else{
        
        //设置顶层label等于底层大小
        
        self.topLabel.frame = CGRectMake(self.downLabel.frame.origin.x , 0 , CGRectGetWidth(self.downLabel.frame) , VIEW_HEIGHT);
        
        // 取消定时器
        
        [timer invalidate];
        
        timer = nil;
        
        NSLog(@"结束了计时器");
    }
    
}

#pragma mark -- 获取数据

-(void)setText:(NSString *)text
{
    //计算所需宽度
    
    CGFloat textWidth = [NSString getWidthWithstirng:text Width:VIEW_WIDTH FonSize:[self.textFont pointSize]];
    
    //设置底层label宽度
    
    self.downLabel.frame = CGRectMake((VIEW_WIDTH - textWidth) / 2.0, 0, textWidth, VIEW_HEIGHT);
    
    //设置label内容
    
    self.downLabel.text = text;
    
    self.topLabel.text =text;
    
    //还原顶层label
    
    [self restoreLyric ];
}

-(void)setTextColor:(UIColor *)textColor
{
    //设置底层label字体颜色
    
    self.downLabel.textColor =textColor;
}

-(void)setTextFont:(UIFont *)textFont
{
    //设置label字体样式
    
    self.topLabel.font = textFont;
    
    self.downLabel.font =textFont;
}
-(void)restoreLyric
{
    // 还原顶层label
    
    self.topLabel.frame = CGRectZero;
    
}
@end
