
//
//  IamgeViewCell.m
//  CXNews
//
//  Created by liyoubing on 16/5/10.
//  Copyright © 2016年 liyoubing. All rights reserved.
//

#import "ImageViewCell.h"
#import "UIImageView+WebCache.h"

@implementation ImageViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, self.height)];
        _scrollView.minimumZoomScale = 1;
        _scrollView.maximumZoomScale = 2;
        _scrollView.delegate = self;
        [self.contentView addSubview:_scrollView];
        
        //创建子视图
        _imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        [_scrollView addSubview:_imgView];
    }
    return self;
}

- (void)setImgURL:(NSString *)imgURL {

    _imgURL = imgURL;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews {

    [super layoutSubviews];

    _scrollView.zoomScale = 1;
    _imgView.frame = CGRectMake(0, 0, KScreenWidth, self.height);
    
    [_imgView sd_setImageWithURL:[NSURL URLWithString:_imgURL]];
}

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imgView;
}

@end
