//
//  MyTableView.h
//  CXNews
//
//  Created by liyoubing on 16/5/6.
//  Copyright © 2016年 liyoubing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserModel;

@interface MyTableView : UITableView

@property(nonatomic, strong)UserModel *model;

@end
