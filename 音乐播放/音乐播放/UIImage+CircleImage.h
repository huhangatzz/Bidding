//
//  UIImage+CircleImage.h
//  音乐播放
//
//  Created by huhang on 16/4/12.
//  Copyright © 2016年 huhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CircleImage)

+ (instancetype)circleImageWithName:(NSString *)name borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

@end
