//
//  HUAudioTool.m
//  音乐播放
//
//  Created by huhang on 16/4/11.
//  Copyright © 2016年 huhang. All rights reserved.
//

#import "HUAudioTool.h"
#import <AVFoundation/AVFoundation.h>
@implementation HUAudioTool

static NSMutableDictionary *_soundIds;
static NSMutableDictionary *_plays;

+ (NSMutableDictionary *)soundIDs{

    if (!_soundIds) {
        _soundIds = [NSMutableDictionary dictionary];
    }
    return _soundIds;
}

+ (NSMutableDictionary *)plays{

    if (!_plays) {
        _plays = [NSMutableDictionary dictionary];
    }
    return _plays;
}

//真实开发,一般不使用这个方法
+ (void)playAudionWithFilename:(NSString *)filename{
    
    //判断文件文是否为nil
    if (!filename) return;
    
    SystemSoundID soundID = [[self soundIDs][filename] unsignedIntValue];
    
    //判断soundid是否为nil
    if (!soundID){
    
        NSLog(@"创建新soundID");
        
        NSURL *url = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
        
        //判断url是否为nil
        if (!url) return;
    
        //创建音效id
        AudioServicesCreateSystemSoundID(((__bridge CFURLRef)url), &soundID);
        
        //将音效id添加到字典中
        [self soundIDs][filename] = @(soundID);
    };
    AudioServicesPlaySystemSound(soundID);
}

+ (void)disposeAudioWithFilename:(NSString *)filename{

    if (!filename) return;
    
    SystemSoundID soundId = [[self soundIDs][filename] unsignedIntValue];
    
    if (soundId) {
        //移除
        AudioServicesDisposeSystemSoundID(soundId);
        //从字典中移除
        [[self soundIDs] removeObjectForKey:@(soundId)];
    }
}

/** 播放音乐 */
+ (AVAudioPlayer *)playMusicWithFilename:(NSString *)filename{

    //1.判断文件名是否为空
    if (filename.length == 0) return nil;
    
    //2.从字典中取播放器
    AVAudioPlayer *player = [self plays][filename];
    
    if (!player) {
        
        //2.1根据文件名称加载音效url
        NSURL *url = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
        
        //2.2判断url是否为空
        if (!url) return nil;
        
        //2.3创建播放器
        player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
        
        //2.4是否是正在准备播放
        if (![player prepareToPlay]) return nil;
        
        //2.5允许快进
        player.enableRate = YES;
        
        //2.6将播放器添加到字典中
        [self plays][filename] = player;
    }

    //3.判断是否正在播放
    if (!player.playing) {
        [player play];
    }
    
    return player;
}

/** 暂停音乐 */
+ (void)pauseMusicWithFilename:(NSString *)filename{

    //判断文件是否为空
    if (filename.length == 0) return;
    
    //根据文件取出播放器
    AVAudioPlayer *player = [self plays][filename];
    
    //判断播放器是否存在
    if (player) {
        //判断播放是否正在播放
        if (player.playing) {
            //暂停播放器
            [player pause];
        }
    }
}

/** 停止音乐 */
+ (void)stopMusicWithFilename:(NSString *)filename{

    //判断文件名是否为空
    if (filename.length == 0) return;
 
    //从字典中取出播放器
    AVAudioPlayer *player = [self plays][filename];
    //判断播放器是否存在
    if (player) {
        //停止播放器
        [player stop];
        //从字典中移除播放器
        [[self plays] removeObjectForKey:filename];
    }
}

@end
