//
//  LyricTableView.m
//  MusicPlayer
//
//  Created by haoyang_zheng on 16/4/9.
//  Copyright © 2016年 DAC. All rights reserved.
//

#import "LyricTableView.h"

#import "PCH.h"

#import "LyricTableViewCell.h"

#import "NSString+GetMusicLyricArray.h"

@interface LyricTableView ()

@property (nonatomic,strong) NSMutableArray *dataArray; // 数据源数组

@property (nonatomic,strong) NSMutableArray *timeArray; //时间数组

@property (nonatomic,strong) NSMutableArray *textArray; //文字数组

@property (nonatomic,strong) LyricTableViewCell *cell; //当前播放歌词的cell

@property (nonatomic,strong) UIView *scrollIndicatorView;//滑动指示器视图

@property (nonatomic,assign) NSInteger playingIndex;//当前播放的下标

@property (nonatomic,assign) CGFloat nowLyricTime;//当前播放的歌词时间

@property (nonatomic,assign) CGFloat nextTime;//下一首歌词时间

@end

@implementation LyricTableView

-(NSMutableArray *)timeArray{
    
    if (_timeArray == nil) {
        
        _timeArray = [[NSMutableArray alloc]init];
        
    }
    
    return _timeArray;
}

-(NSMutableArray *)textArray{
    
    if (_textArray == nil) {
        
        _textArray = [[NSMutableArray alloc]init];
        
    }
    
    return _textArray;
}

//初始化tableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //注册
        
        [self registerClass:[LyricTableViewCell class] forCellReuseIdentifier:@"cell"];
        
        //去除分割线
        
        self.separatorStyle=UITableViewCellSeparatorStyleNone;
        
        //背景颜色透明度
        
        self.backgroundColor=[[UIColor whiteColor] colorWithAlphaComponent:0];
        
        
        self.dataSource = self;
        
        self.delegate = self;
        
        //初始化滑动指示器视图
        
        _scrollIndicatorView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 40)];
        
        _scrollIndicatorView.center = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame)/2);
        
        _scrollIndicatorView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
        
        _scrollIndicatorView.hidden = YES;//默认隐藏
        
        [self.viewForFirstBaselineLayout addSubview:_scrollIndicatorView];
        
        
    }
    return self;
}

- (void)setLyricString:(NSString *)lyricString{
    
    if (_lyricString != lyricString) {
        
        _lyricString =lyricString;
        
        
    }
    
    //初始化正在播放的歌词时间
    
    self.nowLyricTime = 0;
    
    //初始化下一个歌词时间
    
    self.nextTime = 0;
    
    //将歌词字符串转换成数组
    
    if (lyricString != nil) {
        
        self.dataArray = [NSString getMusicLyricArrayWithString:lyricString];
        
    }
    
}

- (void)setDataArray:(NSMutableArray *)dataArray{
    
    if (_dataArray != dataArray) {
        
        //清空数组
        
        _timeArray = nil;
        
        _textArray = nil;
        
        _dataArray = dataArray;
        
    }
    
    //解析歌词
    for (NSString *string in dataArray) {
        
        NSArray *tempArray = [string componentsSeparatedByString:@"]"];
        
        NSString *time = tempArray[0];
        
        [self.timeArray addObject: [NSNumber numberWithFloat:[self getTimeMsWithString:[time substringFromIndex:1]]]];
        
        [self.textArray addObject:tempArray[1]];
        
    }
    //更新数据
    
    [self reloadData];
    
    
    self.contentInset = UIEdgeInsetsMake( CGRectGetHeight(self.frame) / 2 , 0, CGRectGetHeight(self.frame) / 2 , 0 );
    
    
}

//获取当前播放时间

-(void)setNowTime:(CGFloat)nowTime{
    
    if (_nowTime != nowTime) {
        
        _nowTime = nowTime;
        
    }
    
    [self showPlayLyricCellWithNowTime:nowTime isScrollToRow:YES];
    
}

//显示播放歌词cell (现在歌曲播放时间 , 是否跳转到该cell)

