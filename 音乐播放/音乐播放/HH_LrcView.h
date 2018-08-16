//
//  HH_LrcView.h
//  音乐播放
//
//  Created by huhang on 16/4/18.
//  Copyright © 2016年 huhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DRNRealTimeBlurView.h"

@interface HH_LrcView : DRNRealTimeBlurView

/** 歌曲名 */
@property (nonatomic,copy)NSString *lrcname;

/** 目前时间 */
@property (nonatomic,assign)NSTimeInterval currentTime;

@end
