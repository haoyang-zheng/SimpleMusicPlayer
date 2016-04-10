//
//  PlayAnimationView.m
//  MusicPlayer
//
//  Created by haoyang_zheng on 16/4/9.
//  Copyright © 2016年 DAC. All rights reserved.
//
#import "PlayAnimationView.h"
#import "PCH.h"

@interface PlayAnimationView ()

@property (nonatomic,strong)UIView *columanView1; //柱形视图1

@property (nonatomic,strong)UIView *columanView2; //柱形视图2

@property (nonatomic,strong)UIView *columanView3; //柱形视图3

@property (nonatomic,strong)UIView *columanView4; //柱形视图4


@end



@implementation PlayAnimationView

//初始化

- (instancetype)initWithFrame:(CGRect)frame       //矩形
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.clipsToBounds = YES;
        
        
        _columanView1 = [[UIView alloc]initWithFrame:CGRectMake(5, 15 , 2, 80)];
        
        _columanView1.backgroundColor = BUTTONTINTCOLOR;
        
        [self addSubview:_columanView1];
        
        
        _columanView2 = [[UIView alloc]initWithFrame:CGRectMake(10, 5 , 2, 80)];
        
        _columanView2.backgroundColor = BUTTONTINTCOLOR;
        
        [self addSubview:_columanView2];
        
        
        _columanView3 = [[UIView alloc]initWithFrame:CGRectMake(15, 5 , 2, 80)];
        
        _columanView3.backgroundColor = BUTTONTINTCOLOR;
        
        [self addSubview:_columanView3];
        
        
        _columanView4 = [[UIView alloc]initWithFrame:CGRectMake(20, 15 , 2, 80)];
        
        _columanView4.backgroundColor = BUTTONTINTCOLOR;
        
        [self addSubview:_columanView4];
        
        
    }
    return self;
}

-(void)setAnimationTime:(CGFloat)animationTime{
    
    if (_animationTime != animationTime) {
        
        _animationTime = animationTime;
        
    }
    
    
    __block PlayAnimationView *Self = self;
    
    //柱1动画
    
    [UIView animateWithDuration:1.0f  animations:^{
        
        [UIView setAnimationRepeatCount:animationTime ];//动画次数
        
        [UIView setAnimationRepeatAutoreverses:YES];//动画反转
        
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];//动画的速度曲线
        
        Self.columanView1.frame = CGRectMake(5, 10, CGRectGetWidth(Self.columanView1
                                                                   .frame), CGRectGetHeight(Self.columanView1.frame));
        
    } completion:^(BOOL finished) {
        
        Self.columanView1.frame = CGRectMake(5, 15, CGRectGetWidth(Self.columanView1.frame), CGRectGetHeight(Self.columanView1.frame));
        
    }];
    
    //柱2动画
    
    [UIView animateWithDuration:1.0f / 4  animations:^{
        
        [UIView setAnimationRepeatCount:animationTime * 4];//动画次数
        
        [UIView setAnimationRepeatAutoreverses:YES];//动画反转
        
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];//动画的速度曲线
        
        Self.columanView2.frame = CGRectMake(10, 15, CGRectGetWidth(Self.columanView2.frame), CGRectGetHeight(Self.columanView2.frame));
        
    } completion:^(BOOL finished) {
        
        Self.columanView2.frame = CGRectMake(10, 0, CGRectGetWidth(Self.columanView2.frame), CGRectGetHeight(Self.columanView2.frame));
        
    }];
    
    //柱3动画
    
    [UIView animateWithDuration:1.0f / 2  animations:^{
        
        [UIView setAnimationRepeatCount:animationTime * 2];//动画次数
        
        [UIView setAnimationRepeatAutoreverses:YES];//动画反转
        
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];//动画的速度曲线
        
        Self.columanView3.frame = CGRectMake(15, 15, CGRectGetWidth(Self.columanView3.frame), CGRectGetHeight(Self.columanView3.frame));
        
        
    } completion:^(BOOL finished) {
        
        Self.columanView3.frame = CGRectMake(15, 5, CGRectGetWidth(Self.columanView3.frame), CGRectGetHeight(Self.columanView3.frame));
        
    }];
    
    //柱4动画
    
    [UIView animateWithDuration:1.0f / 2  animations:^{
        
        [UIView setAnimationRepeatCount:animationTime * 2];//动画次数
        
        [UIView setAnimationRepeatAutoreverses:YES];//动画反转
        
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];//动画的速度曲线
        
        Self.columanView4.frame = CGRectMake(20, 5, CGRectGetWidth(Self.columanView4.frame), CGRectGetHeight(Self.columanView4.frame));
        
    } completion:^(BOOL finished) {
        
        Self.columanView4.frame = CGRectMake(20, 15, CGRectGetWidth(Self.columanView4.frame), CGRectGetHeight(Self.columanView4.frame));
        
    }];
    
    
}


//播放歌曲

- (void)playMusic{
    
    //恢复动画
    
    [self resumeAnimation];
    
}

//暂停歌曲

- (void)pauserMusic{
    
    //暂停动画
    
    [self pauseAnimation];
    
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
    
    // 将时间偏移量设为0(重新开始)；
    self.layer.timeOffset = 0.0;
    
    // 设置开始时间(beginTime是相对于父级对象的开始时间,系统会根据时间间隔帮我们算出什么时候开始动画)
    self.layer.beginTime = starttime;
    
    // 将速度恢复，设为1
    self.layer.speed = 1.0;
    
}

@end
