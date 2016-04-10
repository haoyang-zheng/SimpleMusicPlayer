//
//  MusicBarViewController.m
//  MusicPlayer
//
//  Created by haoyang_zheng on 16/4/9.
//  Copyright © 2016年 DAC. All rights reserved.
//

#import "MusicBarViewController.h"

#import "CircularProgressView.h"

#import "PCH.h"

#import "AVPlayerManager.h"

#import "MusicPlayerListManager.h"

#import "MusicPlayerListViewController.h"

#import "MusicPlayerViewController.h"

#import "Music.h"

#import "MusicBarView.h"

@interface MusicBarViewController ()<AVPlayerManageDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) AVPlayerManager *avPlayer;//音乐播放管理

@property (nonatomic,strong) MusicPlayerListManager *musicPLManage;//音乐播放列表管理

@property (nonatomic,strong) MusicPlayerListViewController *MPLVC;//音乐播放列表

@property (nonatomic,strong) MusicPlayerViewController *musicPVC;//音乐播放视图控制器

@property (nonatomic,strong) Music *music;//当前音乐模型

@property (nonatomic,strong) Music *lastMusic;//上一首音乐模型

@property (nonatomic,strong) Music *nextMusic;//下一首播放模型

@property (nonatomic,strong) UIVisualEffectView *VE;//毛玻璃背景视图

@property (nonatomic,strong) UIScrollView *scrollView;//滑动视图

@property (nonatomic,strong) MusicBarView *musicView;//当前歌曲视图

@property (nonatomic,strong) MusicBarView *lastMusicView;//上一首歌曲视图

@property (nonatomic,strong) MusicBarView *nextMusicView;//下一首歌曲视图

@property (nonatomic,strong) UIButton *playerButton;//播放按钮

@property (nonatomic,strong) UIButton *listButton;//列表按钮

@property (nonatomic,strong) UILabel *promptLabel;//提示Label

@property (nonatomic,strong) CircularProgressView *CPV;//环形进度条

@property (nonatomic,strong) UIView *bufferView;//缓冲进度条视图

@end

@implementation MusicBarViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //设置大小位置
    
    self.tabBar.frame = CGRectMake(0, CGRectGetHeight([[UIScreen mainScreen] bounds]) - 60 , CGRectGetWidth([[UIScreen mainScreen] bounds]), 60);
    
    //获取音乐播放管理
    
    self.avPlayer = [AVPlayerManager shareAVPlayerManage];
    
    self.avPlayer.delegateMB = self;//设置代理
    
    //加载音乐栏视图
    
    [self loadMusicBarView];
    
    
    //获取上一次关闭应用时播放的歌曲信息
    
    [self.musicPLManage newlyPlayMusic];
    
}

#pragma mark --- 加载音乐栏视图

