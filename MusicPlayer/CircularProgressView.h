//
//  CircularProgressView.h
//  MusicPlayer
//
//  Created by haoyang_zheng on 16/4/9.
//  Copyright © 2016年 DAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircularProgressView : UIView

{
    
    CAShapeLayer *_trackLayer;
    
    UIBezierPath *_trackPath;
    
    CAShapeLayer *_progressLayer;
    
    UIBezierPath *_progressPath;
    
}

//@property (nonatomic,strong)CAShapeLayer *trackLayer;
//
//@property (nonatomic,strong)UIBezierPath *trackPath;
//
//@property (nonatomic,strong)CAShapeLayer *progressLayer;
//
//@property (nonatomic,strong)UIBezierPath *progressPath;

//
@property (nonatomic ,strong) UIColor *trackColor;//未加载进度条颜色

@property (nonatomic ,strong)UIColor *progressColor;//已加载进度条颜色

@property (nonatomic,assign)float progress;//进度0-1之间的数

@property (nonatomic,assign)float progressWidth;//进度条宽度

-(void)setProgress:(float)progress animated:(BOOL)animated;

@end

