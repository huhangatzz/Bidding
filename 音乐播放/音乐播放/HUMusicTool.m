//
//  HUMusicTool.m
//  音乐播放
//
//  Created by huhang on 16/4/12.
//  Copyright © 2016年 huhang. All rights reserved.
//

#import "HUMusicTool.h"
#import "MJExtension.h"
#import "HH_Music.h"

@implementation HUMusicTool

static NSArray *_musics;

static HH_Music *_currentMusic;

+ (NSArray *)musics{
    if (!_musics) {
        _musics = [HH_Music mj_objectArrayWithFilename:@"Musics.plist"];
    }
    return _musics;
}

//设置当前播放音乐
+ (void)setCurrentPlayerMusic:(HH_Music *)music{
    if (!music && ![[self musics] containsObject:music]) return;
    _currentMusic = music;
}

//正在播放的音乐
+ (HH_Music *)currentMusic{
    return _currentMusic;
}

//上一曲
+ (HH_Music *)previousMusic{

    NSUInteger currentIndex = [[self musics] indexOfObject:_currentMusic];
    NSInteger previousIndex = currentIndex - 1;
    
    if (previousIndex < 0) {
        previousIndex = [[self musics] count] - 1;
    }
    return [[self musics] objectAtIndex:previousIndex];
}

//下一曲
+ (HH_Music *)nextMusic{

    NSUInteger currentIndex = [[self musics] indexOfObject:_currentMusic];
    NSInteger nextIndex = currentIndex + 1;
    if (nextIndex >= [[self musics] count]) {
        nextIndex = 0;
    }
    return [[self musics] objectAtIndex:nextIndex];
}

@end