- (void)loadMusicBarView{
    
    
    
    
    //初始化毛玻璃背景视图
    
    _VE = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    
    _VE.frame = CGRectMake(0, 0, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
    
    [self.tabBar addSubview:_VE];
    
    //初始化控件
    
    //缓冲进度视图
    
    _bufferView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0 , _VE.frame.size.height)];
    
    _bufferView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    
    [_VE addSubview:_bufferView];
    
    
    
    
    //播放按钮
    
    _playerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _playerButton.backgroundColor = [UIColor clearColor];
    
    _playerButton.frame = CGRectMake(CGRectGetWidth(_VE.frame) - 100, 10 , 40 ,  40 );
    
    _playerButton.backgroundColor = [UIColor clearColor];
    
    _playerButton.tintColor = BUTTONTINTCOLOR;
    
    [_playerButton setImage:[[UIImage imageNamed:@"iconfont-bofang"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    
    [_playerButton setImage:[[UIImage imageNamed:@"iconfont-pause"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]forState:UIControlStateSelected];
    
    [_playerButton addTarget:self action:@selector(PlayerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [_VE addSubview:_playerButton];
    
    
    //初始化环形进度条 并添加点击手势
    
    UITapGestureRecognizer *circularProgressViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(circularProgressViewTapAction:)];
    
    _CPV = [[CircularProgressView alloc] initWithFrame:CGRectMake( 0.5, 0.6 , 38, 38)];
    
    [_CPV addGestureRecognizer:circularProgressViewTap];
    
    [_playerButton addSubview:_CPV];//插入到playerButton下面
    
    _CPV.trackColor = [UIColor clearColor];
    
    _CPV.progressColor = BUTTONTINTCOLOR;
    
    _CPV.progress = 0;//默认进度
    
    _CPV.progressWidth = 2;
    
    
    //音乐列表按钮
    
    _listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _listButton.frame = CGRectMake(CGRectGetWidth(_VE.frame) - 50 , 13.5 , 32 ,  32 );
    
    _listButton.tintColor = BUTTONTINTCOLOR;
    
    [_listButton setImage:[[UIImage imageNamed:@"iconfont-bofanglist2"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    
    [_listButton addTarget:self action:@selector(ListButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [_VE addSubview:_listButton];
    
    
    //初始化提示Label
    
    _promptLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, CGRectGetWidth(_VE.frame) - 125, CGRectGetHeight(_VE.frame))];
    
    _promptLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    
    _promptLabel.font = [UIFont systemFontOfSize:18];
    
    _promptLabel.text = @"   暂无音乐";
    
    _promptLabel.hidden = YES;//默认隐藏
    
    [_VE addSubview:_promptLabel];
    
    
    //初始化滑动视图 并为添加轻拍手势
    
    UITapGestureRecognizer *tapScrollView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapScrollViewAction:)];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(5, 0, CGRectGetWidth(_VE.frame) - 125, CGRectGetHeight(_VE.frame))];
    
    _scrollView.contentSize = CGSizeMake( ( CGRectGetWidth(_VE.frame) - 125 ) * 3 , CGRectGetHeight(_VE.frame));
    
    _scrollView.contentOffset = CGPointMake( CGRectGetWidth(_VE.frame) - 125 , 0);//默认偏移
    
    _scrollView.pagingEnabled = YES;
    
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    _scrollView.delegate = self;
    
    [_scrollView addGestureRecognizer:tapScrollView];
    
    
    
    [_VE addSubview: _scrollView];
    
    
    
    //初始化当前歌曲视图
    
    _musicView = [[MusicBarView alloc]initWithFrame:CGRectMake(CGRectGetWidth(_scrollView.frame), 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame))];
    
    [_scrollView addSubview:_musicView];
    
    
    //初始化上一首歌曲视图
    
    _lastMusicView = [[MusicBarView alloc]initWithFrame:CGRectMake(0 , 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame))];
    
    [_scrollView addSubview:_lastMusicView];
    
    //初始化下一首歌曲视图
    
    _nextMusicView = [[MusicBarView alloc]initWithFrame:CGRectMake(CGRectGetWidth(_scrollView.frame) * 2 , 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame))];
    
    [_scrollView addSubview:_nextMusicView];
    
    
}


-(void)setMusic:(Music *)music{
    
    if (_music != music) {
        
        
        
        _music = music ;
        
    }
    
    if (music != nil) {
        
        //有音乐时样式
        
        [self haveMusicViewStyle];
        
        //获取当前歌曲的上一首歌曲
        
        self.lastMusic = [self.musicPLManage lastPlayingMusic];
        
        //获取当前歌曲的下一首歌曲
        
        self.nextMusic = [self.musicPLManage nextPlayingMusic];
        
        //添加数据
        
        self.musicView.music = music;
        
        self.lastMusicView.music = self.lastMusic;
        
        self.nextMusicView.music = self.nextMusic;
        
        
    } else {
        
        //无音乐时视图样式
        
        [self noMusicViewStyle];
        
        //释放音乐播放视图控制器
        
        
        _musicPVC = nil;
        
    }
    
    //缓冲进度视图宽度归0
    
    _bufferView.frame = CGRectMake(0, 0, 0, self.tabBar.frame.size.height);
    
}

//有音乐时视图样式

- (void)haveMusicViewStyle{
    
    //显示滑动视图
    
    self.scrollView.hidden = NO;
    
    //2个按钮可用
    
    self.playerButton.enabled = YES;
    
    self.listButton.enabled = YES;
    
    //button变为原色
    
    self.playerButton.tintColor = BUTTONTINTCOLOR;
    
    self.listButton.tintColor = BUTTONTINTCOLOR;
    
    //隐藏提示Label
    
    self.promptLabel.hidden = YES;
    
}

//无音乐时视图样式

- (void)noMusicViewStyle{
    
    //隐藏滑动视图
    
    self.scrollView.hidden = YES;
    
    //2个按钮不可用
    
    self.playerButton.enabled = NO;
    
    self.listButton.enabled = NO;
    
    //button变为灰色
    
    self.playerButton.tintColor = [UIColor grayColor];
    
    self.listButton.tintColor = [UIColor grayColor];
    
    //显示提示Label
    
    self.promptLabel.hidden = NO;
    
    //环形进度条进度归0
    
    self.CPV.progress = 0;
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 */

#pragma mark ---播放/暂停button

-(void)PlayerButtonClicked:(UIButton *)sender{
    
    //判断播放状态 YES 播放 NO 暂停
    
    if ([self.avPlayer isPlay]) {
        
        //暂停播放 如果成功 更改button状态
        
        if ([self.avPlayer pauseMusic]) {
            
            sender.selected = NO;
            
        }
        
    } else {
        
        //继续播放 如果成功 更改button状态
        
        if([self.avPlayer playMusic]){
            
            sender.selected = YES;
            
        }
        
    }
    
    
}

#pragma mark ---环形进度条视图 (在PlayerButton之上 点击响应PlayerButtonClicked方法)

- (void)circularProgressViewTapAction:(UITapGestureRecognizer *)tap{
    
    [self PlayerButtonClicked:self.playerButton];
    
}

#pragma mark ---音乐列表button

-(void)ListButtonClicked:(UIButton *)sender{
    
    __block MusicBarViewController *Self = self;
    
    //添加跳转动画
    
    [UIView animateWithDuration:0.5 animations:^{
        
        //收起音乐栏
        
        Self.tabBar.frame = CGRectMake(0, CGRectGetHeight([[UIScreen mainScreen] bounds]) , CGRectGetWidth([[UIScreen mainScreen] bounds]), 60);
        
    } completion:^(BOOL finished) {
        
        //模态样式 (判断版本 IOS8.0以上 用UIModalPresentationOverCurrentContext)
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
            
            Self.MPLVC.modalPresentationStyle=UIModalPresentationOverCurrentContext;
            
        }else{
            
            Self.modalPresentationStyle=UIModalPresentationCurrentContext;
            
        }
        
        //模态跳转
        
        [Self presentViewController:self.MPLVC animated:NO completion:^{}];
        
    }];
    
    //音乐播放列表视图消失时回调Block
    
    self.MPLVC.disappearBlack = ^(){
        
        //添加动画
        
        [UIView animateWithDuration:0.5 animations:^{
            
            //推出音乐栏
            
            Self.tabBar.frame = CGRectMake(0, CGRectGetHeight([[UIScreen mainScreen] bounds]) - 60 , CGRectGetWidth([[UIScreen mainScreen] bounds]), 60);
            
        }];
        
    };
    
    
}


#pragma mark ---音乐栏滑动视图点击事件 推出音乐播放页面

- (void)tapScrollViewAction:(UITapGestureRecognizer *)tap{
    
    // 设置动画效果
    
    self.musicPVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:self.musicPVC animated:YES completion:^{}];
    
}




