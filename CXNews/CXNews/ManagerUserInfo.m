//
//  ManagerUserInfo.m
//  CXNews
//
//  Created by liyoubing on 16/5/4.
//  Copyright © 2016年 liyoubing. All rights reserved.
//

#import "ManagerUserInfo.h"
#import "UserModel.h"

//存数据   读数据
@implementation ManagerUserInfo

//单例
+ (instancetype)shareInstance {

    static ManagerUserInfo *userInfo = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        userInfo = [[ManagerUserInfo alloc] init];
    });
    
    return userInfo;
}

//读数据
- (UserModel *)model {

    if (_model == nil) {
        NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:LoginMessage];
        
        if (userInfo != nil) {
            _model = [[UserModel alloc] initWithJSONDic:userInfo];
        }
    }
    
    return _model;
}

//写数据
- (void)setModel:(UserModel *)model {

    //注销
    if (model == nil) {
        
        _model = model;
        
        //清除本地数据
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:LoginMessage];
        //同步数据
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }else if (_model != model) {
        _model = model;
        
        //将数据写入本地
        [[NSUserDefaults standardUserDefaults] setObject:_model.userInfo forKey:LoginMessage];
        //同步数据
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}




@end
