//
//  HH_MusicViewController.m
//  音乐播放
//
//  Created by huhang on 16/4/12.
//  Copyright © 2016年 huhang. All rights reserved.
//

#import "HH_MusicViewController.h"
#import "HH_PlayerViewController.h"
#import "HUMusicTool.h"
#import "HH_Music.h"
#import "UIImage+CircleImage.h"
@interface HH_MusicViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView *tableView;

/** 播放详情页 */
@property (nonatomic,strong)HH_PlayerViewController *playerVC;

@end

@implementation HH_MusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"歌曲列表";

    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [[HUMusicTool musics] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }

    HH_Music *music = [HUMusicTool musics][indexPath.row];
    cell.imageView.image = [UIImage circleImageWithName:music.singerIcon borderWidth:2 borderColor:[UIColor blueColor]];
    cell.textLabel.text = music.name;
    cell.detailTextLabel.text = music.singer;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [HUMusicTool setCurrentPlayerMusic:[HUMusicTool musics][indexPath.row]];
    [self.playerVC showPlayerView];
}

- (HH_PlayerViewController *)playerVC{
    if (!_playerVC) {
        _playerVC = [[HH_PlayerViewController alloc]init];
    }
    return _playerVC;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
