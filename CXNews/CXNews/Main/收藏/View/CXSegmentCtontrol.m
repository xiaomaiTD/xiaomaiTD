//
//  CXSegmentCtontrol.m
//  CXNews
//
//  Created by liyoubing on 16/5/11.
//  Copyright © 2016年 liyoubing. All rights reserved.
//

#import "CXSegmentCtontrol.h"

@implementation CXSegmentCtontrol


- (id)initWithFrame:(CGRect)frame
         withTitles:(NSArray *)titleArray {

    self = [super initWithFrame:frame];
    
    if (self) {
        
        _titleArray = titleArray;
        
        //高度固定的
        self.frame = CGRectMake(self.left, self.top, self.width, 23);
        //创建子视图
//        (1)创建背景视图
        UIImage *bgImg = [UIImage imageNamed:@"switch_frame.png"];
        //设置拉伸点
        bgImg = [bgImg stretchableImageWithLeftCapWidth:80 topCapHeight:0];
        UIImageView *bgImgView = [[UIImageView alloc] initWithImage:bgImg];
        bgImgView.frame = self.bounds;
        [self addSubview:bgImgView];
        
        //(2)创建选中样式图标
        _selectImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width/titleArray.count, self.height)];
        UIImage *selectImg = [UIImage imageNamed:@"segment_select.png"];
        //设置拉伸点
        selectImg = [selectImg stretchableImageWithLeftCapWidth:40 topCapHeight:0];
        _selectImgView.image = selectImg;
        [self addSubview:_selectImgView];
        
        //（3）添加标题
        CGFloat width = self.width/titleArray.count;
        for (int i=0; i<titleArray.count; i++) {
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(width*i, 0, width, self.height)];
            titleLabel.tag = 100+i;
            titleLabel.text = titleArray[i];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.textColor = [UIColor whiteColor];
            titleLabel.font = [UIFont systemFontOfSize:14];
            titleLabel.highlightedTextColor = DefaultColor;
            [self addSubview:titleLabel];
            
            //设置默认选中
            if (i == 0) {
                titleLabel.highlighted = YES;
            }
            
            //设置选中的下标
            _selectIndex = 0;
        }        
    }
    
    return self;
    
}

//获取响应时间
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    //（1）获取点击的位置
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    CGFloat width = self.width/_titleArray.count;
    
    //（2）获取点击的下标
    NSInteger selectIndex = point.x/width;
    
    //（3）修改选中的下标
    if (_selectIndex != selectIndex) {
        self.selectIndex = selectIndex;
    }
    
    //将事件发送出去
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelectIndex:(NSInteger)selectIndex {

    if (_selectIndex != selectIndex) {
        //修改label显示的字体颜色
        //（1）以前的选中改为正常 _selectIndex 0
        UILabel *lastLabel = (UILabel *)[self viewWithTag:100+_selectIndex];
        lastLabel.highlighted = NO;
        
        //（2）当前需要选中的改为highlighted selectIndex
        UILabel *currentLabel = (UILabel *)[self viewWithTag:100+selectIndex];
        currentLabel.highlighted = YES;
        
        //修改选中图片显示的位置
        [UIView animateWithDuration:0.5 animations:^{
            _selectImgView.center = currentLabel.center;
        }];
        
        _selectIndex = selectIndex;
    }
    
}


@end
