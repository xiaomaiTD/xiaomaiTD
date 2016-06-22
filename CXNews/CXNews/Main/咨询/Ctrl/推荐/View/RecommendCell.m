//
//  RecommendCell.m
//  CXNews
//
//  Created by liyoubing on 16/5/9.
//  Copyright © 2016年 liyoubing. All rights reserved.
//

#import "RecommendCell.h"
#import "InformationModel.h"
#import "UIImageView+WebCache.h"

@implementation RecommendCell

//布局  给数据
- (void)layoutSubviews {

    [super layoutSubviews];
    
    //设置图片
    NSString *imgURL = [NSString stringWithFormat:@"http:/123.57.246.163:8044%@",_model.img];
    [_imgView sd_setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[UIImage imageNamed:@"g_01.jpg"]];
    
    //设置title
    _titleLabel.text = _model.title;
    
    //设置时间
    _timeLabel.text = _model.date;
    
}

@end
