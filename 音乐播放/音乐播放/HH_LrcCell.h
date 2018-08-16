//
//  HH_LrcCell.h
//  音乐播放
//
//  Created by huhang on 16/4/19.
//  Copyright © 2016年 huhang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HH_LrcLine;

@interface HH_LrcCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

/** 模型 */
@property (nonatomic,strong)HH_LrcLine *lrcLine;
@end
