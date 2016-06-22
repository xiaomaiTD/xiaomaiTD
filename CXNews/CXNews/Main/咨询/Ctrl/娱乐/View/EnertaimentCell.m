//
//  EnertaimentCell.m
//  CXNews
//
//  Created by liyoubing on 16/5/9.
//  Copyright © 2016年 liyoubing. All rights reserved.
//

#import "EnertaimentCell.h"
#import "InformationModel.h"
#import "UIImageView+WebCache.h"

@interface EnertaimentCell () {

    UIImageView *_imgView;
    UILabel *_titleLabel;
    UILabel *_remarkLabel;
    UILabel *_timeLabel;
}

@end

@implementation EnertaimentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //创建子视图
        [self _initSubView];
        
    }
    
    return self;
    
}

- (void)_initSubView {

    _imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_imgView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.font = [UIFont boldSystemFontOfSize:19];
    [self.contentView addSubview:_titleLabel];
    
    _remarkLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _remarkLabel.textColor = [UIColor lightGrayColor];
    _remarkLabel.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:_remarkLabel];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_timeLabel];
    
}

//布局、给数据
- (void)layoutSubviews {

    [super layoutSubviews];
    
    _imgView.frame = CGRectMake(5, 5, 90, 90);
    //设置图片
    NSString *imgURL = [NSString stringWithFormat:@"http:/123.57.246.163:8044%@",_model.img];
    [_imgView sd_setImageWithURL:[NSURL URLWithString:imgURL]];
    
    _titleLabel.text = _model.title;
    _titleLabel.frame = CGRectMake(_imgView.right+5, 5, KScreenWidth-(_imgView.right+5)-5, 30);
    
    _remarkLabel.text = _model.remark;
    _remarkLabel.frame = CGRectMake(_titleLabel.left, _titleLabel.bottom+5, _titleLabel.width, 30);
    
    _timeLabel.text = _model.date;
    _timeLabel.frame = CGRectMake(_titleLabel.left, _remarkLabel.bottom+5, _titleLabel.width, 20);
}

@end
