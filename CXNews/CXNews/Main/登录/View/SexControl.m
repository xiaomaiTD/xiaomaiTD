//
//  SexControl.m
//  CXNews
//
//  Created by liyoubing on 16/5/3.
//  Copyright © 2016年 liyoubing. All rights reserved.
//

#import "SexControl.h"

@interface SexControl() {
    NSArray *_bgImgViewArray;
    
}

@end

@implementation SexControl


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //设置背景
        _bgImgViewArray = @[@"register_sex_b@2x.png",
                            @"register_sex_g@2x.png",
                            @"register_sex_n@2x.png"
                            ];
        
        //设置默认选中的小标
        self.selectIndex = 2;
//        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:_bgImgViewArray[_selectIndex]]];
        
    }
    return self;
}

//捕捉点击事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    //（1）获取点击的手指
    UITouch *touch = [touches anyObject];
    
    //（2）获取点击的位置
    CGPoint location = [touch locationInView:self];
    CGFloat offsetX = location.x;
    
    //（3）判断点击的方位
    if (offsetX <= self.width/3.0) {
        self.selectIndex = 0;
    }else if(offsetX >= self.width/3.0*2) {
        self.selectIndex = 2;
    }else {
        self.selectIndex = 1;
    }
    
    //传递事件
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setSelectIndex:(NSInteger)selectIndex {

    if (_selectIndex != selectIndex) {
        
        _selectIndex = selectIndex;
        
        //修改背景
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:_bgImgViewArray[_selectIndex]]];
    }
}






@end
