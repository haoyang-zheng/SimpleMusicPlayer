//
//  MusicPlayerListViewController.m
//  MusicPlayer
//
//  Created by haoyang_zheng on 16/4/9.
//  Copyright © 2016年 DAC. All rights reserved.
//

#import "MusicPlayerListViewController.h"


#import "MusicPlayerListTableViewCell.h"

#import "MusicPlayerListManager.h"

#import "PCH.h"

@interface MusicPlayerListViewController ()<UITableViewDelegate , UITableViewDataSource , AVPlayerManageDelegate>

@property (nonatomic,strong)AVPlayerManager *avPlayer;//音乐播放管理

@property (nonatomic,strong)MusicPlayerListManager *musicPLManage;//音乐播放列表管理

@property (nonatomic,strong)Music *music;//音乐数据模型

@property (nonatomic,strong)UIVisualEffectView *VE;//毛玻璃背景

@property (nonatomic,strong)UIButton *cycleButton;//循环按钮

@property (nonatomic,strong)NSArray *cycleImageArray;//循环图标数组

@property (nonatomic,assign)NSInteger cycleType;//循环类型 0.单曲循环  1.顺序循环  2.随机循环

@property (nonatomic,strong)UILabel *cycleTypeLabel;//当前循环模式

@property (nonatomic,strong)UIButton *clearButton;//清空列表按钮

@property (nonatomic,strong)UITableView *musicPlayerList;//音乐播放列表

@property (nonatomic,strong)UIButton *backButton;//返回关闭按钮

@property (nonatomic,strong)NSMutableArray *dataArray;//数据源数组

@end


@implementation MusicPlayerListViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //设置视图背景颜色 透明黑色
    
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    
    
    //加载初始化控件
    
    [self loadInitView];
    
}

#pragma  mark ---加载初始化控件

- (void)loadInitView{
    
    
    //初始化玻璃视图
    
    _VE = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    
    _VE.frame = CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), 370);
    
    [self.view addSubview:_VE];
    
    //初始化循环按钮
    
    _cycleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _cycleButton.frame = CGRectMake(0, 0, 60, 60);
    
    _cycleButton.tintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    
    [_cycleButton setImage:[[UIImage imageNamed:self.cycleImageArray[_cycleType]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]forState:UIControlStateNormal];
    
    [_cycleButton addTarget:self action:@selector(cycleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_VE addSubview:_cycleButton];
    
    
    //初始化当前循环模式
    
    _cycleTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, CGRectGetWidth(_VE.frame) - 120 , 60)];
    
    _cycleTypeLabel.textColor = [UIColor whiteColor];
    
    _cycleTypeLabel.textAlignment = NSTextAlignmentCenter;
    
    _cycleTypeLabel.font = [UIFont systemFontOfSize:18];
    
    [_VE addSubview:_cycleTypeLabel];
    
    
    //初始化清空按钮
    
    _clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _clearButton.frame = CGRectMake(CGRectGetWidth(self.VE.frame) - 60, 0, 60, 60);
    
    [_clearButton setTitle:@"清空" forState:UIControlStateNormal];
    
    [_clearButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_clearButton addTarget:self action:@selector(clearButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_VE addSubview:_clearButton];
    
    
    //初始化音乐播放列表视图
    
    _musicPlayerList = [[UITableView alloc]initWithFrame:CGRectMake(0, 60, CGRectGetWidth(_VE.frame), 250)];
    
    _musicPlayerList.dataSource = self;
    
    _musicPlayerList.delegate = self;
    
    _musicPlayerList.backgroundColor = [UIColor clearColor];
    
    [_VE addSubview:_musicPlayerList];
    
    
    //初始化返回取消button
    
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _backButton.frame = CGRectMake(0, CGRectGetHeight(self.VE.frame) - 60, CGRectGetWidth(self.VE.frame), 60);
    
    [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_backButton setTitle:@"关闭" forState:UIControlStateNormal];
    
    [_backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_VE addSubview:_backButton];
    
    //分隔线
    
    UIImageView *SeparateImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 60, CGRectGetWidth(self.VE.frame), 1)];
    
    SeparateImageView.backgroundColor = [UIColor grayColor];
    
    SeparateImageView.alpha = 0.0;
    
    [_VE addSubview:SeparateImageView];
    
    //分隔线2
    
    UIImageView *Separate2ImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.VE.frame)-60, CGRectGetWidth(self.VE.frame), 1)];
    
    Separate2ImageView.backgroundColor = [UIColor grayColor];
    
    Separate2ImageView.alpha = 0.8;
    
    [_VE addSubview:Separate2ImageView];
    
    //注册CELL
    
    [_musicPlayerList registerClass:[MusicPlayerListTableViewCell class] forCellReuseIdentifier:@"cell"];
    
}

