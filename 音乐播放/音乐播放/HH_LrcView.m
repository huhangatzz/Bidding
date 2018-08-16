//
//  HH_LrcView.m
//  音乐播放
//
//  Created by huhang on 16/4/18.
//  Copyright © 2016年 huhang. All rights reserved.
//

#import "HH_LrcView.h"
#import "HH_LrcCell.h"
#import "HH_LrcLine.h"
#import "UIView+BSExtension.h"
@interface HH_LrcView()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)NSMutableArray *lrcLines;

/** 目前需要显示的行 */
@property (nonatomic,assign)int currentIndex;

@end

@implementation HH_LrcView

- (NSMutableArray *)lrcLines{
    if (!_lrcLines) {
        _lrcLines = [NSMutableArray array];
    }
    return _lrcLines;
}

- (id)initWithCoder:(NSCoder *)aDecoder{

    if (self = [super initWithCoder:aDecoder]) {
        [self setupTableView];
    }
    return self;
}

- (void)setupTableView{

    UITableView *tableView = [[UITableView alloc]init];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self addSubview:tableView];
    self.tableView = tableView;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.tableView.frame = self.bounds;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.height * 0.5, 0, self.tableView.height * 0.5, 0);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.lrcLines.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    HH_LrcCell *cell = [HH_LrcCell cellWithTableView:tableView];
    cell.lrcLine = self.lrcLines[indexPath.row];
    if (self.currentIndex == indexPath.row) {
        cell.textLabel.font = [UIFont systemFontOfSize:16];
    }else{
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    
    return cell;
}

//获取歌词数据
- (void)setLrcname:(NSString *)lrcname{

    _lrcname = lrcname;
    
    [self.lrcLines removeAllObjects];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:lrcname withExtension:nil];
    NSString *urlStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    NSArray *lrcArrs = [urlStr componentsSeparatedByString:@"\n"];
    for (NSString *lrcStr in lrcArrs) {
        
        if (![lrcStr hasPrefix:@"["]) continue;
        
        HH_LrcLine *lrcLine = [[HH_LrcLine alloc]init];
        if ([lrcStr hasPrefix:@"[ti:"] || [lrcStr hasPrefix:@"[ar:"] || [lrcStr hasPrefix:@"[al:"]) {
            NSString *word = [[lrcStr componentsSeparatedByString:@":"] lastObject];
            lrcLine.word = [word substringToIndex:word.length - 1];
        }else{
        
            NSArray *array = [lrcStr componentsSeparatedByString:@"]"];
            lrcLine.time = [[array firstObject] substringFromIndex:1];
            lrcLine.word = [array lastObject];
        }
        [self.lrcLines addObject:lrcLine];
    }
    [self.tableView reloadData];
}

- (void)setCurrentTime:(NSTimeInterval)currentTime{

    if (currentTime < _currentTime) {
        self.currentIndex = 0;
    }
    _currentTime = currentTime;
    
    //目前时间
    NSString *currentTimeStr = [self strWithTimeInsterval:currentTime];
   
    for (int idx = self.currentIndex; idx < self.lrcLines.count; idx++) {
        
        //取出模型
        HH_LrcLine *lrcLine = self.lrcLines[idx];
        //模型中目前时间
        NSString *currentLineTime = lrcLine.time;
        //下一个时间
        NSString *nextLineTime = nil;
        NSInteger nextIdx = idx + 1;
        if (nextIdx < self.lrcLines.count) {
            HH_LrcLine *lrcLine = self.lrcLines[nextIdx];
            nextLineTime = lrcLine.time;
        }
        
        if (([currentTimeStr compare:currentLineTime] != NSOrderedAscending ) && ([currentTimeStr compare:nextLineTime] == NSOrderedAscending) && self.currentIndex != idx) {
            
            NSArray *reloadRows = @[[NSIndexPath indexPathForRow:self.currentIndex inSection:0],
                                    [NSIndexPath indexPathForRow:idx inSection:0]];
            [self.tableView reloadRowsAtIndexPaths:reloadRows withRowAnimation:UITableViewRowAnimationNone];
            
            self.currentIndex = idx;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }
}

- (NSString *)strWithTimeInsterval:(NSTimeInterval)interval{

    int m = interval / 60;
    int s = (int)interval % 60;
    int ms = (interval - (int)interval) * 100;
    return [NSString stringWithFormat:@"%02d:%02d.%02d",m,s,ms];
}



@end
