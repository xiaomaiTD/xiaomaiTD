//
//  JokeCell.m
//  CXNews
//
//  Created by liyoubing on 16/5/9.
//  Copyright © 2016年 liyoubing. All rights reserved.
//

#import "JokeCell.h"
#import "InformationModel.h"


@implementation JokeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //创建子视图
        [self _initSubView];
        
    }
    
    return self;
}

- (void)_initSubView {

    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.contentView addSubview:_titleLabel];
    
    _remarkLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _remarkLabel.textColor = [UIColor darkGrayColor];
    _remarkLabel.font = [UIFont systemFontOfSize:15];
    _remarkLabel.numberOfLines = 0;
    [self.contentView addSubview:_remarkLabel];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _timeLabel.textColor = [UIColor darkGrayColor];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_timeLabel];
    
    _shareImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _shareImgView.image = [UIImage imageNamed:@"share@2x.png"];
    [self.contentView addSubview:_shareImgView];
    
}


- (void)layoutSubviews {

    [super layoutSubviews];
    
    _titleLabel.frame = CGRectMake(10, 5, KScreenWidth-20, 30);
    _titleLabel.text = _model.title;
    
    _remarkLabel.frame = CGRectMake(10, _titleLabel.bottom+5, KScreenWidth-20, [JokeCell getRemarkHeight:_model.remark]);
    _remarkLabel.text = _model.remark;
    
    _timeLabel.frame = CGRectMake(10, _remarkLabel.bottom+5, 200, 20);
    _timeLabel.text = _model.date;
    
    _shareImgView.frame = CGRectMake(KScreenWidth-10-27/2.0, _timeLabel.top, 27/2.0, 23/2.0);
}


+ (CGFloat)getRemarkHeight:(NSString *)content {

    CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(KScreenWidth-20, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    
    return size.height;
    
}


@end
