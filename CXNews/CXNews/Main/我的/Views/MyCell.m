//
//  MyCell.m
//  CXNews
//
//  Created by liyoubing on 16/5/6.
//  Copyright © 2016年 liyoubing. All rights reserved.
//

#import "MyCell.h"

@implementation MyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        //设置辅助图标
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //创建子视图
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 44)];
        leftView.backgroundColor = DefaultBgColor;
        [self.contentView addSubview:leftView];
        
        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake((KScreenWidth-10), 0, 10, 44)];
        rightView.backgroundColor = DefaultBgColor;
        [self.contentView addSubview:rightView];
        
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 5)];
        topView.backgroundColor = DefaultBgColor;
        [self.contentView addSubview:topView];
    }
    
    return self;
}

- (void)setContent:(NSString *)content {

    _content = content;
    
    self.textLabel.text = _content;
    
}


@end
