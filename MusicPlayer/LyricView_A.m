//
//  LyricView_A.m
//  MusicPlayer
//
//  Created by haoyang_zheng on 16/4/9.
//  Copyright © 2016年 DAC. All rights reserved.
//

#import "LyricView_A.h"
#import "NSString+GetWidHeight.h"


#define VIEW_WIDTH CGRectGetWidth(self.frame)

#define VIEW_HEIGHT CGRectGetHeight(self.frame)

@interface LyricView_A ()

@property (nonatomic , strong) NSTimer *timer;//定时器

@property (nonatomic , strong) UIView *topView;//上层view

@property (nonatomic , strong) UILabel *topLabel;//上层label

@property (nonatomic , strong) UILabel *downLabel;//底层label

@end

@implementation LyricView_A


//初始化View

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame: frame];
    
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
        
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, VIEW_HEIGHT)];
        
        _topView.clipsToBounds = YES;//子视图超出边框部分隐藏
        
        [self addSubview:_topView];
        
        
        _topLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, VIEW_HEIGHT)];
        
        _topLabel.textAlignment = NSTextAlignmentCenter;
        
        _topLabel.textColor = _textLoadColor;
        
        _topLabel.font = _textFont;
        
        //剪切与文本宽度相同的内容长度，后半部分被删除
        
        _topLabel.lineBreakMode = NSLineBreakByClipping;
        
        [_topView addSubview:_topLabel];
        
        
    }
    
    return self;
    
}

#pragma mark ----开启歌词

- (void) startLyric:(CGFloat)time{
    
    //设置动画
    
    __block LyricView_A *Self = self;
    
    [UIView animateWithDuration:time animations:^{
        
        Self.topView.frame = CGRectMake(Self.downLabel.frame.origin.x , 0 , CGRectGetWidth(Self.downLabel.frame) , VIEW_HEIGHT);
        
    } completion:^(BOOL finished) {
        
        //动画结束 还原顶层View
        
        [Self restoreLyric];
        
    }];
    
}

#pragma mark ----从指定时间开启歌词 总共需要的时间

- (void) startLyricWithTime:(CGFloat)time TotalTime:(CGFloat)totalTime{
    
    //计算每0.1秒执行的进度
    
    CGFloat totalWidth = CGRectGetWidth( self.topLabel.frame );
    
    CGFloat aWidth = totalWidth / totalTime;
    
    //将进度改为指定的时间位置 (指定时间 * 每0.1秒执行的进度)
    
    self.topView.frame = CGRectMake(self.downLabel.frame.origin.x , 0 , time * aWidth , VIEW_HEIGHT);
    
    //继续执行剩下的进度
    
    //设置动画
    
    __block LyricView_A *Self = self;
    
    [UIView animateWithDuration:(totalTime - time) animations:^{
        
        Self.topView.frame = CGRectMake(Self.downLabel.frame.origin.x , 0 , CGRectGetWidth(Self.downLabel.frame) , VIEW_HEIGHT);
        
    } completion:^(BOOL finished) {
        
        //动画结束 还原顶层View
        
        [Self restoreLyric];
        
    }];
    
    
}


#pragma mark ----获取数据


- (void)setText:(NSString *)text{
    
    
    //计算所需宽度
    
    CGFloat textWidth = [NSString getWidthWithstirng:text Width:VIEW_WIDTH FonSize:[self.textFont pointSize]];
    
    //设置底层label宽度
    
    self.downLabel.frame = CGRectMake(( VIEW_WIDTH - textWidth) / 2, 0 , textWidth , VIEW_HEIGHT);
    
    //设置顶层label宽度
    
    self.topLabel.frame = CGRectMake( 0, 0 , textWidth , VIEW_HEIGHT);
    
    
    
    //设置label内容
    
    self.downLabel.text = text;
    
    self.topLabel.text = text;
    
    //还原顶层View
    
    [self restoreLyric];
    
    
}

- (void)setTextColor:(UIColor *)textColor{
    
    //设置底层label字体颜色
    
    self.downLabel.textColor = textColor;
    
}

- (void)setTextLoadColor:(UIColor *)textLoadColor{
    
    //设置顶层label字体颜色
    
    self.topLabel.textColor = textLoadColor;
    
}

- (void)setTextFont:(UIFont *)textFont {
    
    //设置 label字体样式
    
    self.topLabel.font = textFont;
    
    self.downLabel.font = textFont;
    
}




#pragma mark ----恢复歌词样式

- (void) restoreLyric{
    
    //还原顶层View
    
    self.topView.frame = CGRectMake(self.downLabel.frame.origin.x , 0 , 0 , VIEW_HEIGHT);
    
}



#pragma mark ---是否播放(以判断是否停止动画)

-(void)setIsPlayer:(BOOL)isPlayer{
    
    if (_isPlayer != isPlayer) {
        
        _isPlayer = isPlayer;
        
    }
    
    if (isPlayer)
    {
        // 开始(播放)动画
        
        [self resumeAnimation];
    }
    else
    {
        // 暂停动画
        
        [self pauseAnimation];
    }
    
}


// 暂停动画

- (void)pauseAnimation
{
    // 取出当前的时间点，就是暂停的时间点
    CFTimeInterval pausetime = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    
    // 设定时间偏移量，让动画定格在那个时间点
    [self.layer setTimeOffset:pausetime];
    
    // 将速度设为0
    [self.layer setSpeed:0.0f];
    
}

// 恢复动画

- (void)resumeAnimation
{
    // 获取暂停的时间
    CFTimeInterval pausetime = self.layer.timeOffset;
    
    // 计算出此次播放时间(从暂停到现在，相隔了多久时间)
    CFTimeInterval starttime = CACurrentMediaTime() - pausetime;
    
    
    
    // 将速度恢复，设为1
    self.layer.speed = 1.0;
    
}

@end

