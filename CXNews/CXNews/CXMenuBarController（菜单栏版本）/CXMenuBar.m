//
//  CXMenuBar.m
//  CXWL
//
//  Created by 朱思明 on 15/11/20.
//  Copyright © 2015年 北京畅想未来科技有限公司 网址：http://cxwlbj.com. All rights reserved.
//

#import "CXMenuBar.h"
#import "CXMenuBarController.h"

#define CXMenuBarHeight 30
#define CXMenuBarTitleSpacing 30
#define CXMenuInitTag 10000

// 获取CXMenuBar.bundle下的图片
#define CXMenuBarBundleName @"CXMenuBar.bundle"
#define CXMenuBarImagePathWithImageName(imageName) [CXMenuBarBundleName stringByAppendingPathComponent:imageName]
#define CXMenuBarImageWithImageName(imageName) [UIImage imageNamed:CXMenuBarImagePathWithImageName(imageName)]

@implementation CXMenuBar

- (void)dealloc
{
    // 01 移除之前菜单栏控制器对象的观察者模式
    [_menuBarController removeObserver:self forKeyPath:@"scrollView.contentOfSet.x" context:nil];
    [_menuBarController removeObserver:self forKeyPath:@"viewControllers" context:nil];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 设置初始化值
        _titleColor = [UIColor grayColor];
        _selectedTitleColor = [UIColor colorWithRed:31/255.0 green:38/255.0 blue:182/255.0 alpha:1.0];
        _selectedScale = 1.1;
        _selectedViewBackgroudColor = [UIColor colorWithRed:31/255.0 green:38/255.0 blue:182/255.0 alpha:1.0];
        
        // 1.设置自身的大小和位置
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, CXMenuBarHeight);
        // 2.创建瀑布流视图
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width , self.frame.size.height)];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:_scrollView];
        // 创建滑动视图中的文本选中视图
        _selectedView = [[UIView alloc] initWithFrame:CGRectZero];
        _selectedView.backgroundColor = _selectedViewBackgroudColor;
        // 3.创建滑动视图的遮盖视图
        // 左侧视图
        _maskLeftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, CXMenuBarHeight)];
        _maskLeftImageView.image = [CXMenuBarImageWithImageName(@"menuBar_l.png") stretchableImageWithLeftCapWidth:0 topCapHeight:10];
        [self addSubview:_maskLeftImageView];
        // 右侧视图
        _maskRightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_scrollView.frame.size.width - 20, 0, 20, CXMenuBarHeight)];
        _maskRightImageView.image = [CXMenuBarImageWithImageName(@"menuBar_r.png") stretchableImageWithLeftCapWidth:0 topCapHeight:10];
        [self addSubview:_maskRightImageView];
        
    }
    return self;
}

- (void)setMenuBarController:(CXMenuBarController *)menuBarController
{
    if (_menuBarController != menuBarController) {
        
        // 01 移除之前菜单栏控制器对象的观察者模式
        [_menuBarController removeObserver:self forKeyPath:@"scrollView.contentOffset" context:nil];
        [_menuBarController removeObserver:self forKeyPath:@"viewControllers" context:nil];
        
        // 02 保存当前菜单栏控制器对象
        _menuBarController = menuBarController;
         
        // 03 添加观察者模式
        [_menuBarController addObserver:self forKeyPath:@"scrollView.contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        [_menuBarController addObserver:self forKeyPath:@"viewControllers" options:NSKeyValueObservingOptionNew context:nil];
        
    }
}

#pragma mark - 设置选中
- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    if (_selectedIndex != selectedIndex) {
        // 设置选中动画
        [UIView animateWithDuration:.22 animations:^{
            // 01 获取上一次选中的动画视图
            UILabel *beforeLabel = [_scrollView viewWithTag:CXMenuInitTag + _selectedIndex];
            beforeLabel.textColor = _titleColor;
            beforeLabel.transform = CGAffineTransformIdentity;
            
            // 02 设置当前选中视图动画效果
            _selectedIndex = selectedIndex;
            UILabel *selectedLabel = [_scrollView viewWithTag:CXMenuInitTag + _selectedIndex];
            selectedLabel.textColor = _selectedTitleColor;
            selectedLabel.transform = CGAffineTransformMakeScale(_selectedScale, _selectedScale);
            
            // 03 设置选中背景视图位置
            // 从新设置位置和大小
            _selectedView.frame = CGRectMake(selectedLabel.frame.origin.x, CXMenuBarHeight - 2, selectedLabel.frame.size.width, 2);
        } completion:^(BOOL finished) {
            // 让滑动视图选中内容显示在可视区域
            // 1.获取当前选中视图
            UILabel *selectedLabel = [_scrollView viewWithTag:CXMenuInitTag + _selectedIndex];
            // 2.视图显示在中心时的偏移量
            float x = selectedLabel.center.x - _scrollView.frame.size.width / 2.0;
            // 3.偏移量最小为0
            x = MAX(0, x);
            // 4.偏移量最大为滑动视图的最大偏移量
            x = MIN(_scrollView.contentSize.width - _scrollView.frame.size.width, x);
            // 5.让视图滑动到中心位置
            [_scrollView setContentOffset:CGPointMake(x, 0) animated:YES];
        }];
    }
}

