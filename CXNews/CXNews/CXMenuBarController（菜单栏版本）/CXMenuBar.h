//
//  CXMenuBar.h
//  CXWL
//
//  Created by 朱思明 on 15/11/20.
//  Copyright © 2015年 北京畅想未来科技有限公司 网址：http://cxwlbj.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CXMenuBarController;

@interface CXMenuBar : UIControl
{
    UIScrollView *_scrollView;
    UIView *_selectedView;
    NSInteger _selectedIndex;
    // 滑动视图的左右遮盖视图
    UIImageView *_maskLeftImageView;
    UIImageView *_maskRightImageView;
}

/*
 *  所在的菜单栏控制器
 */
@property (nonatomic, weak)  CXMenuBarController *menuBarController;

/*
 *  所有控制器标题的数组
 */
@property (nonatomic, strong) NSArray *titles;

/*
 *  菜单栏控件选中按钮索引位置
 */
@property (nonatomic, assign) NSInteger selectedIndex;

/*
 *  菜单栏控件按钮文本颜色
 */
@property (nonatomic, strong) UIColor *titleColor;

/*
 *  菜单栏控件选中后按钮文本颜色
 */
@property (nonatomic, strong) UIColor *selectedTitleColor;

/*
 *  菜单栏控件选中后按钮文本颜色
 */
@property (nonatomic, strong) UIColor *selectedViewBackgroudColor;

/*
 *  菜单栏控件选中后按钮文本缩放比例
 */
@property (nonatomic, assign) CGFloat selectedScale;



@end
