//
//  CollectionViewController.m
//  musicPlayer
//
//  Created by haoyang_zheng on 16/4/9.
//  Copyright © 2016年 DAC. All rights reserved.
//

#import "CollectionViewController.h"

#import "Music.h"

#import "CollectListManager.h"

#import "MusicPlayerListManager.h"

#import "UIView+TYAlertView.h"

@interface CollectionViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,strong) MusicPlayerListManager *musicPLManage;//音乐播放列表管理

@property (nonatomic,strong) CollectListManager *collectManage;//收藏列表

@property (nonatomic,strong) UITableView *tableView;//表视图

@property (nonatomic,strong) NSMutableArray *dataArray;//数据源数组

@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"收藏列表";
    
    //右按钮
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"全部删除" style:UIBarButtonItemStylePlain target:self action:@selector(Bar_OnClick:)];
    
    //dataArray初始化
    
    _dataArray = [[NSMutableArray alloc]init];
    
    //初始化列表视图
    
    [self loadTableView];
    
    [self loadData];
}

//按钮事件

-(void)Bar_OnClick:(UIBarButtonItem*)bbi
{
    
    TYAlertView *alertView = [TYAlertView alertViewWithTitle:@"⚠️" message:@"确定全部删除？"];
    
    [alertView addAction:[TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancle handler:^(TYAlertAction *action) {
        
        NSLog(@"取消删除全部");
        
    }]];
    
    [alertView addAction:[TYAlertAction actionWithTitle:@"确定" style:TYAlertActionStyleDestructive handler:^(TYAlertAction *action) {
        
        [self.collectManage deleteAllMusic];
        
        [self.dataArray removeAllObjects];
        
        [self.tableView reloadData];
        
    }]];
    
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleAlert];
    
    //alertController.alertViewOriginY = 60;
    [self presentViewController:alertController animated:YES completion:nil];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self loadData];
}

-(void)loadTableView{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 60 )];
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    [self.view addSubview: _tableView];
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CELL"];
    
}

-(void)loadData
{
    //查询全部
    
    self.dataArray = [self.collectManage selectAllMusic];
    
    //更新列表视图
    
    [self.tableView reloadData];
    
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSObject * _obj = _dataArray[sourceIndexPath.row];
    
    [_dataArray removeObjectAtIndex:sourceIndexPath.row];
    
    [_dataArray insertObject:_obj atIndex:destinationIndexPath.row];
}


#pragma mark --UItableViewDataSource , UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
    
    cell.textLabel.text = [[self.dataArray objectAtIndex:indexPath.row] name];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    _tableView.allowsMultipleSelectionDuringEditing = YES;
    
    //将选择歌曲传给音乐播放列表 添加到播放队列中
    
    Music *music = [self.dataArray objectAtIndex:indexPath.row];
    
    [self.musicPLManage addMusicToPlayerList:music];
    
}


- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *ac = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        [self.collectManage deleteMusicWithMusic:self.dataArray[indexPath.row]];
        
        [_dataArray removeObjectAtIndex:indexPath.row];
        
        [_tableView reloadData];
        
    }];
    
    NSArray *arr = [NSArray arrayWithObject:ac];
    
    return arr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CollectListManager *)collectManage
{
    if (_collectManage == nil) {
        
        _collectManage = [CollectListManager shareMusicPlayerListManage];
        
    }
    
    return _collectManage;
}


-(MusicPlayerListManager *)musicPLManage{
    
    if (_musicPLManage == nil) {
        
        _musicPLManage = [MusicPlayerListManager shareMusicPlayerListManage];
        
    }
    
    return _musicPLManage;
    
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