#pragma mark - 刷新滑动视图的子视图
- (void)scrollViewReloadData
{
    // 1.移除滑动视图所有的子视图
    for (UIView *subView in _scrollView.subviews) {
        // 从父视图上移除当前子视图
        [subView removeFromSuperview];
    }
    
    // 2.根据文本标题创建滑动视图的内容
    for (int i = 0; i < _titles.count; i++) {
        // 01 创建文本视图
        UILabel *menuCell = [[UILabel alloc] initWithFrame:CGRectZero];
        menuCell.textColor = _titleColor;
        menuCell.font = [UIFont systemFontOfSize:16];
        menuCell.backgroundColor = [UIColor clearColor];
        menuCell.tag = CXMenuInitTag + i;
        // 添加点击事件
        menuCell.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [menuCell addGestureRecognizer:tap];
        // 02 设置文本内容
        menuCell.text = _titles[i];
        // 设置视图文本内容自适应
        [menuCell sizeToFit];
        // 03 获取前一个文本视图
        UILabel *beforeMenuCell = [_scrollView.subviews lastObject];
        CGFloat beforeMenuCell_right = beforeMenuCell.frame.origin.x + beforeMenuCell.frame.size.width;
        // 04 设置当前文本视图的大小和位置
        menuCell.frame = CGRectMake(beforeMenuCell_right + CXMenuBarTitleSpacing, 0, menuCell.frame.size.width, CXMenuBarHeight);
        [_scrollView addSubview:menuCell];
        // 05 设置滑动视图内容视图的大小
        if (i == _titles.count - 1) {
            // 当前循环创建了最后一个文本视图
            // 获取当文本视图右边的位置
            CGFloat menuCell_right = menuCell.frame.origin.x + menuCell.frame.size.width;
            float contentSize_w = MAX(_scrollView.frame.size.width + 1, menuCell_right + CXMenuBarTitleSpacing);
            _scrollView.contentSize = CGSizeMake(contentSize_w, _scrollView.frame.size.height);
        }
        // 06 设置选中视图位置和大小
        if (i == _selectedIndex) {
            // 01 设置选中视图的大小和位置
            _selectedView.frame = CGRectMake(menuCell.frame.origin.x, CXMenuBarHeight - 2, menuCell.frame.size.width, 2);
            [_scrollView addSubview:_selectedView];
            // 02 设置选中文本的颜色
            menuCell.textColor = _selectedTitleColor;
            // 03 设置文本视图放大
            menuCell.transform = CGAffineTransformMakeScale(_selectedScale, _selectedScale);
        }
    }
}

