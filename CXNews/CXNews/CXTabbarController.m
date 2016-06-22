//
//  CXTabbarController.m
//  CXNews
//
//  Created by liyoubing on 16/4/26.
//  Copyright © 2016年 liyoubing. All rights reserved.
//

#import "CXTabbarController.h"
#import "InformationViewController.h"
#import "PersonalViewController.h"
#import "CollectionViewController.h"
#import "SettingViewController.h"
#import "CXNewNavgationController.h"

@interface CXTabbarController ()

@end

@implementation CXTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];

    //创建三级控制器
    [self _initCtrls];
    
    //设置标签栏
    [self _initTabbar];
}

//创建三级控制器
- (void)_initCtrls {

    //创建视图控制器
    InformationViewController *inforamtionCtrl = [[InformationViewController alloc] init];
    PersonalViewController *personalCtrl = [[PersonalViewController alloc] init];
    CollectionViewController *collectionCtrl = [[CollectionViewController alloc] init];
    SettingViewController *settingCtrl = [[SettingViewController alloc] init];
    
    NSArray *viewCtrlArray = @[inforamtionCtrl,personalCtrl,collectionCtrl,settingCtrl];
    
    NSMutableArray *navArray = [[NSMutableArray alloc] init];
    for (UIViewController *viewCtrl in viewCtrlArray) {
        //创建导航控制器
        CXNewNavgationController *navCtrl = [[CXNewNavgationController alloc] initWithRootViewController:viewCtrl];
        [navArray addObject:navCtrl];
    }
    
    //设置标签控制器的子控制器
    self.viewControllers = navArray;
}

//设置标签栏
- (void)_initTabbar {

    //（1）获取子控制器
    
    NSArray *titleArray = @[
                            @"咨询",
                            @"我的",
                            @"收藏",
                            @"设置"
                            ];
    NSArray *imgArray = @[
                          @"tabbar_Information@2x.png",
                          @"tabbar_my@2x.png",
                          @"tabbar_cellection@2x.png",
                          @"tabbar_set@2x.png"
                          ];
    
    NSArray *selectImgArray = @[
                          @"tabbar_Information_selected@2x.png",
                          @"tabbar_my_selected@2x.png",
                          @"tabbar_cellection_selected@2x.png",
                          @"tabbar_set_selected@2x.png"
                          ];
    
    for (int i=0; i<self.viewControllers.count; i++) {
        //导航控制器
        CXNewNavgationController *navCtrl = self.viewControllers[i];
        //设置标题
        navCtrl.tabBarItem.title = titleArray[i];
        //设置图片
        navCtrl.tabBarItem.image = [UIImage imageNamed:imgArray[i]];
        //设置选中显示的图片
        navCtrl.tabBarItem.selectedImage = [UIImage imageNamed:selectImgArray[i]];
    }
    
    //设置选中后的标题和图片颜色
    // 29 43  137  1
    self.tabBar.selectedImageTintColor = [UIColor colorWithRed:29/255.0 green:43/255.0 blue:137/255.0 alpha:1];
    
    
    
}



@end
