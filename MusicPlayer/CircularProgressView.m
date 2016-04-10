//
//  CircularProgressView.m
//  MusicPlayer
//
//  Created by haoyang_zheng on 16/4/9.
//  Copyright © 2016年 DAC. All rights reserved.
//

#import "CircularProgressView.h"


@interface CircularProgressView ()

@property (nonatomic,assign)CGFloat lineWidth;

@end

@implementation CircularProgressView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if ([super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        _trackLayer = [CAShapeLayer new];
        
        [self.layer addSublayer:_trackLayer];
        
        _trackLayer.fillColor = nil;
        
        _trackLayer.frame = self.bounds;
        
        _progressLayer = [CAShapeLayer new];
        
        [self.layer addSublayer:_progressLayer];
        
        _progressLayer.fillColor = nil;
        
        _progressLayer.lineCap = kCALineCapRound;
        
        _progressLayer.frame = self.bounds;
        
        //进度条宽默认5
        
        self.progressWidth = 5;
        
        _trackPath = [UIBezierPath bezierPathWithArcCenter:self.center radius:(self.bounds.size.width - _progressWidth)/ 2 startAngle:0 endAngle:M_PI * 2 clockwise:YES];;
        
        _trackLayer.path = _trackPath.CGPath;
        
    }
    
    return self;
}

- (void)setTrack
{
    _trackPath = [UIBezierPath bezierPathWithArcCenter:self.center radius:(self.bounds.size.width - _progressWidth)/ 2 startAngle:0 endAngle:M_PI * 2 clockwise:YES];;
    
    _trackLayer.path = _trackPath.CGPath;
}

- (void)setProgress
{
    _progressPath = [UIBezierPath bezierPathWithArcCenter:self.center radius:(self.bounds.size.width - _progressWidth)/ 2 startAngle:- M_PI_2 endAngle:(M_PI * 2) * _progress - M_PI_2 clockwise:YES];
    
    _progressLayer.path = _progressPath.CGPath;
}


- (void)setProgressWidth:(float)progressWidth
{
    _progressWidth = progressWidth;
    
    _trackLayer.lineWidth = _progressWidth;
    
    _progressLayer.lineWidth = _progressWidth;
    
    [self setTrack];
    
    [self setProgress];
}

- (void)setTrackColor:(UIColor *)trackColor
{
    _trackLayer.strokeColor = trackColor.CGColor;
}

- (void)setProgressColor:(UIColor *)progressColor
{
    _progressLayer.strokeColor = progressColor.CGColor;
}

- (void)setProgress:(float)progress
{
    _progress = progress;
    
    [self setProgress];
}

- (void)setProgress:(float)progress animated:(BOOL)animated
{
    
}

@end