#pragma mark - kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    // 获取监听对象的值
    id value = change[@"new"];
    if ([keyPath isEqualToString:@"scrollView.contentOffset"]) {
        // 滑动视图放生了改变
        // 01 获取滑动视图的偏移量
        CGFloat scrollView_contentOfset_x = [value CGPointValue].x;
        // 02 获取两个做渐变的视图索引位置
        NSInteger startIndex = _menuBarController.selectedIndex;
        NSInteger endIndex = startIndex;
        if (scrollView_contentOfset_x < startIndex * _menuBarController.scrollView.frame.size.width) {
            endIndex = startIndex - 1;
        } else if (scrollView_contentOfset_x > startIndex * _menuBarController.scrollView.frame.size.width) {
            endIndex = startIndex + 1;
        } else {
            endIndex = startIndex;
        }
        
        if (startIndex != endIndex) {
            // 03 获取开始文本和结束文本的视图
            UILabel *startLabel = [_scrollView viewWithTag:CXMenuInitTag + startIndex];
            UILabel *endLabel = [_scrollView viewWithTag:CXMenuInitTag + endIndex];
            // 04 设置动画渐变效果
            CGFloat anmationScale = ABS(scrollView_contentOfset_x - startIndex * _menuBarController.scrollView.frame.size.width) / _menuBarController.scrollView.frame.size.width;
//            NSLog(@"------%f",anmationScale);
            // 开始动画文本设置
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                UIColor *startColor = [self getColorWithSize:1 - anmationScale];
                dispatch_async(dispatch_get_main_queue(), ^{
                    startLabel.textColor = startColor;
                });
            });
//            startLabel.textColor = [self getColorWithSize:1 - anmationScale];
            startLabel.transform = CGAffineTransformMakeScale(1 + (self.selectedScale - 1) * (1 - anmationScale), 1 + (self.selectedScale - 1) * (1 - anmationScale));
            // 结束动画文本设置
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                UIColor *endColor = [self getColorWithSize:anmationScale];
                dispatch_async(dispatch_get_main_queue(), ^{
                    endLabel.textColor = endColor;
                });
            });
//            endLabel.textColor = [self getColorWithSize:anmationScale];
            endLabel.transform = CGAffineTransformMakeScale(1 + (self.selectedScale - 1) * anmationScale, 1 + (self.selectedScale - 1) * anmationScale);
            // 05 设置滑动条的位置和大小
            CGFloat width = startLabel.frame.size.width + (endLabel.frame.size.width - startLabel.frame.size.width) * anmationScale;
            CGFloat x = startLabel.frame.origin.x + (endLabel.frame.origin.x - startLabel.frame.origin.x) * anmationScale;
            _selectedView.frame = CGRectMake(x, CXMenuBarHeight - 2, width, 2);
        }
        
    } else if ([keyPath isEqualToString:@"viewControllers"]) {
        // 控制器个数发生了改变
        // 01 创建当前控制器对应的标题数组
        NSMutableArray *titles = [NSMutableArray array];
        // 02 遍历所有的子视图控制器并获取标题数组
        for (UIViewController *viewController in (NSArray *)value) {
            if (viewController.title != nil) {
                [titles addObject:viewController.title];
            } else {
                [titles addObject:NSStringFromClass([viewController class])];
            }
        }
        _titles = titles;
        // 03 刷新视图
        [self scrollViewReloadData];
    }
//    NSLog(@"value:%@",value);
}

#pragma mark - TAP ACTION
- (void)tapAction:(UITapGestureRecognizer *)tap
{
    if ([tap.view isKindOfClass:[UILabel class]]) {
        // 获取当前点击视图的位置
        NSInteger selectedIndex = tap.view.tag - CXMenuInitTag;
        self.selectedIndex = selectedIndex;
        // 设置事件
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

#pragma mark - 获取渐变色
- (UIColor *)getColorWithSize:(CGFloat)size
{
    CIFilter *ciFilter = [CIFilter filterWithName:@"CILinearGradient"];
    CIVector *vector0 = [CIVector vectorWithX:0 Y:0];
    CIVector *vector1 = [CIVector vectorWithX:0 Y:10];
    [ciFilter setValue:vector0 forKey:@"inputPoint0"];
    [ciFilter setValue:vector1 forKey:@"inputPoint1"];
    [ciFilter setValue:[CIColor colorWithCGColor:_titleColor.CGColor] forKey:@"inputColor0"];
    [ciFilter setValue:[CIColor colorWithCGColor:_selectedTitleColor.CGColor] forKey:@"inputColor1"];
    
    CIImage *ciImage = ciFilter.outputImage;
    CIContext *con = [CIContext contextWithOptions:nil];
    CGImageRef resultCGImage = [con createCGImage:ciImage
                                         fromRect:CGRectMake(0, size*10, 1, 1)];
    UIImage *resultUIImage = [UIImage imageWithCGImage:resultCGImage];
    CGImageRelease(resultCGImage);
    
    return [UIColor colorWithPatternImage:resultUIImage];
}

@end
