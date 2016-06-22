//
//  ImageListController.m
//  CXNews
//
//  Created by liyoubing on 16/5/10.
//  Copyright © 2016年 liyoubing. All rights reserved.
//

#import "ImageListController.h"
#import "ImageViewCell.h"

@interface ImageListController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@end

@implementation ImageListController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = [NSString stringWithFormat:@"图片(%ld/%ld)",_selectIndex+1,_imgArray.count];
    
    //创建子视图
    [self _initSubView];
    
    //添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tap];
    
}

//隐藏导航栏
- (void)tapAction {

    //如果导航栏显示则隐藏  隐藏则显示
    BOOL isHidden = self.navigationController.navigationBarHidden;
    [self.navigationController setNavigationBarHidden:!isHidden animated:YES];
    
}

//创建子视图
- (void)_initSubView {

    UICollectionViewFlowLayout *flowLayOut = [[UICollectionViewFlowLayout alloc] init];
    flowLayOut.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayOut.itemSize = CGSizeMake(KScreenWidth+10, KScreenHeight-64);
    flowLayOut.minimumInteritemSpacing = 0;
    flowLayOut.minimumLineSpacing = 0;
    
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth+10, KScreenHeight) collectionViewLayout:flowLayOut];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.pagingEnabled = YES;
    [self.view addSubview:collectionView];
    
    
    //注册单元格
    [collectionView registerClass:[ImageViewCell class] forCellWithReuseIdentifier:@"imgCell"];
    
    //滚动到指定的位置
    [collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_selectIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return _imgArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    ImageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imgCell" forIndexPath:indexPath];
    
    cell.imgURL = _imgArray[indexPath.row];
    
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    //修改标题
    int page = scrollView.contentOffset.x/(KScreenWidth+10);
    self.title = [NSString stringWithFormat:@"图片(%d/%ld)",page+1,_imgArray.count];
}

//单元格结束显示的时候调用的代理方法
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {

    NSLog(@"%ld",indexPath.item);
}


@end