#pragma mark ---lazyLoading

-(MusicPlayerListViewController *)MPLVC{
    
    if (_MPLVC == nil) {
        
        _MPLVC = [[MusicPlayerListViewController alloc]init];
        
    }
    
    return _MPLVC;
    
}

-(MusicPlayerListManager *)musicPLManage{
    
    if (_musicPLManage == nil) {
        
        _musicPLManage = [MusicPlayerListManager shareMusicPlayerListManage];
        
    }
    
    return _musicPLManage;
    
}

- (MusicPlayerViewController *)musicPVC{
    
    if (_musicPVC == nil) {
        
        _musicPVC = [[MusicPlayerViewController alloc]init];
        
    }
    
    return _musicPVC;
    
}


#pragma mark ---AVPlayerManageDelegate

- (void)playingMusic:(Music *)music{
    
    //当前播放的歌曲
    
    self.music = music;
    
}


-(void)isPlay:(BOOL)isPlay{
    
    //更新播放状态
    
    self.playerButton.selected = isPlay;
    
}

-(void)returnNowPlayTime:(CGFloat)time{
    
    //当前歌曲视图专辑图旋转
    
    [self.musicView rotatePicImageView];
    
}

-(void)returnNowPlayProgress:(CGFloat)Progress{
    
    _CPV.progress = Progress;//设置播放进度
    
}

-(void)returnNowBufferProgress:(CGFloat)Progress{
    
    //缓冲进度
    
    _bufferView.frame = CGRectMake(0, 0, CGRectGetWidth(self.tabBar.frame) * Progress  , self.VE.frame.size.height);
    
}



#pragma mark ---UIScrollViewDelegate

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    //拖动结束后播放
    
    [self.avPlayer playMusic];
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    //开始拖动时暂停
    
    [self.avPlayer pauseMusic];
    
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //停止拖动时
    
    //判断滑动方向 进行上一首下一首切换
    
    if (scrollView.contentOffset.x <=  1) {
        
        //上一首
        
        [self.musicPLManage lastPlayMusic:self.music];
        
        //还原滑动视图偏移量
        
        scrollView.contentOffset = CGPointMake( CGRectGetWidth(scrollView.frame) , 0);
        
    } else if (scrollView.contentOffset.x >= CGRectGetWidth(scrollView.frame) * 2){
        
        //下一首
        
        [self.musicPLManage nextPlayMusic:self.music];
        
        //还原滑动视图偏移量
        
        scrollView.contentOffset = CGPointMake( CGRectGetWidth(scrollView.frame), 0);
        
    }
    
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

