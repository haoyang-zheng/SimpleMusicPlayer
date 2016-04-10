//
//  MusicPlayerViewController.m
//  MusicPlayer
//
//  Created by haoyang_zheng on 16/4/9.
//  Copyright © 2016年 DAC. All rights reserved.
//

#import "MusicPlayerViewController.h"

#import "PCH.h"

#import "TipView.h"

#import "MoreView.h"

#import "LyricTableView.h"

#import "AVPlayerManager.h"

#import <UIImageView+WebCache.h>

#import "MusicPlayerListManager.h"

#import "MusicPlayerListViewController.h"

//#import "OpenShareHeader.h"

#import "CollectListManager.h"

#import "UIView+TYAlertView.h"

@interface MusicPlayerViewController ()<UIScrollViewDelegate,AVPlayerManageDelegate>

@property (nonatomic,strong) AVPlayerManager *avPlayer;//音乐播放管理

@property (nonatomic,strong) MusicPlayerListManager *musicPLManage;// 音乐播放列表

@property (nonatomic,strong) MusicPlayerListViewController *MPLVC;//音乐播放列表


@property (nonatomic,strong) Music* music;
//@property (nonatomic,strong) Music* music; //当前播放的音乐


@property (nonatomic,strong) UIImageView *backgroundImageView;// 背景图片

//－－－头

@property (nonatomic,strong)UIView *heardView;//顶部视图

@property (nonatomic,strong)MoreView *moreView;// 更多视图

@property (nonatomic,strong)UILabel *titleLabel;//标题

// - - -中心

@property (nonatomic,strong) UIScrollView *scrollView;//专辑歌词滑动视图

@property (nonatomic,strong) UIImageView *picImageView; //专辑图片

@property (nonatomic,strong)LyricTableView *lyricTableView;//歌词列表

@property (nonatomic,strong)UILabel *singerLabel;//歌手

@property (nonatomic,strong)UILabel *lyricLabel;//辅助歌词

// －－－脚

@property (nonatomic,strong)UIView *footView;//底部视图

@property (nonatomic,strong)UISlider *slider;//播放进度

@property (nonatomic,strong)UIPageControl *pageControl;//分页指示器（专辑页与歌词切换）

@property (nonatomic,strong)UILabel *totaltime;//总时长

@property (nonatomic,strong)UILabel *nowTime;//正在播放的时间

@property (nonatomic,strong)UIButton *PlayerButton;//播放／暂停按钮

@property (nonatomic,strong)UIButton *likeButton;//喜欢按钮

@property (nonatomic,strong)UIButton *cycleButton;//循环按钮

@property (nonatomic,strong)UIButton *downloadButton;//下载按钮

@property (nonatomic,strong)UIButton *shareButton;// 分享按钮

@property (nonatomic,strong)UIButton *listButton;//音乐列表按钮

@property (nonatomic,assign)NSInteger cycletype;//循环类型 0.单曲循环  1.顺序循环  2.随机循环

@property (nonatomic,strong)NSArray *cycleImageArray; //  循环图标数组

@property (nonatomic,strong)TipView *tipView;//循环提示视图

@property (nonatomic,assign)BOOL isShow;//是否收起或者显示  显示为YES  收起为NO


@end

@implementation MusicPlayerViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    //背景颜色
    
    self.view.backgroundColor = [UIColor blackColor];
    
    //加载初始化控件视图
    
    [self loadInitView];
    
    //获取正在播放的歌曲信息
    
    self.music =  [self.avPlayer playingMusic];
    
}


#pragma mark --加载初始化控件视图


-(void)loadInitView
{
    //初始化背景图片
    
    self.backgroundImageView = [[UIImageView alloc]initWithFrame:self.view.frame];
    
    self.backgroundImageView.alpha = 0.6;
    
    [self.view addSubview:self.backgroundImageView];
    
    //头
    
    [self loadHeardView];
    
    //身体
    [self loadcentreView];
    
    //底部
    [self loadfootView];
    
    
}


#pragma mark ---顶部视图

