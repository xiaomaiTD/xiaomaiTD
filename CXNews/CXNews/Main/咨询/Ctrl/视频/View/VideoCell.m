//
//  VideoCell.m
//  CXNews
//
//  Created by liyoubing on 16/5/9.
//  Copyright © 2016年 liyoubing. All rights reserved.
//

#import "VideoCell.h"
#import "InformationModel.h"
#import "UIImageView+WebCache.h"
#import "CXTextField.h"

@implementation VideoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initSubView];
    }
    
    return self;
    
}

- (void)_initSubView {

    _imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_imgView];
    
    _titleLabel = [[CXTextField alloc] initWithFrame:CGRectZero];
    _titleLabel.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
    _titleLabel.enabled = NO;
    _titleLabel.textColor = [UIColor whiteColor];
    [_imgView addSubview:_titleLabel];
    
    
    _playImg = [[UIImageView alloc] initWithFrame:CGRectZero];
    _playImg.image = [UIImage imageNamed:@"Play@2x.png"];
    [_imgView addSubview:_playImg];
    
    _countLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _countLabel.textColor = [UIColor grayColor];
    _countLabel.font = [UIFont systemFontOfSize:11];
    [self.contentView addSubview:_countLabel];
    
    _iconImg = [[UIImageView alloc] initWithFrame:CGRectZero];
    _iconImg.image = [UIImage imageNamed:@"Play_x@2x.png"];
    [self.contentView addSubview:_iconImg];
    
    _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_shareButton setImage:[UIImage imageNamed:@"share@2x.png"] forState:UIControlStateNormal];
    [_shareButton addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_shareButton];
    
}

- (void)layoutSubviews {

    [super layoutSubviews];
    
    _titleLabel.frame = CGRectMake(0, 0, KScreenWidth, 30);
    _titleLabel.text = _model.title;
    
    _imgView.frame = CGRectMake(0, 0, KScreenWidth, 220-30);
    NSString *imgURL = [NSString stringWithFormat:@"http:/123.57.246.163:8044%@",_model.img];
    [_imgView sd_setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[UIImage imageNamed:@"g_01.jpg"]];
    
    _playImg.frame = CGRectMake((KScreenWidth-49)/2.0, (_imgView.height-49)/2.0, 49, 49);
    
    _countLabel.frame = CGRectMake(10, _imgView.bottom+5, 20, 20);
    _countLabel.text = [NSString stringWithFormat:@"%@次",_model.click];
    
    _iconImg.frame = CGRectMake(_countLabel.right+5, _countLabel.top, 19, 19);
    
    _shareButton.frame = CGRectMake((KScreenWidth-10-27), _countLabel.top, 27, 23);
    
}

- (void)shareAction {

    
    
}

@end
