//
//  HH_PlayerViewController.m
//  音乐播放
//
//  Created by huhang on 16/4/12.
//  Copyright © 2016年 huhang. All rights reserved.
//

#import "HH_PlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIView+BSExtension.h"
#import "HUAudioTool.h"
#import "HH_Music.h"
#import "HUMusicTool.h"
#import "HH_LrcView.h"

@interface HH_PlayerViewController()<AVAudioPlayerDelegate>

/** 歌曲背景大图片 */
@property (weak, nonatomic) IBOutlet UIImageView *iconBigImageView;
/** 歌曲名字 */
@property (weak, nonatomic) IBOutlet UILabel *filenameLabel;
/** 歌手名字 */
@property (weak, nonatomic) IBOutlet UILabel *singerLabel;
/** 总时间 */
@property (weak, nonatomic) IBOutlet UILabel *durationTimeLabel;
/** 滑块按钮 */
@property (weak, nonatomic) IBOutlet UIButton *sliderBtn;
/** 进度视图 */
@property (weak, nonatomic) IBOutlet UIView *progressView;
/** 播放按钮 */
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
/** 进度条背景视图 */
@property (weak, nonatomic) IBOutlet UIView *progressBackgroundView;

@property (strong ,nonatomic)AVAudioPlayer *player;

@property (strong ,nonatomic)HH_Music *currentMusic;

@property (strong,nonatomic)NSTimer *playerTimer;

@property (weak, nonatomic) IBOutlet HH_LrcView *lrcView;

@property (nonatomic,strong)CADisplayLink *link;

@property (weak, nonatomic) IBOutlet UILabel *currentLabel;

@end

@implementation HH_PlayerViewController

- (void)showPlayerView{

    //目前歌曲跟现在播放歌曲不一致,就清空数据
    if (self.currentMusic != [HUMusicTool currentMusic]) {
        [self resetNewPlayMusic];
    }
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.view.frame = window.bounds;
    [window addSubview:self.view];

    window.userInteractionEnabled = NO;
    
    self.view.y = self.view.height;
   [UIView animateWithDuration:1.0 animations:^{
      
      self.view.y = 0;
      
   } completion:^(BOOL finished) {
      
       window.userInteractionEnabled = YES;
       
       [self startPlayMusic];
       
       [self addGesture];
   }];
}

- (void)addGesture{
    //添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickProgressViewPlayMusic:)];
    [self.progressBackgroundView addGestureRecognizer:tap];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(dragSliderViewPlayMusic:)];
    [self.sliderBtn addGestureRecognizer:pan];
}

//开始播放音乐
- (void)startPlayMusic{

    HH_Music *music = [HUMusicTool currentMusic];
    
    self.player = [HUAudioTool playMusicWithFilename:music.filename];
    self.player.delegate = self;
    
    if (self.currentMusic == music){
        [self addPlayerTimer];
        [self addlrcLinkTimer];
        return;
    }
    
    //显示暂停按钮
    self.playBtn.selected = YES;
    
    self.currentMusic = music;
    
    self.iconBigImageView.image = [UIImage imageNamed:self.currentMusic.icon];
    self.filenameLabel.text = self.currentMusic.name;
    self.singerLabel.text = self.currentMusic.singer;
    self.durationTimeLabel.text = [self strWithTimeInterval:self.player.duration];
    self.progressView.width = 0;
    self.lrcView.lrcname = self.currentMusic.lrcname;
    
    [self addPlayerTimer];
    [self addlrcLinkTimer];
}

//重置数据
- (void)resetNewPlayMusic{
    
    //暂停定时器
    [self stopPlayerTimer];
    
    self.iconBigImageView.image = [UIImage imageNamed:@"play_cover_pic_bg"];
    self.singerLabel.text = @"";
    self.durationTimeLabel.text = @"";
    self.filenameLabel.text = @"";
    //停止歌曲
    [HUAudioTool stopMusicWithFilename:self.currentMusic.filename];
}

#pragma mark - 添加定时器
- (void)addPlayerTimer{

    if (self.player.playing == NO) return;
    //先更新数据
    [self updateProgressView];
    
    self.playerTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateProgressView) userInfo:nil repeats:YES];
    //添加到事件循环
    [[NSRunLoop mainRunLoop] addTimer:self.playerTimer forMode:NSRunLoopCommonModes];
}

//停止定时器
- (void)stopPlayerTimer{
    [self.playerTimer invalidate];
    self.playerTimer = nil;
}

//更新数据
- (void)updateProgressView{
    //获取进度
    double progress = self.player.currentTime / self.player.duration;
    //滑块滑动的最大距离
    double sliderMaxW = self.view.width - self.sliderBtn.width;
    //设置滑块位置
    self.sliderBtn.x = sliderMaxW * progress;
    //设置进度条宽
    self.progressView.width = self.sliderBtn.centerX;
    //设置滑块文字
    [self.sliderBtn setTitle:[self strWithTimeInterval:self.player.currentTime] forState:UIControlStateNormal];
}

