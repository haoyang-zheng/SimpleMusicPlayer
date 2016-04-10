//
//  MoreView.m
//  MusicPlayer
//
//  Created by haoyang_zheng on 16/4/9.
//  Copyright © 2016年 DAC. All rights reserved.
//

#import "MoreView.h"

@interface MoreView ()

@property (nonatomic,strong)UIVisualEffectView *vview;

@property (nonatomic,strong)UISlider *volumeSlider;//音量控制模块

@property (nonatomic,strong)UIImageView *volumeMinImage;//音量小图标

@property (nonatomic,strong)UIImageView *volumeMaxImage;//音量大图标

@property (nonatomic,strong)UIButton *backButton;//返回取消按钮

@end



@implementation MoreView


-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        //设置视图背景颜色 透明黑色
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        
        //初始化玻璃视图
        
        _vview = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        
        _vview.frame = CGRectMake(0 , CGRectGetHeight(self.frame) - 200 , CGRectGetWidth(self.frame), 200);
        
        [self addSubview:_vview];
        
        
        
        
        //初始化音量控制滑块
        
        _volumeSlider = [[UISlider alloc]initWithFrame:CGRectMake(40, ( CGRectGetHeight(_vview.frame) - 100 ) , CGRectGetWidth(self.vview.frame) - 80 , 24 )];
        
        _volumeSlider.tintColor = [UIColor whiteColor];
        
        //设置image的渲染模式
        
        [_volumeSlider setThumbImage:[[UIImage imageNamed:@"iconfont-dian"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        
        _volumeSlider.minimumTrackTintColor = [UIColor whiteColor];
        
        _volumeSlider.minimumValue = 0;
        
        _volumeSlider.maximumValue = 1.0;
        
        [_volumeSlider addTarget:self action:@selector(settingVolumeAction:) forControlEvents:UIControlEventValueChanged];
        
        [_vview addSubview:_volumeSlider];
        
        
        //初始化音量图标
        
        //小
        
        _volumeMinImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, _volumeSlider.frame.origin.y  , 20, 20)];
        
        _volumeMinImage.tintColor = [UIColor whiteColor];
        
        _volumeMinImage.image = [[UIImage imageNamed:@"iconfont-yinliangxiao"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        [_vview addSubview:_volumeMinImage];
        
        //大
        
        _volumeMaxImage = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.vview.frame) - 30 , _volumeSlider.frame.origin.y , 20, 20)];
        
        _volumeMaxImage.tintColor = [UIColor whiteColor];
        
        _volumeMaxImage.image = [[UIImage imageNamed:@"iconfont-yinliangda"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        [_vview addSubview:_volumeMaxImage];
        
        
        
        
        //初始化返回取消button
        
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _backButton.frame = CGRectMake(0, CGRectGetHeight(self.vview.frame) - 60 , CGRectGetWidth(self.vview.frame) , 60);
        
        [_backButton setTitle:@"取消" forState:UIControlStateNormal];
        
        [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [_backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [_vview addSubview:_backButton];
        
        //分隔线
        
        UIImageView *SeparateImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.vview.frame) - 60, CGRectGetWidth(self.vview.frame), 1)];
        
        SeparateImageView.backgroundColor = [UIColor grayColor];
        
        SeparateImageView.alpha = 0.8;
        
        [_vview addSubview:SeparateImageView];
        
        //分隔线2
        
        UIImageView *Separate2ImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.vview.frame) - 60 - 60 , CGRectGetWidth(self.vview.frame), 1)];
        
        Separate2ImageView.backgroundColor = [UIColor grayColor];
        
        Separate2ImageView.alpha = 0.8;
        
        [_vview addSubview:Separate2ImageView];
        
    }
    
    return self;
}

-(void)setNowVolume:(CGFloat)nowVolume{
    
    if (_nowVolume != nowVolume) {
        
        _nowVolume = nowVolume;
        
    }
    
    //设置音量滑块当前的值
    
    self.volumeSlider.value = nowVolume;
    
    //判断是否为最小值 并设置静音图标
    
    if (nowVolume == 0) {
        
        //设置静音图标
        
        self.volumeMinImage.image = [[UIImage imageNamed:@"iconfont-yinliangjingyin"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
    } else {
        
        //设置音量小图标
        
        self.volumeMinImage.image = [[UIImage imageNamed:@"iconfont-yinliangxiao"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
    }
    
}


#pragma mark ---滑块事件

- (void)settingVolumeAction:(UISlider *)slider{
    
    //判断是否为最小值 并设置静音图标
    
    if (slider.value == 0) {
        
        //设置静音图标
        
        self.volumeMinImage.image = [[UIImage imageNamed:@"iconfont-yinliangjingyin"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
    } else {
        
        //设置音量小图标
        
        self.volumeMinImage.image = [[UIImage imageNamed:@"iconfont-yinliangxiao"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
    }
    
    
    //调用block传递值
    
    self.block(slider.value);
    
}

#pragma mark ---返回取消按钮事件

- (void)backButtonAction:(UIButton *)sender{
    
    //隐藏
    
    self.hidden = YES;
    
}

#pragma mark ---视图触控事件响应

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    //隐藏
    
    self.hidden = YES;
    
}

//重写隐藏  添加动画

-(void)setHidden:(BOOL)hidden{
    
    
    
    [UIView animateWithDuration:0.5 animations:^{
        
        if (hidden) {
            
            //设置视图背景颜色 半透明黑色
            
            self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
            
            //收回
            
            _vview.frame = CGRectMake(0, CGRectGetHeight(self.frame), _vview.frame.size.width , _vview.frame.size.height);
            
        } else {
            
            //先显示 再执行动画
            
            [super setHidden:hidden];
            
            //设置视图背景颜色 半透明黑色
            
            self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
            
            //推出
            
            _vview.frame = CGRectMake(0, CGRectGetHeight(self.frame) - _vview.frame.size.height , _vview.frame.size.width , _vview.frame.size.height);
            
        }
        
    } completion:^(BOOL finished) {
        
        //动画结束时
        
        [super setHidden:hidden];
        
    }];
    
    
    
}


@end
