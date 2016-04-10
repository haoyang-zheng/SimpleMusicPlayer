//
//  MusicListViewController.m
//  musicPlayer
//
//  Created by haoyang_zheng on 16/4/9.
//  Copyright © 2016年 DAC. All rights reserved.
//

#import "MusicListViewController.h"

//#import "MusicPlayerListViewController.h"

#import "NetWork.h"

#import "Music.h"

#import "MusicPlayerListManager.h"


@interface MusicListViewController ()<UISearchResultsUpdating,UISearchBarDelegate,UISearchDisplayDelegate,UITableViewDataSource , UITableViewDelegate>


@property (nonatomic , strong ) MusicPlayerListManager *musicPLManage;//音乐播放列表管理

@property (nonatomic , strong) UITableView *tableView; //表视图

@property (nonatomic , strong) NSMutableArray *datatArray;//数据源数组

@property (nonatomic , strong) NSMutableArray *searchArray;//返回搜索结果

@property (nonatomic , strong) UISearchController * display;//搜索控制器

@end

@implementation MusicListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"全部歌曲";
    
    //初始化数据源数组
    
    _datatArray = [[NSMutableArray alloc]init];
    
    //初始化搜索结果
    
    _searchArray = [[NSMutableArray alloc]init];
    
    //初始化列表视图
    
    [self loadTableView];
    
    //加载数据
    
    [self loadData];
    
    //加载搜索器
    
    [self createSearchController];
    
}

#pragma mark ---创建UISearchController
-(void)createSearchController{
    
    _display = [[UISearchController alloc]initWithSearchResultsController:nil];
    
    //签署一个协议 ，更新 结构有关的协议
    
    _display.searchResultsUpdater = self;
    //结果弹出期间隐藏navigationbar = no
    _display.hidesNavigationBarDuringPresentation = NO;
    
    //是否添加半透明覆盖层
    
    _display.dimsBackgroundDuringPresentation = NO;
    
    //设置搜索控制器自带的搜索栏
    
    _display.searchBar.frame = CGRectMake(_display.searchBar.frame.origin.x, _display.searchBar.frame.origin.y, _display.searchBar.frame.size.width, 44);
    
    
    self.definesPresentationContext = NO;
    
    _tableView.tableHeaderView = _display.searchBar;
    
    
    _display.searchBar.keyboardAppearance = UIKeyboardAppearanceLight;
    
    _display.searchBar.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    
    _display.searchBar.barStyle = UIBarStyleDefault;
    
    _display.searchBar.placeholder = @"请输入内容";
    //设置二级键盘
    _display.searchBar.inputAccessoryView = nil;
    
}
#pragma mark - UISearchResultsUpdating协议
//当搜索栏中的内容发生了改变，或者搜索栏变成第一响应者时候被调用
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    
    //如果搜索结果不为空，先给我清空
    
    if (_searchArray !=nil) {
        [_searchArray removeAllObjects];
    }
    
    NSArray *array = [_datatArray filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(Music *evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        
        if ([evaluatedObject.name rangeOfString:self.display.searchBar.text].location != NSNotFound ) {
            
            return YES;
        }
        else
        {
            return NO;
        }
        
    }]];
    
    if ([array count]) {
        
        for (Music *m in array) {
            
            [_searchArray addObject:m];
        }
    }
    
    
    //重新载入数据
    [_tableView reloadData];
}

#pragma mark ---初始化列表视图

- (void)loadTableView{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 60 )];
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    [self.view addSubview: _tableView];
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CELL"];
    
    
}

#pragma mark ---加载数据

- (void)loadData{
    
    //先查询本地是否存在数据 并获取
    
    [self loadLocalData];
    
    //请求数据
    
    __block MusicListViewController *Self = self;
    
    [[NetWork shareNetworking] netWorkGetWithURL:@"http://115.28.227.1/teacher/UIAPI/LNMusic.php" Block:^(id object) {
        
        //解析JSON
        
        [Self JSONObjectWithData:object];
        
    }];
    
    //    拿到数据之后  刷新tableView的数据
    
    //    reloaData的作用
    
    //    使用方法：1  从网络拿数据  在拿到数据之后  需要刷新（reloadData）一次tableview   2：希望替换tabview的数据的时候需要刷新（reloadData）tableview*******例子*****某些项目中  需要一个tabview展示两种不同的数据  这个时候需要切换数据源  所以需要刷新tableView
    
    //    重走tableview得两个代理方法
    
}

#pragma mark ---解析JSON

- (void)JSONObjectWithData:(id)data {
    
    //解析JSON
    
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    for (NSDictionary *itemDic in jsonArray) {
        
        Music *music = [[Music alloc]init];
        
        music.mid = [[[itemDic valueForKey:@"id"] stringValue]integerValue];
        
        music.name = [itemDic valueForKey:@"name"];
        
        music.album = [itemDic valueForKey:@"album"] ;
        
        music.singer = [itemDic valueForKey:@"singer"];
        
        music.artistsName = [itemDic valueForKey:@"artists_name"];
        
        music.picUrl = [itemDic valueForKey:@"picUrl"];
        
        music.blurPicUrl = [itemDic valueForKey:@"blurPicUrl"];
        
        music.duration = [[[itemDic valueForKey:@"duration"] stringValue]floatValue];
        
        music.lyric = [itemDic valueForKey:@"lyric"];
        
        music.mp3Url = [itemDic valueForKey:@"mp3Url"];
        
        [self.datatArray addObject:music];
        
    }
    
    //保存到本地
    
    [self saveLocalData:data];
    
    
    //刷新tableView
    
    [self.tableView reloadData];
    
    
}

#pragma mark ---查询本地数据并获取解析

- (void)loadLocalData{
    
    NSData *data = [NSData dataWithContentsOfFile:[[self documentPath] stringByAppendingPathComponent:@"MusicListData.txt"]];
    
    if(data == nil){
        
        NSLog(@"没有本地歌曲列表数据");
        
    } else {
        
        [self JSONObjectWithData:data];
    }
    
}

#pragma mark ---添加本地数据

- (void)saveLocalData:(id)data{
    
    if (data != nil) {
        
        [data writeToFile:[[self documentPath] stringByAppendingPathComponent:@"MusicListData.txt"] atomically:YES];
        
    }
    
}

#pragma mark ---获取document路径

- (NSString *)documentPath{
    
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    return array.firstObject;
    
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



#pragma mark ---UITableViewDataSource , UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_display.isActive) {
        
        return self.searchArray.count;
        
    }
    
    return self.datatArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    
    if (_display.isActive) {
        
        cell.textLabel.text = [[self.searchArray objectAtIndex:indexPath.row]name];
        
    }
    else
    {
        cell.textLabel.text = [[self.datatArray objectAtIndex:indexPath.row] name];
    }
    
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //将选择歌曲传给音乐播放列表 添加到播放队列中
    
    Music *music = [self.datatArray objectAtIndex:indexPath.row];
    
    [self.musicPLManage addMusicToPlayerList:music];
    
}


#pragma mark ---lazyLoading

-(MusicPlayerListManager *)musicPLManage{
    
    if (_musicPLManage == nil) {
        
        _musicPLManage = [MusicPlayerListManager shareMusicPlayerListManage];
        
    }
    
    return _musicPLManage;
    
}




@end