#pragma mark - 添加歌词定时器
- (void)addlrcLinkTimer{
    
    if (self.player.playing == NO)return;
    
    self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateLrcLink)];
    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

//停止定时器
- (void)stopLrcLinkTimer{
    [self.link invalidate];
    self.link = nil;
}

//更新歌词数据
- (void)updateLrcLink{
    
    self.lrcView.currentTime = self.player.currentTime;
}

#pragma mark - 点击滑动条响应方法
- (void)clickProgressViewPlayMusic:(UITapGestureRecognizer *)sender{
    //获取点击位置
    CGPoint point = [sender locationInView:sender.view];
    //获取进度(点击位置是整块宽度,不是滑块所到位置)
    double progress = point.x / sender.view.width;
    //设置目前时间
    self.player.currentTime = progress * self.player.duration;
    //更新数据
    [self updateProgressView];
}

#pragma mark - 拖动滑块响应方法
- (void)dragSliderViewPlayMusic:(UIPanGestureRecognizer *)sender{

    //获取拖动位置
    CGPoint point = [sender translationInView:sender.view];
    [sender setTranslation:CGPointZero inView:sender.view];
    //设置滑块位置
    self.sliderBtn.x += point.x;
    //滑块最大位置
    CGFloat slideMaxW = self.view.width - self.sliderBtn.width;
    //矫正滑块位置
    if (self.sliderBtn.x > slideMaxW) {
        self.sliderBtn.x = slideMaxW;
    }else if (self.sliderBtn.x < 0){
        self.sliderBtn.x = 0;
    }
    //设置蓝色背景宽度
    self.progressView.width = self.sliderBtn.centerX;
    
    //设置进度
    double progress = self.sliderBtn.x / slideMaxW;
    NSTimeInterval time = progress * self.player.duration;
    //滑块文字
    [self.sliderBtn setTitle:[self strWithTimeInterval:time] forState:UIControlStateNormal];
    
    self.currentLabel.x = self.sliderBtn.x;
    self.currentLabel.text = [self strWithTimeInterval:time];
    
    //开始状态
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.currentLabel.hidden = NO;
        //停止计时器
        [self stopPlayerTimer];
        [self stopLrcLinkTimer];
    }else if (sender.state == UIGestureRecognizerStateEnded){
        self.currentLabel.hidden = YES;
        //设置当前播放时间
        self.player.currentTime = time;
        //判断滑动是否到最后,如果滑动最末尾,就播放下一首歌曲
        if (self.player.currentTime == self.player.duration) {
            [self nextMusicAction:nil];
            return;
        }
        //播放歌曲
        if (self.player.playing) {
            [self addPlayerTimer];
            [self addlrcLinkTimer];
        }
    }
}

- (NSString *)strWithTimeInterval:(NSTimeInterval)inter{
    int m = inter / 60;
    int s = (int)inter % 60;
    return [NSString stringWithFormat:@"%02d:%02d",m,s];
}

#pragma mark - 退出
- (IBAction)quitAction:(id)sender {
   
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:1.0 animations:^{
        self.view.y = self.view.height;
    } completion:^(BOOL finished) {
        window.userInteractionEnabled = YES;
    }];
}

#pragma mark - 歌词
- (IBAction)musicWord:(UIButton *)sender {
    if (self.lrcView.isHidden) {//显示歌词,隐藏图片
        self.lrcView.hidden = NO;
        sender.selected = YES;
    }else{//隐藏歌词,显示图片
        self.lrcView.hidden = YES;
        sender.selected = NO;
    }
}

#pragma mark - 上一首
- (IBAction)previousMusicAction:(id)sender {
    //重置数据
    [self resetNewPlayMusic];
    //设置上一曲为当前播放歌曲
    [HUMusicTool setCurrentPlayerMusic:[HUMusicTool previousMusic]];
    //开始播放
    [self startPlayMusic];
}

#pragma mark - 下一首
- (IBAction)nextMusicAction:(id)sender {
    [self resetNewPlayMusic];
    [HUMusicTool setCurrentPlayerMusic:[HUMusicTool nextMusic]];
    [self startPlayMusic];
}

#pragma mark - 播放
- (IBAction)playMusicAction:(id)sender {
    
    if (self.playBtn.selected) {
        //暂停按钮->播放按钮
        self.playBtn.selected = NO;
       //暂停定时器
        [self stopPlayerTimer];
        [self stopLrcLinkTimer];
        
        //暂停歌曲
        [HUAudioTool pauseMusicWithFilename:self.currentMusic.filename];
    }else{
    
        //播放按钮->暂停按钮
        self.playBtn.selected = YES;
        
        //开始播放
        [self startPlayMusic];
    }
}

#pragma mark AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [self nextMusicAction:nil];
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player{
    if (player.playing) {
        [HUAudioTool pauseMusicWithFilename:self.currentMusic.filename];
    }
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags{
    if (!player.playing) {
        [self startPlayMusic];
    }
}

@end
