//
//  InformationModel.m
//  CXNews
//
//  Created by liyoubing on 16/5/9.
//  Copyright © 2016年 liyoubing. All rights reserved.
//

#import "InformationModel.h"

@implementation InformationModel

- (id)initWithJSONDic:(NSDictionary *)dic {

    self = [super initWithJSONDic:dic];
    
    if (self) {
        self.InformationID = dic[@"id"];
        
        self.modelInfo = dic;
    }
    
    return self;    
}

@end
