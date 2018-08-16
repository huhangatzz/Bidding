//
//  HH_LrcCell.m
//  音乐播放
//
//  Created by huhang on 16/4/19.
//  Copyright © 2016年 huhang. All rights reserved.
//

#import "HH_LrcCell.h"
#import "HH_LrcLine.h"
@implementation HH_LrcCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    HH_LrcCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[HH_LrcCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.numberOfLines = 0;
        self.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)layoutSubviews{

    [super layoutSubviews];
    self.textLabel.frame = self.bounds;
}

- (void)setLrcLine:(HH_LrcLine *)lrcLine{

    _lrcLine = lrcLine;
    self.textLabel.text = lrcLine.word;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
