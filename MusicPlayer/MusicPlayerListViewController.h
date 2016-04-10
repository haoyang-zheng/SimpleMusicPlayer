//
//  MusicPlayerListViewController.h
//  MusicPlayer
//
//  Created by haoyang_zheng on 16/4/9.
//  Copyright © 2016年 DAC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Music.h"

typedef void (^DisappearBlock)();

@interface MusicPlayerListViewController : UIViewController

@property (nonatomic,copy)DisappearBlock disappearBlack;//视图消失时候调用的black

@end