#pragma marl ---加载数据库数据

- (void)loadData{
    
    //查询全部
    
    self.dataArray = [self.musicPLManage selectAllMusic];
    
    //更新列表视图
    
    [self.musicPlayerList reloadData];
    
    //获取当前播放的歌曲
    
    self.music = [self.musicPLManage playingMusic];
    
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

#pragma  mark ---循环按钮事件

- (void)cycleButtonAction:(UIButton *)sender{
    
    //切换循环类型
    
    NSInteger cycInteger =  self.cycleType;
    
    cycInteger++;
    
    if (cycInteger >2) {
        
        cycInteger = 0;
        
    }
    
    self.cycleType = cycInteger;
    
    
    //持久化存储循环播放类型
    
    //1.获取NSUserDefaults对象
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    //2.读取保存的数据
    
    [defaults setInteger:self.cycleType forKey:@"cycleType"];
    
    //3.强制让数据立刻保存
    
    [defaults synchronize];
    
    
}

- (void)setCycleType:(NSInteger)cycleType{
    
    if (_cycleType != cycleType) {
        
        _cycleType = cycleType;
        
    }
    
    //判断要提示的循环类型
    
    NSString *string;
    
    switch (cycleType) {
            
        case 0:
            
            string = @"单曲循环模式";
            
            break;
            
        case 1:
            
            string = [NSString stringWithFormat: @"顺序播放模式(%ld首)",self.dataArray.count];
            
            break;
            
        case 2:
            
            string = [NSString stringWithFormat: @"随机播放模式(%ld首)",self.dataArray.count];
            
            break;
            
        default:
            
            break;
    }
    
    //添加提示的内容
    
    self.cycleTypeLabel.text = string;
    
    //更新循环button显示图标
    
    [self.cycleButton setImage:[[UIImage imageNamed:self.cycleImageArray[cycleType]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    
}




#pragma  mark ---清空按钮事件

- (void)clearButtonAction:(UIButton *)sender{
    
//    __block MusicPlayerListViewController *Self = self;
    
    //弹出询问框 确认是否清空
    
    UIAlertController * alertContorller = [UIAlertController alertControllerWithTitle:nil message:@"清空当前播放队列?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *alertActionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {}];
    
    UIAlertAction *alertActionDefault = [UIAlertAction actionWithTitle:@"清空" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        NSLog(@"执行清空");
        
        if([self.musicPLManage deleteAllMusic]){
            
            NSLog(@"数据删除成功");
            
            //清空数据源数组
            
            self.dataArray = nil;
            
            //视图关闭 跳转上一页面
            
            [self viewWillDisappear:YES];
            
        }else{
            
            NSLog(@"数据删除失败");
        }
        
    }];
    
    [alertContorller addAction:alertActionCancel];
    
    [alertContorller addAction:alertActionDefault];
    
    [self presentViewController:alertContorller animated:YES completion:^{}];
    
    
}

#pragma  mark ---返回关闭按钮事件

- (void)backButtonAction:(UIButton *)sender{
    
    [self viewWillDisappear:YES];
    
}

#pragma  mark ---当前View触摸事件

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self viewWillDisappear:YES];
    
}


#pragma mark ---lazyLoading

-(NSArray *)cycleImageArray{
    
    if (_cycleImageArray == nil) {
        
        _cycleImageArray = [[NSArray alloc]initWithObjects:@"iconfont-danquxunhuan",@"iconfont-shunxuxunhuan",@"iconfont-suijibofang", nil];
        
    }
    
    return _cycleImageArray;
    
}

-(NSMutableArray *)dataArray{
    
    if (_dataArray == nil) {
        
        _dataArray = [[NSMutableArray alloc]init];
        
    }
    
    return _dataArray;
    
}

- (MusicPlayerListManager *)musicPLManage{
    
    if (_musicPLManage == nil) {
        
        _musicPLManage = [MusicPlayerListManager shareMusicPlayerListManage];
        
    }
    
    return _musicPLManage;
    
}


#pragma mark ---UITableViewDataSource , UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MusicPlayerListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if (self.dataArray.count >0) {
        
        cell.music = [self.dataArray objectAtIndex:indexPath.row];
        
        cell.playingMusic = self.music;
        
        //(响应删除按钮事件)删除指定音乐
        
        __block MusicPlayerListViewController *Self = self;
        
        cell.deleteBlock = ^(Music *music){
            
            //如果删除的只剩最后一个了 执行清空操作
            
            if (Self.dataArray.count<2) {
                
                [Self clearButtonAction:nil];
                
            } else {
                
                //向音乐播放列表管理发送删除音乐操作
                
                [Self.musicPLManage deleteMusicWithMusic:music];
                
                //重新查询全部
                
                Self.dataArray = [Self.musicPLManage selectAllMusic];
                
                //更新列表视图
                
                [Self.musicPlayerList reloadData];
                
            }
            
        };
        
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.music = [self.dataArray objectAtIndex:indexPath.row];
    
    //播放指定歌曲
    
    [self.musicPLManage playMusicWithMusic:self.music];
    
    //更新视图
    
    [self.musicPlayerList reloadData];
    
}

#pragma mark ---AVPlayerManageDelegate

- (void)playingMusic:(Music *)music{
    
    //当前播放的歌曲
    
    self.music = music;
    
    //更新列表
    
    [self.musicPlayerList reloadData];
    
}



#pragma mark ---设置电池条前景部分样式类型 (白色)

-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
    
}


