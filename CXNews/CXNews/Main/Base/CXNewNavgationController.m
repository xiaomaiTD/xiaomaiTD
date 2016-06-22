//
//  CXNewNavgationController.m
//  CXNews
//
//  Created by liyoubing on 16/4/26.
//  Copyright © 2016年 liyoubing. All rights reserved.
//

#import "CXNewNavgationController.h"

@interface CXNewNavgationController ()

@end

@implementation CXNewNavgationController

- (void)viewDidLoad {
    [super viewDidLoad];

    //设置导航栏不穿透
    self.navigationBar.translucent = NO;
    
    //设置标题的颜色
    self.navigationBar.titleTextAttributes = @{
                                               NSForegroundColorAttributeName:[UIColor whiteColor]
                                               };
    //设置背景
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg@2x.png"] forBarMetrics:UIBarMetricsDefault];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//设置状态栏的样式
- (UIStatusBarStyle)preferredStatusBarStyle {

    //获取当前显示的控制器
    UIViewController *viewCtrl = self.visibleViewController;
    return viewCtrl.preferredStatusBarStyle;   
}

@end
