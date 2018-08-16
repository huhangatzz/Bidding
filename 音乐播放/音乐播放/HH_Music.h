//
//  HH_Music.h
//  音乐播放
//
//  Created by huhang on 16/4/12.
//  Copyright © 2016年 huhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HH_Music : NSObject

/** 音乐名字 */
@property (nonatomic,copy)NSString *name;

/** 图片名字 */
@property (nonatomic,copy)NSString *singerIcon;

/** 歌手名字 */
@property (nonatomic,copy)NSString *singer;

/** 歌词名字 */
@property (nonatomic,copy)NSString *lrcname;

/** 歌曲名字 */
@property (nonatomic,copy)NSString *filename;

/** 背景图片 */
@property (nonatomic,copy)NSString *icon;

@end