#pragma mark ---视图即将出现时

-(void)viewWillAppear:(BOOL)animated{
    
    //加载数据
    
    [self loadData];
    
    __block MusicPlayerListViewController *Self = self;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        Self.view.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
        
        //推出
        
        Self.VE.frame = CGRectMake(0, CGRectGetHeight(Self.view.frame) - Self.VE.frame.size.height , Self.VE.frame.size.width , Self.VE.frame.size.height);
        
        
    } completion:^(BOOL finished) {
        
        //--获取本地循环类型
        
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        
        self.cycleType = [defaults integerForKey:@"cycleType"];
        
        //获取AVPlayerManage并设置代理
        
        self.avPlayer = [AVPlayerManager shareAVPlayerManage];
        
        self.avPlayer.delegateMPL = self;
        
    }];
    
}

#pragma mark ---视图即将消失时

-(void)viewWillDisappear:(BOOL)animated{
    
    
    
    __block MusicPlayerListViewController *Self = self;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.view.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0];
        
        //收回
        
        Self.VE.frame = CGRectMake(0, CGRectGetHeight(Self.view.frame) , Self.VE.frame.size.width , Self.VE.frame.size.height);
        
    } completion:^(BOOL finished) {
        
        //跳转
        
        [self dismissViewControllerAnimated:YES completion:^{}];
        
        //调用视图消失Block
        
        self.disappearBlack();
        
    }];
    
}



@end

