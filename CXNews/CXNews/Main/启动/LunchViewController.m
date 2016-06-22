//
//  LunchViewController.m
//  CXNews
//
//  Created by liyoubing on 16/4/26.
//  Copyright © 2016年 liyoubing. All rights reserved.
//

#import "LunchViewController.h"
#import "CXTabbarController.h"

@interface LunchViewController ()<UIScrollViewDelegate>

@end

@implementation LunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //创建子视图
    [self _initSubView];
    
    
}

//创建子视图
- (void)_initSubView {

    //创建滚动视图
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.contentSize = CGSizeMake(KScreenWidth*3, KScreenHeight);
    //设置分页效果
    scrollView.pagingEnabled = YES;
    //设置代理
    scrollView.delegate = self;
    //隐藏滚动条
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    NSArray *imgNameArray = @[
                              @"guide_page_01",
                              @"guide_page_02",
                              @"guide_page_03",
                              ];
    //添加子视图
    for (int i=0; i<3; i++) {
        
        //获取图片
        UIImage *img = [self getImgWithImgName:imgNameArray[i]];
        UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
        imgView.frame = CGRectMake(i*KScreenWidth, 0, KScreenWidth, KScreenHeight);
        [scrollView addSubview:imgView];
    }
    
    
    
}

//根据不同的屏幕，获取相应的图片
- (UIImage *)getImgWithImgName:(NSString *)imgName {

    //guide_page_01
    //320  480  3.5
    //320  568  4.0
    //375  667  4.7
    // 5.5
    CGFloat size = 0;
    if (KScreenWidth == 320) {
        if (KScreenHeight == 480) {
            size = 3.5;
        }else {
            size = 4.0;
        }
    }else if (KScreenWidth == 375) {
        size = 4.7;
    }else {
        size = 5.5;
    }
    
    //拼接图片的名字
    NSString *imageName = [NSString stringWithFormat:@"%@_%.1f.jpg",imgName,size];
    
    return [UIImage imageNamed:imageName];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

//    scrollView.contentOffset.x = 2*KScreenWidth
//    scrollView.contentSize.width = 3*KScreenWidth;
//    scrollView.frame.size.width = KScreenWidth

//scrollView.contentOffset.x+scrollView.frame.size.width
    
//    =scrollView.contentSize.width
    
    CGFloat subValue = (scrollView.contentOffset.x+scrollView.frame.size.width)-(scrollView.contentSize.width);
    NSLog(@"subVlaue:%f",subValue);
    
    if ((scrollView.contentOffset.x+scrollView.frame.size.width)-(scrollView.contentSize.width) > 0) {
            //切换根控制器
            //（1）获取主窗口
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            CXTabbarController *tabbarCtrl = [[CXTabbarController alloc] init];
            window.rootViewController = tabbarCtrl;
        
            //添加动画
            tabbarCtrl.view.transform = CGAffineTransformMakeScale(0.5, 0.5);
            [UIView animateWithDuration:1 animations:^{
                tabbarCtrl.view.transform = CGAffineTransformIdentity;
            }];
    }

}

//隐藏状态栏
- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