-(void)loadHeardView
{
    
    //初始化顶部视图 (y轴位置为初始隐藏位置,视图退出后 会执行动画移动到原有位置)
    
    self.heardView = [[UIView alloc]initWithFrame:CGRectMake(0 , 0 - 64 - 30 , CGRectGetWidth(self.view.frame), 64)];
    
    [self.view addSubview:self.heardView];
    
    
    //初始化标题
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 24 , CGRectGetWidth(self.view.frame) - 100, 40)];
    
    self.titleLabel.font = [UIFont systemFontOfSize:24];
    
    self.titleLabel.textColor = [UIColor whiteColor];
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.heardView addSubview:self.titleLabel];
    
    
    //左按钮
    
    UIButton *heardLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    heardLeftButton.frame = CGRectMake(10, 24, 40, 40);
    
    heardLeftButton.tintColor = [UIColor whiteColor];
    
    [heardLeftButton setImage:[[UIImage imageNamed:@"iconfont-xia"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    
    [heardLeftButton addTarget:self action:@selector(heardLeftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.heardView addSubview:heardLeftButton];
    
    //右按钮
    
    UIButton *heardRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    heardRightButton.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 50 , 24, 40, 40);
    
    heardRightButton.tintColor = [UIColor whiteColor];
    
    [heardRightButton setImage:[[UIImage imageNamed:@"iconfont-gengduo"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    
    [heardRightButton addTarget:self action:@selector(heardRightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.heardView addSubview:heardRightButton];
    
    
    //初始化更多视图
    
    self.moreView = [[MoreView alloc]initWithFrame:self.view.frame];
    
    self.moreView.hidden = YES;//默认隐藏
    
    [self.view addSubview:self.moreView];
    
    
    //初始化循环提示视图
    
    self.tipView = [[TipView alloc]initWithFrame:CGRectZero];
    
    [self.view addSubview:self.tipView];
    
}

#pragma mark ---中部视图

-(void)loadcentreView{
    
    //初始化歌手
    
    
    self.singerLabel = [[UILabel alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame) - 200) / 2, CGRectGetHeight(self.heardView.frame) , 200, 30)];
    
    self.singerLabel.textAlignment = NSTextAlignmentCenter;
    
    self.singerLabel.textColor = [UIColor whiteColor];
    
    [self.heardView addSubview:self.singerLabel];
    
    
    //初始化专辑图片页视图
    
    self.picImageView = [[UIImageView alloc]initWithFrame:CGRectMake( 0 , 0 , CGRectGetWidth(self.view.frame) - 100, CGRectGetWidth(self.view.frame) - 100)];
    
    self.picImageView.clipsToBounds = YES;
    
    self.picImageView.layer.cornerRadius = CGRectGetWidth(self.picImageView.frame) / 2;
    
    self.picImageView.layer.borderWidth = 10;//设置边框宽度
    
    self.picImageView.layer.borderColor = [[[UIColor blackColor] colorWithAlphaComponent:0.6] CGColor];//设置边框样色 透明度为60%
    
    //设置专辑图片默认缩放比例 <注意: 设置中心点 一定要写在缩放动画下面 否则位置会不准确>
    
    CGAffineTransform newTransform =  CGAffineTransformScale(self.picImageView.transform, 0.2, 0.2);
    
    [self.picImageView setTransform:newTransform];
    
    //设置初始中心点坐标
    
    self.picImageView.center = CGPointMake(30 , CGRectGetHeight(self.view.frame) - 30);
    
    [self.view addSubview: self.picImageView];
    
    //初始化辅助歌词
    
    self.lyricLabel = [[UILabel alloc]initWithFrame:CGRectMake( 0 , (CGRectGetHeight(self.view.frame) / 3) * 2 - 30 , CGRectGetWidth(self.view.frame) , 30 )];
    
    self.lyricLabel.textAlignment = NSTextAlignmentCenter;
    
    self.lyricLabel.font = [UIFont systemFontOfSize:16];
    
    self.lyricLabel.alpha = 0.8;
    
    self.lyricLabel.textColor = [UIColor whiteColor];
    
    [self.view addSubview:self.lyricLabel];
    
    
    //初始化滑动视图
    
    self.scrollView = [[UIScrollView alloc]initWithFrame: CGRectMake(0, 64, CGRectGetWidth(self.view.frame), (CGRectGetHeight(self.view.frame) / 3) * 2 - 64) ];
    
    self.scrollView.pagingEnabled = YES;
    
    self.scrollView.showsHorizontalScrollIndicator=NO;//设置横向滑动的指示器是否显示 ,默认为YES显示
    
    self.scrollView.delegate = self;
    
    [self.view addSubview:self.scrollView];
    
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame) * 2, CGRectGetHeight(self.scrollView.frame));
    
    
    
    //--------1---------
    
    //       无
    
    //--------2---------
    
    
    //初始化歌词列表视图
    
    self.lyricTableView = [[LyricTableView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.scrollView.frame), 0 , CGRectGetWidth(self.scrollView.frame) , CGRectGetHeight(self.scrollView.frame))];
    
    [self.scrollView addSubview:self.lyricTableView];
    
}

#pragma mark ---底部视图

-(void)loadfootView{
    
    // 初始化底部视图 （y轴位置为初始隐藏位置，视图退出后  会执行动画移动到原有位置）
    
    self.footView = [[UIView alloc]initWithFrame:CGRectMake(0 , CGRectGetHeight(self.view.frame) , CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) / 3)];
    
    [self.view addSubview:self.footView];
    
    //分页指示器
    
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake( (CGRectGetWidth(self.view.frame) - 100) / 2, 0, 100, 20)];
    
    self.pageControl.numberOfPages = 2;
    
    self.pageControl.currentPage = 0;
    
    [self.footView addSubview:self.pageControl];
    
    
    
    //播放/暂停
    
    //UIButton 自带一个selected属性 是一个BOOL的值, button会在selected的值改变的时候自动调用自己的selected状态下的视图
    
    _PlayerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _PlayerButton.frame = CGRectMake(0, 0, 100, 100);
    
    _PlayerButton.center = CGPointMake((CGRectGetWidth(self.footView.frame))/2, CGRectGetHeight(self.footView.frame)/2);
    
    _PlayerButton.tintColor = BUTTONTINTCOLOR;
    
    //button在给state的时候.可以根据不同需求 去选择不同状态 , 要灵活的运用
    
    //设置button图片的渲染模式UIImageRenderingModeAlwaysTemplate 始终根据Tint Color绘制图片，忽略图片的颜色信息。
    
    [_PlayerButton setImage:[[UIImage imageNamed:@"iconfont-bofang"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    
    [_PlayerButton setImage:[[UIImage imageNamed:@"iconfont-pause"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]forState:UIControlStateSelected];
    
    [_PlayerButton addTarget:self action:@selector(PlayerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //获取当前播放状态
    
    _PlayerButton.selected = [self.avPlayer isPlay];
    
    [self.footView addSubview:_PlayerButton];
    
    
    
    //上一首
    
    UIButton *lastButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    lastButton.frame = CGRectMake(50, 50, 40, 40);
    
    lastButton.center = CGPointMake(CGRectGetWidth(self.footView.frame)/4  , CGRectGetHeight(self.footView.frame)/2);
    
    lastButton.tintColor = BUTTONTINTCOLOR;
    
    [lastButton setImage:[[UIImage imageNamed:@"iconfont-shangyishou"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    
    [lastButton addTarget:self action:@selector(LastButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.footView addSubview:lastButton];
    
    
    //下一首
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    nextButton.frame = CGRectMake( 0 , 0, 40, 40);
    
    nextButton.center = CGPointMake(CGRectGetWidth(self.footView.frame)/4 *3 , CGRectGetHeight(self.footView.frame)/2);
    
    nextButton.tintColor = BUTTONTINTCOLOR;
    
    [nextButton setImage:[[UIImage imageNamed:@"iconfont-xiayishou"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    
    [nextButton addTarget:self action:@selector(NextButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.footView addSubview:nextButton];
    
    
    //当前播放时间
    
    self.nowTime = [[UILabel alloc]initWithFrame:CGRectMake(10, 30 , 50, 20)];
    
    self.nowTime.font = [UIFont systemFontOfSize:14];
    
    self.nowTime.textColor = [UIColor whiteColor];
    
    self.nowTime.textAlignment = NSTextAlignmentCenter;
    
    self.nowTime.text = [self getStringWithTime:0];//默认
    
    [self.footView addSubview:self.nowTime];
    
    
    //歌曲总时间
    
    self.totaltime = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.footView.frame) - 60, 30 , 50, 20)];
    
    self.totaltime.font = [UIFont systemFontOfSize:14];
    
    self.totaltime.textColor = [UIColor whiteColor];
    
    self.totaltime.textAlignment = NSTextAlignmentCenter;
    
    [self.footView addSubview:self.totaltime];
    
    
    
    //初始化一个Slider  设置最大值和最小值  当前值
    
    self.slider=[[UISlider alloc]initWithFrame:CGRectMake( 120 / 2, 30 , CGRectGetWidth(self.footView.frame) - 120 , 20 )];
    
    self.slider.tintColor = BUTTONTINTCOLOR;
    
    //设置image的渲染模式
    
    [self.slider setThumbImage:[[UIImage imageNamed:@"iconfont-dian"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    
    self.slider.minimumTrackTintColor = BUTTONTINTCOLOR;
    
    self.slider.minimumValue = 0;
    
    self.slider.value = 0;
    
    //给slider绑定一个拖拽事件 拖拽时触发方法
    
    [self.slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    
    [self.footView  addSubview:self.slider];
    
    
    
    
    
    
    //底部功能button
    
    
    CGFloat footButton_Width = 25;
    
    CGFloat footButton_x = ( CGRectGetWidth(self.view.frame) - ( footButton_Width * 5 ) ) / 10;
    
    CGFloat footButton_y = ( CGRectGetHeight(self.footView.frame) - ( _PlayerButton.frame.origin.y + _PlayerButton.frame.size.height ) - footButton_Width ) / 2 + ( _PlayerButton.frame.origin.y + _PlayerButton.frame.size.height );
    
    //--喜欢按钮
    
    self.likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.likeButton.frame = CGRectMake(footButton_x, footButton_y, footButton_Width, footButton_Width);
    
    self.likeButton.tintColor = [UIColor whiteColor];
    
    [self.likeButton setImage:[[UIImage imageNamed:@"iconfont-shoucang"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    
    [self.likeButton setImage:[[UIImage imageNamed:@"iconfont-shoucang_s"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
    
    [self.likeButton addTarget:self action:@selector(likeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.footView addSubview:self.likeButton];
    
    //--获取本地循环类型
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    self.cycletype = [defaults integerForKey:@"cycleType"];
    
    //--循环按钮
    
    self.cycleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.cycleButton.frame = CGRectMake(footButton_x * 3 + footButton_Width , footButton_y, footButton_Width, footButton_Width);
    
    self.cycleButton.tintColor = [UIColor whiteColor];
    
    [self.cycleButton setImage:[[UIImage imageNamed:self.cycleImageArray[self.cycletype]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    
    [self.cycleButton addTarget:self action:@selector(cycleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.footView addSubview:self.cycleButton];
    
    //--下载按钮
    
    self.downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.downloadButton.frame = CGRectMake(footButton_x * 5 + footButton_Width * 2 , footButton_y, footButton_Width, footButton_Width);
    
    self.downloadButton.tintColor = [UIColor whiteColor];
    
    [self.downloadButton setImage:[[UIImage imageNamed:@"iconfont-xiazai"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    
    [self.downloadButton addTarget:self action:@selector(downloadButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.footView addSubview:self.downloadButton];
    
    //--分享按钮
    
    self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.shareButton.frame = CGRectMake(footButton_x * 7 + footButton_Width * 3 , footButton_y, footButton_Width, footButton_Width);
    
    self.shareButton.tintColor = [UIColor whiteColor];
    
    [self.shareButton setImage:[[UIImage imageNamed:@"iconfont-fenxiang"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    
    [self.shareButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.footView addSubview:self.shareButton];
    
    //--列表按钮
    
    self.listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.listButton.frame = CGRectMake(footButton_x * 9 + footButton_Width * 4 , footButton_y, footButton_Width, footButton_Width);
    
    self.listButton.tintColor = [UIColor whiteColor];
    
    [self.listButton setImage:[[UIImage imageNamed:@"iconfont-bofanglist"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    
    [self.listButton addTarget:self action:@selector(listButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.footView addSubview:self.listButton];
    
    
    
}

#pragma nark ---顶部按钮实现

//左按钮（收起）

-(void)heardLeftButtonAction:(UIButton *)sender
{
    //关闭视图控制器
    
    [self closeVC];
    
}

//右按钮

-(void)heardRightButtonAction:(UIButton*)sender{
    
    //获取当前音量
    
    self.moreView.nowVolume = [self.avPlayer getPlayVolume];
    
    __block MusicPlayerViewController *Self = self;
    
    //回调设置的音量
    
    self.moreView.block = ^(CGFloat index){
        
        //设置音量方法
        
        [Self setVolume:index];
        
    };
    
    //更多视图显示
    
    self.moreView.hidden = NO;
    
    //置为最顶层
    
    [self.view bringSubviewToFront:self.moreView];
    
}

#pragma mark ---中部滑动视图实现

//UIScrollViewDelegate
//scrollView减速停止 标志着scrollView滑动停止

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    //计算偏移量来确定分  页指示器的显示
    
    self.pageControl.currentPage = (scrollView.contentOffset.x)/CGRectGetWidth(scrollView.bounds);
    
}

//正在拖动时

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //获取滑动进度  为0时以滑动拖至第二页  为1时未滑动  显示的还是1-页
    
    CGFloat scrollJD = (scrollView.frame.size.width - scrollView.contentOffset.x ) / scrollView.frame.size.width;
    
    //设置中间视图控件透明度 (歌手名  专辑图  辅助歌词)
    
    self.picImageView.alpha = scrollJD;
    
    self.singerLabel.alpha = scrollJD;
    
    self.lyricLabel.alpha = scrollJD;
    
}


#pragma mark ---底部按钮实现

//播放／暂停

-(void)PlayerButtonClicked:(UIButton*)sender
{
    //判断播放状态 YES 播放 NO 暂停
    
    if ([self.avPlayer isPlay]) {
        
        //暂停成功  如果成功  更改button状态
        
        if ([self.avPlayer pauseMusic]) {
            
            sender.selected = NO;
            
        }
        
        //歌词播放状态播放
        
        self.lyricTableView.isPlayer = NO;
        
    } else {
        
        //继续播放 如果成功  更改button状态
        
        if ([self.avPlayer playMusic]) {
            
            sender.selected = YES;
            
        }
        
        //歌词播放状态播放
        
        self.lyricTableView.isPlayer = YES;
        
    }
    
}

//上一首

-(void)LastButtonClicked:(UIButton *)sender{
    
    [self.musicPLManage lastPlayMusic:self.music];
    
}

//下一首

-(void)NextButtonClicked:(UIButton*)sender{
    
    [self.musicPLManage nextPlayMusic:self.music];
}

//喜欢按钮

-(void)likeButtonAction:(UIButton*)sender{
    
    //UIButton 自带一个selected属性 是一个BOOL的值，button会在selected的值改变的时候自动调用自己的selected状态下的视图
    
    Music *music = self.music;
    
    CollectListManager  *collect = [CollectListManager shareMusicPlayerListManage];
    
    [collect addMusicToPlayerList:music];
    
    
    TYAlertView *alertView = [TYAlertView alertViewWithTitle:@"💗" message:@"添加成功"];
    
    [alertView addAction:[TYAlertAction actionWithTitle:@"确定" style:TYAlertActionStyleCancle handler:^(TYAlertAction *action) {
        
        
        
        
    }]];
    
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleAlert transitionAnimation:TYAlertTransitionAnimationDropDown];
    [self presentViewController:alertController animated:YES completion:nil];
    
    //    sender.selected = YES;
    
    //    if (sender.selected) {
    //
    //        sender.selected = NO;
    //
    //
    //
    //    }
    //
    //    else
    //    {
    //        sender.selected = YES;
    //
    //       // [collect deleteAllMusic];
    //    }
    
    
    
    
}

//循环按钮

-(void)cycleButtonAction:(UIButton *)sender
{
    
    //切换循环类型
    
    NSInteger cycInteger = self.cycletype;
    
    cycInteger++;
    
    if (cycInteger >2) {
        
        cycInteger = 0;
        
    }
    
    self.cycletype = cycInteger;
    
    //加载提示视图
    
    self.tipView.tipIndex = self.cycletype;
    
    // 持久化存储循环播放类型
    // 1.获取化存储环播放类型
    
    NSUserDefaults *delfaults = [NSUserDefaults standardUserDefaults];
    
    //2.读取保存的数据
    
    [delfaults setInteger:self.cycletype forKey:@"cycleType"];
    
    //3.强制让数据立刻保存
    
    [delfaults synchronize];
    
}

//下载按钮

-(void)downloadButtonAction:(UIButton*)sender
{
    
    
    
}


//分享按钮

-(void)shareButtonAction:(UIButton*)sender
{
    CGSize imageSize = [[UIScreen mainScreen] bounds].size;
    
//    if (nil != UIGraphicsBeginImageContextWithOptions) {
    
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
//        
//    }
    
//    else
    
//    {
    
//        UIGraphicsBeginImageContext(imageSize);
    
//    }
    
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    
    for (UIWindow * window in [[UIApplication sharedApplication] windows]) {
        
        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen]) {
            
            CGContextSaveGState(context);
            
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            
            CGContextConcatCTM(context, [window transform]);
            
            CGContextTranslateCTM(context, -[window bounds].size.width*[[window layer] anchorPoint].x, -[window bounds].size.height*[[window layer] anchorPoint].y);
            
            [[window layer] renderInContext:context];
            
            
            
            CGContextRestoreGState(context);
            
        }
        
    }
    
    
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    
    
    UIGraphicsEndImageContext();
    
    UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
    
    NSLog(@"Suceeded!");
    
    //    OSMessage *message= [[OSMessage alloc]init];
    //
    //    message.title = [NSString stringWithFormat:@"我正在刘璐－悦中收听:%@",self.music.name];
    //
    //    message.image = UIImageJPEGRepresentation(image, 1);
    //
    //    [OpenShare shareToWeibo:message Success:^(OSMessage *message) {
    //
    //        NSLog(@"分享到sina微博成功:\%@",message);
    //    } Fail:^(OSMessage *message, NSError *error) {
    //
    //        NSLog(@"分享到sina微博失败:\%@\n%@",message,error);
    //
    //    }];
    
    //    [OpenShare shareToWeixinTimeline:message Success:^(OSMessage *message) {
    //        NSLog(@"微信分享到朋友圈成功：\n%@",message);
    //    } Fail:^(OSMessage *message, NSError *error) {
    //        NSLog(@"微信分享到朋友圈失败：\n%@\n%@",error,message);
    //    }];
    
    
    
}

//列表按钮

-(void)listButtonAction:(UIButton *)sender
{
    //模态样式 (判断版本 IOS8.0以上 用UIModalPresentationOverCurrentContext)
    __block MusicPlayerViewController *Self = self;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        
        self.MPLVC.modalPresentationStyle=UIModalPresentationOverCurrentContext;
        
    }else{
        
        self.modalPresentationStyle=UIModalPresentationCurrentContext;
        
    }
    
    //模态跳转
    
    [self presentViewController:self.MPLVC animated:NO completion:^{
        
    }];
    
    //音乐列表视图消失回调Block
    
    self.MPLVC.disappearBlack = ^(){
        
        //－－获取本地循环类型
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        Self.cycletype = [defaults integerForKey:@"cycleType"];
        
    };
}

-(void)setCycletype:(NSInteger)cycletype
{
    if (_cycletype != cycletype) {
        
        _cycletype = cycletype;
    }
    //更新循环button显示图标
    
    [self.cycleButton setImage:[[UIImage imageNamed:self.cycleImageArray[self.cycletype]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    
}

#pragma mark ---slider 滑动事件

-(void)sliderValueChange:(UISlider *)slider{
    
    //CMtime 是一个结构体 需要用CMTimeMakeWithSeconds去返回CMtime这个结构体，需要填写俩个参数
    
    //参数一  具体的数值(slider的value)
    
    //参数二  跨度，如果改变频率的话  需要填写AVPlayer的播发频率属性
    
    [self.avPlayer setPlayToTime:CMTimeMakeWithSeconds(slider.value, 1)];
    
}



-(void)setMusic:(Music *)music{
    
    _music = music;
    
    //判断当前播放的歌曲是否为空
    
    if (music != nil) {
        
        //加载歌曲数据
        
        [self loadMusicData];
        
        
        
        
    } else {
        
        //关闭视图控制器
        
        [self closeVC];
        
    }
    
    
}

#pragma mark --  加载歌曲数据

-(void)loadMusicData
{
    
    //设置标题
    
    self.titleLabel.text = self.music.name;
    
    //设置歌手
    
    self.singerLabel.text = [NSString stringWithFormat:@"─ %@ ─",self.music.singer];
    
    //设置辅助歌词
    
    self.lyricLabel.text = [NSString stringWithFormat:@"%@ - %@",self.music.name,self.music.artistsName];
    
    //给slider一个最大值
    
    self.slider.maximumValue = [self.avPlayer getDurationTime];
    
    // 获取总播放时长
    
    self.totaltime.text = [self getStringWithTime:[self.avPlayer getDurationTime]];
    
    // 为歌词列表传递歌曲总时长
    
    self.lyricTableView.totalTime = [self.avPlayer getDurationTime];
    
    //加载背景图片
    
    [self loadBackGroundImageView];
    
    //加载专辑图
    
    [self loadPicImageView];
    
    //加载歌曲
    
    self.lyricTableView.lyricString = self.music.lyric;
    
}

//加载背景图

-(void)loadBackGroundImageView{
    
    [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:self.music.blurPicUrl]];
    
}

//加载专辑图

-(void)loadPicImageView
{
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:self.music.picUrl]placeholderImage:[UIImage imageNamed:@"music"]];
    
}


#pragma mark --现实音量调整

-(void)setVolume:(float)volume
{
    //作品音量控制
    
    [self.avPlayer setPlayVolume:volume];
}


#pragma mark --LazyLoading

-(MusicPlayerListViewController *)MPLVC
{
    if (_MPLVC == nil) {
        
        _MPLVC = [[MusicPlayerListViewController alloc]init];
        
    }
    
    return _MPLVC;
    
}

-(MusicPlayerListManager *)musicPLManage
{
    if (_musicPLManage == nil) {
        
        _musicPLManage = [MusicPlayerListManager shareMusicPlayerListManage];
        
    }
    
    return _musicPLManage;
    
}

-(AVPlayerManager *)avPlayer{
    
    if (_avPlayer == nil) {
        
        _avPlayer = [AVPlayerManager shareAVPlayerManage];
        
        _avPlayer.delegateMP = self;//设置代理
    }
    
    return _avPlayer;
    
}

-(NSArray *)cycleImageArray{
    
    if (_cycleImageArray == nil) {
        
        _cycleImageArray = [[NSArray alloc]initWithObjects:@"iconfont-danquxunhuan",@"iconfont-shunxuxunhuan",@"iconfont-suijibofang", nil];
        
    }
    
    return _cycleImageArray;
    
}

#pragma mark ---AVPlayerManageDelegate
-(void)playingMusic:(Music *)music
{
    //当前播放的歌曲
    
    self.music = music;
    
    
}

-(void)isPlay:(BOOL)isPlay

{
    //更新播放状态
    self.PlayerButton.selected = isPlay;
    
}

-(void)returnDurationTime:(CGFloat)time
{
    //给slider一个最大值
    
    self.slider.maximumValue = time;
    
    //获取总播放时间长
    
    self.totaltime.text = [self getStringWithTime:time];
    
    //为歌词列表传递歌曲总时长
    
    self.lyricTableView.totalTime = time;
    
}

-(void)returnNowPlayTime:(CGFloat)time
{
    //滑块视图赋值
    __block MusicPlayerViewController *Self = self;
    
    self.slider.value = time;
    
    //设置当前播放的时间长
    
    self.nowTime.text = [self getStringWithTime:time];
    
    //设置当前歌词
    
    self.lyricTableView.nowTime = time;
    
    //回调当前歌词block方法
    
    self.lyricTableView.blockLyric = ^(CGFloat time , NSString *text){
        
        //为辅助歌词label添加当前歌词内容
        
        Self.lyricLabel.text = text;
        
    };
    
    
}

-(void)returnNowPlayProgress:(CGFloat)Progress
{
    //判断是否正在进行收起推出(显示隐藏)
    
    if (self.isShow) {
        
        //专辑图旋转
        
        self.picImageView.transform = CGAffineTransformRotate(self.picImageView.transform , M_PI_4 / 225);
        
    }
    
}

- (void)returnNowBufferProgress:(CGFloat)Progress{
    
    
}


#pragma mark ---视图即将出现(执行动画)

-(void)viewWillAppear:(BOOL)animated{
    
    //开启视图控制器
    
    [self openVC];
    
    
}

#pragma mark ---开启视图控制器

- (void)openVC{
    
    //更新页面显示状态
    
    self.isShow = NO;
    
    //执行动画
    
    __block MusicPlayerViewController *Self = self;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        //设置动画速度曲线
        
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        
        //开始动画
        
        //专辑图推出动画
        
        //--缩放到原来大小
        
        CGAffineTransform newTransform =  CGAffineTransformScale(Self.picImageView.transform, 5, 5);
        
        [Self.picImageView setTransform:newTransform];
        
        //--重新制定专辑图中心点为原有位置
        
        Self.picImageView.center = CGPointMake( ( CGRectGetWidth(Self.view.frame) - 100 ) /2 + 50 , ( CGRectGetWidth(Self.view.frame) - 100 ) /2 + CGRectGetHeight(Self.heardView.frame) + 50 );
        
        
        //顶部视图推出动画
        
        Self.heardView.frame = CGRectMake(0, 0 , CGRectGetWidth(Self.heardView.frame), CGRectGetHeight(Self.heardView.frame));
        
        //底部视图推出动画
        
        Self.footView.frame = CGRectMake(0, (CGRectGetHeight(Self.view.frame) / 3) * 2 , CGRectGetWidth(Self.footView.frame), CGRectGetHeight(Self.footView.frame));
        
        //滑动视图显示
        
        Self.scrollView.alpha = 1;
        
        //隐藏辅助歌词动画(如果正在显示歌词 辅助歌词隐藏)
        
        if (Self.scrollView.contentOffset.x == Self.scrollView.frame.size.width) {
            
            Self.lyricLabel.alpha = 0;
            
        } else {
            
            Self.lyricLabel.alpha = 1;
            
        }
        
        
        
    } completion:^(BOOL finished) {
        
        //结束动画
        
        //完成收起推出 YES专辑图继续旋转
        
        Self.isShow = YES;
        
        
    }];
    
    
}

#pragma mark ---关闭视图控制器

- (void)closeVC{
    
    
    //更新页面显示状态
    
    self.isShow = NO;
    
    //收起动画
    
    __block MusicPlayerViewController *Self = self;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        //执行动画
        
        //专辑图收起动画
        
        //---缩放动画
        
        CGAffineTransform newTransform =  CGAffineTransformScale(Self.picImageView.transform, 0.2, 0.2);
        
        [Self.picImageView setTransform:newTransform];
        
        //重新定义专辑图的中心点坐标
        
        self.picImageView.center = CGPointMake(35 , CGRectGetHeight(self.view.frame) - 30);
        
        
        //顶部视图上移动画
        
        Self.heardView.frame = CGRectMake(0, 0 - CGRectGetHeight(Self.heardView.frame) - 30 , CGRectGetWidth(Self.heardView.frame), CGRectGetHeight(Self.heardView.frame));
        
        //底部视图下移动画
        
        Self.footView.frame = CGRectMake(0, CGRectGetHeight(Self.view.frame) , CGRectGetWidth(Self.footView.frame), CGRectGetHeight(Self.footView.frame));
        
        //隐藏滑动视图(歌词)
        
        Self.scrollView.alpha = 0;
        
        //隐藏辅助歌词动画
        
        Self.lyricLabel.alpha = 0;
        
        
        
    } completion:^(BOOL finished) {
        
        //动画结束
        
        //跳转
        
        Self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve; // 设置跳转动画效果
        
        [Self dismissViewControllerAnimated:YES completion:^{}];
        
        //完成收起推出 YES专辑图继续旋转
        
        Self.isShow = YES;
        
    }];
    
    
}

#pragma mark ---设置电池条前景部分样式类型 (白色)

-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
    
}

#pragma mark ---时间格式转换 将秒转换成指定格式字符串

- (NSString *)getStringWithTime:(NSInteger)time{
    
    NSInteger MM = 0;
    
    if (59 < time) {
        
        MM = time / 60 ;
        
    }
    
    return [NSString stringWithFormat:@"%.2ld:%.2ld",MM,time - MM * 60];
    
}







@end

