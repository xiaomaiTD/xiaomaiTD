//
//  ImageListController.h
//  CXNews
//
//  Created by liyoubing on 16/5/10.
//  Copyright © 2016年 liyoubing. All rights reserved.
//

#import "BaseViewController.h"

@interface ImageListController : BaseViewController

@property(nonatomic, assign)NSInteger selectIndex;  //选中的下标
@property(nonatomic, strong)NSArray *imgArray;      //图片的数据

@end
