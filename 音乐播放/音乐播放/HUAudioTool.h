//
//  HUAudioTool.h
//  音乐播放
//
//  Created by huhang on 16/4/11.
//  Copyright © 2016年 huhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface HUAudioTool : NSObject

/** 播放音效名称 */
+ (void)playAudionWithFilename:(NSString *)filename;
/** 销毁 */
+ (void)disposeAudioWithFilename:(NSString *)filename;

/** 播放音乐 */
+ (AVAudioPlayer *)playMusicWithFilename:(NSString *)filename;
/** 暂停音乐 */
+ (void)pauseMusicWithFilename:(NSString *)filename;
/** 停止音乐 */
+ (void)stopMusicWithFilename:(NSString *)filename;

@end