- (void)showPlayLyricCellWithNowTime:(CGFloat)nowTime isScrollToRow:(BOOL)scroll
{
    
    
    //因为每0.1秒会执行一次此方法, 所以要判断当前播放时间是否播到了下一条歌词的时间 如果没有说明正在播放当前这条歌词 , 只有当前这条播完才能进入执行
    
    if (self.nextTime <= nowTime || self.nowLyricTime >= nowTime)
    {
        
        //判断当前播放时间在歌词数组中的位置
        
        for (NSInteger i = self.timeArray.count - 1 ; i >= 0; i--)
        {
            
            CGFloat tempTime = [[self.timeArray objectAtIndex:i] floatValue];
            
            
            
            if (tempTime <= nowTime )
            {
                
                
                //是否跳转到该cell
                
                if (scroll) {
                    
                    //滑动到该下标的cell
                    
                    [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                }
                
                //设置正在播放的cell的下标
                
                self.playingIndex = i;
                
                //获取当前歌词的cell
                
                self.cell =  (LyricTableViewCell *)[self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                
                //获取当前歌词的cell的LyricView
                
                LyricView_A *tempLyricView = self.cell.lyricView;
                
                //下一首歌词时间
                
                self.nextTime = [[self.timeArray objectAtIndex:i < self.timeArray.count - 1 ? i + 1 : i ] floatValue];
                
                if (tempTime == nowTime) {
                    
                    //如果是最后一条歌词 则 总时长减去当前进度
                    
                    [tempLyricView startLyric:( ( i == self.timeArray.count - 1 ? self.totalTime : self.nextTime )  - nowTime )];
                    
                } else {
                    
                    //nowTime - tempTime 等于这条歌词已经播放的时间
                    
                    [tempLyricView startLyricWithTime:( nowTime - tempTime ) TotalTime:( ( i == self.timeArray.count - 1 ? self.totalTime : self.nextTime )  - nowTime )];
                    
                }
                
                //当前播放的歌词时间(数组中的歌词的时间)
                
                self.nowLyricTime = tempTime;
                
                
                //(防止重复执行播放歌词)
                
                break;
                
            }
            
        }
        
        
    }
    
    
    //如果当前播放时间等于0 说明重新播放了歌曲 初始化属性
    
    if (nowTime == 0) {
        
        //初始化正在播放的歌词时间
        
        self.nowLyricTime = 0;
        
        //初始化下一个歌词时间
        
        self.nextTime = 0;
    }
    
    
    
    
}



//是否播放

-(void)setIsPlayer:(BOOL)isPlayer{
    
    if (_isPlayer != isPlayer) {
        
        _isPlayer = isPlayer;
        
    }
    
    //像歌词视图传值
    
    self.cell.lyricView.isPlayer = isPlayer;
    
}


#pragma mark ---UITableViewDataSource , UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count ;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LyricTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    
    //设置cell点击样式
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //设置cell大小
    
    cell.lyricView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), 44);
    
    //传递数据
    
    cell.lyricView.text = self.textArray[indexPath.row];
    
    cell.lyricView.textColor = [UIColor whiteColor];
    
    cell.lyricView.textLoadColor = BUTTONTINTCOLOR;
    
    if (indexPath.row == self.playingIndex) {
        
        NSLog(@"当前播放的歌词下标 : %ld",self.playingIndex);
        
    } else {
        
        [cell.lyricView restoreLyric];
        
    }
    
    return cell;
}




////正在滑动
//
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//
//    //显示滑动指示器视图
//
//    self.scrollIndicatorView.hidden = NO;
//
//
//}








#pragma mark ---将指定时间格式转成秒数

- (CGFloat)getTimeMsWithString:(NSString *)string{
    
    NSArray * MMarray = [string componentsSeparatedByString:@":"];
    
    NSArray * SSarray = [[MMarray objectAtIndex:1] componentsSeparatedByString:@"."];
    
    NSInteger MM = [[MMarray objectAtIndex:0] integerValue];//分
    
    NSInteger SS = [[SSarray objectAtIndex:0] integerValue];//秒
    
    NSInteger MS = [[SSarray objectAtIndex:1] integerValue];//毫秒
    
    NSInteger result = (MS + SS * 1000 + MM * 60 * 1000)/100;//十分一秒
    
    return  result / 10;
    
}






@end