//
//  CXTextField.m
//  CXNews
//
//  Created by liyoubing on 16/4/29.
//  Copyright © 2016年 liyoubing. All rights reserved.
//

#import "CXTextField.h"

@implementation CXTextField

//控制编辑显示的文字的位置
- (CGRect)textRectForBounds:(CGRect)bounds {

    return CGRectMake(15, 0, bounds.size.width-15, bounds.size.height);
}

//控制placeHolder显示的位置
- (CGRect)placeholderRectForBounds:(CGRect)bounds {

    return CGRectMake(15, 0, bounds.size.width-15, bounds.size.height);
}

//控制编辑文本显示的位置
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectMake(15, 0, bounds.size.width-15, bounds.size.height);
}

@end
