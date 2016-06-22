//
//  UserModel.m
//  CXNews
//
//  Created by liyoubing on 16/5/4.
//  Copyright © 2016年 liyoubing. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

- (id)initWithJSONDic:(NSDictionary *)dic {

    self = [super initWithJSONDic:dic];
    if (self) {
        self.userInfo = dic;
    }
    
    return self;
}


@end
