//
//  MoreView.h
//  MusicPlayer
//
//  Created by haoyang_zheng on 16/4/9.
//  Copyright © 2016年 DAC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BlockFloat)(CGFloat index);

@interface MoreView : UIView

@property (nonatomic,copy)BlockFloat block;//传递音量大小值

@property (nonatomic,assign) CGFloat nowVolume;//当前音量

@end

