//
//  BaseViewController.m
//  CXNews
//
//  Created by liyoubing on 16/4/26.
//  Copyright © 2016年 liyoubing. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = DefaultBgColor;
    
    //自定义返回按钮
    //只有在二级界面以上才有
    if (self.navigationController.viewControllers.count > 1 || _isModal) {
        [self _initBackButton];
    }
    
}

//自定义返回按钮
- (void)_initBackButton {
    
    //隐藏返回按钮
    self.navigationItem.hidesBackButton = YES;
    
    //创建按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 19, 36);
    [button setImage:[UIImage imageNamed:@"back_btn@2x.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
}

//返回事件
- (void)backAction {
    if (_isModal) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}



//设置状态栏的样式
- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}


@end
