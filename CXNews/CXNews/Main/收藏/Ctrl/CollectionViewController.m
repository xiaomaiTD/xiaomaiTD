//
//  CollectionViewController.m
//  CXNews
//
//  Created by liyoubing on 16/4/26.
//  Copyright © 2016年 liyoubing. All rights reserved.
//

#import "CollectionViewController.h"
#import "UserCollectionViewController.h"
#import "UserFollowViewController.h"
#import "CXSegmentCtontrol.h"

@interface CollectionViewController () {

    CXSegmentCtontrol *_cxCtrl;
}

@end

@implementation CollectionViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"收藏";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //创建子控制器
    UserCollectionViewController *collectionViewCtrl = [[UserCollectionViewController alloc] init];
    UserFollowViewController *userFollowerCtrl = [[UserFollowViewController alloc] init];
    
    self.viewControllers = @[collectionViewCtrl,userFollowerCtrl];
    
    //关闭滚动
    self.scrollView.scrollEnabled = NO;
    
    //隐藏菜单栏
    [self setMenuBarHidden:YES];
    
    [self _initNavTitleView];
}

//设置标题视图
- (void)_initNavTitleView {

    NSArray *array = @[@"本地收藏",@"用户关注"];
    
    _cxCtrl = [[CXSegmentCtontrol alloc] initWithFrame:CGRectMake(0, 0, 170, 100) withTitles:array];
    
    //添加点击事件
    [_cxCtrl addTarget:self action:@selector(changeAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.titleView = _cxCtrl;
    
}

- (void)changeAction:(CXSegmentCtontrol *)sg {

    self.selectedIndex = sg.selectIndex;
}

//复写父类的方法
- (void)setSelectedIndex:(NSInteger)selectedIndex {

    [super setSelectedIndex:selectedIndex];
    
    _cxCtrl.selectIndex = selectedIndex;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
