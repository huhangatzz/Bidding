//
//  HUMusicTool.h
//  音乐播放
//
//  Created by huhang on 16/4/12.
//  Copyright © 2016年 huhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HH_Music;

@interface HUMusicTool : NSObject

+ (NSArray *)musics;

//设置当前播放的音乐
+ (void)setCurrentPlayerMusic:(HH_Music *)music;

//正在播放的音乐
+ (HH_Music *)currentMusic;

//上一曲
+ (HH_Music *)previousMusic;

//下一曲
+ (HH_Music *)nextMusic;

@end
