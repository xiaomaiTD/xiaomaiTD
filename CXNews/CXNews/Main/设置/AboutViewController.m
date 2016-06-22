//
//  AboutViewController.m
//  CXNews
//
//  Created by liyoubing on 16/4/27.
//  Copyright © 2016年 liyoubing. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        //隐藏标签栏
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //创建子视图
    [self _initSubView];
    
}

//创建子视图
- (void)_initSubView {

    UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imgView.image = [UIImage imageNamed:@"logo_background@2x.png"];
    //设置imgView的填充方式
    imgView.contentMode = UIViewContentModeCenter;
    [self.view addSubview:imgView];
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, KScreenWidth-30, 0)];
    contentLabel.numberOfLines = 0;
    contentLabel.textColor = [UIColor darkGrayColor];
    [self.view addSubview:contentLabel];
    contentLabel.text = _content;
    [contentLabel sizeToFit];
}



@end
