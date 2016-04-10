//
//  MainViewController.m
//  musicPlayer
//
//  Created by haoyang_zheng on 16/4/9.
//  Copyright © 2016年 DAC. All rights reserved.
//

#import "MainViewController.h"
#import "CollectionViewController.h"
#import "MusicListViewController.h"
@interface MainViewController ()

@property (nonatomic, strong) UIButton *allMusicBtn;

@property (nonatomic, strong) UIButton *collectMusicBtn;

@end

@implementation MainViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    self.title = @"音楽";
    // Do any additional setup after loading the view.
    [self loadInitView];
}
- (void)loadInitView{
    _allMusicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _allMusicBtn.frame = CGRectMake(100, 100, 100, 40);
    
    [_allMusicBtn setTitle:@"全部歌曲" forState:UIControlStateNormal];
    
    [_allMusicBtn addTarget:self action:@selector(AllMusicButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_allMusicBtn];
    
    _collectMusicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _collectMusicBtn.frame = CGRectMake(100, 200, 100, 40);
    
    [_collectMusicBtn setTitle:@"收藏列表" forState:UIControlStateNormal];
    
    [_collectMusicBtn addTarget:self action:@selector(collectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_collectMusicBtn];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)collectButtonAction:(UIButton*)sender
{
    CollectionViewController *COVC = [[CollectionViewController alloc]init];
    
    [self.navigationController pushViewController:COVC animated:YES];
}

-(void)AllMusicButtonAction:(UIButton*)sender
{
    //旋转全部歌曲页面
    MusicListViewController *MLVC = [[MusicListViewController alloc]init];
    
    [self.navigationController pushViewController:MLVC animated:YES];
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
