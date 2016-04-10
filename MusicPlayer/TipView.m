//
//  TipView.m
//  MusicPlayer
//
//  Created by haoyang_zheng on 16/4/9.
//  Copyright © 2016年 DAC. All rights reserved.
//
#import "TipView.h"

#define TINTCOLOR [UIColor colorWithRed:42/255.0 green:242/255.0 blue:161/255.0 alpha:1]

@interface TipView ()

@property (nonatomic,strong)UIImageView *imageView;

@property (nonatomic,strong)UILabel *textLabel;

@end

@implementation TipView

- (instancetype)initWithFrame:(CGRect)frame
{
    frame.origin.x = 0;
    
    frame.origin.y = 0 - 64;
    
    frame.size.height = 64;
    
    frame.size.width = CGRectGetWidth([[UIScreen mainScreen]bounds]);
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = TINTCOLOR;
        
        //默认隐藏
        
        self.hidden = YES;
        
        //初始化控件
        
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 34 , 20, 20)];
        
        _imageView.tintColor = [UIColor whiteColor];
        
        _imageView.image = [[UIImage imageNamed:@"iconfont-zhengque"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        [self addSubview:_imageView];
        
        _textLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 24, self.frame.size.width - 50, 40)];
        
        _textLabel.textAlignment = NSTextAlignmentLeft;
        
        _textLabel.font = [UIFont systemFontOfSize:18];
        
        _textLabel.textColor = [UIColor whiteColor];
        
        [self addSubview:_textLabel];
        
        
    }
    return self;
}


-(void)setTipIndex:(NSInteger)tipIndex{
    
    if (_tipIndex != tipIndex) {
        
        _tipIndex = tipIndex;
        
    }
    
    //判断要提示的循环类型
    
    NSString *string = @"";
    
    switch (tipIndex) {
            
        case 0:
            
            string = @"单曲循环";
            
            break;
            
        case 1:
            
            string = @"顺序播放";
            
            break;
            
        case 2:
            
            string = @"随机播放";
            
            break;
            
        default:
            
            break;
    }
    
    //添加提示的内容
    
    self.textLabel.text = [NSString stringWithFormat:@"已切换到%@模式",string ];
    
    //显示视图
    
    self.hidden = NO;
    
}

-(void)setHidden:(BOOL)hidden{
    
    [UIView animateWithDuration:0.5 animations:^{
        
        if (hidden) {
            
            self.frame = CGRectMake(0, 0 - self.frame.size.height , self.frame.size.width , self.frame.size.height);
            
        } else {
            
            //先显示 再执行动画
            
            [super setHidden:hidden];
            
            self.frame = CGRectMake(0, 0 , self.frame.size.width , self.frame.size.height);
            
            //开启定时器
            
            [self timerWithHidden];
            
        }
        
    } completion:^(BOOL finished) {
        
        //动画结束时
        
        [super setHidden:hidden];
        
    }];
    
    
}

//初始化计时器 2秒后隐藏视图

- (void)timerWithHidden{
    
    NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(timerAction:) userInfo:nil repeats:NO];
    
    //继续开启定时器
    
    [timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:2]];
    
}

//定时器事件

- (void)timerAction:(NSTimer *)timer{
    
    //隐藏视图
    
    self.hidden = YES;
    
    
    //结束定时器
    
    [timer invalidate];
    
    timer = nil;
    
}

@end
