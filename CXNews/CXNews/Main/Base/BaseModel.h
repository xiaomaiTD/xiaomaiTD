//
//  BaseModel.h
//  02 课堂练习
//
//  Created by liyoubing on 16/4/22.
//  Copyright © 2016年 liyoubing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject

//从外界传递字典
- (id)initWithJSONDic:(NSDictionary *)dic;

//将字典中的value值交给model的属性
//如果属性名和字典的key有少许不一样，可以复写这个方法
- (void)setAttributeWithDic:(NSDictionary *)dic;

//获取映射关系
//key：model的属性名
- (NSDictionary *)attributeMap:(NSDictionary *)jsonDic;

@end
