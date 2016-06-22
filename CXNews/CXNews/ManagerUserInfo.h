//
//  ManagerUserInfo.h
//  CXNews
//
//  Created by liyoubing on 16/5/4.
//  Copyright © 2016年 liyoubing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
//@class UserModel;

//动态数据  转换成静态数据
@interface ManagerUserInfo : NSObject {

    UserModel *_model;
}

@property(nonatomic, strong)UserModel *model;

//单例
+ (instancetype)shareInstance;

@end
