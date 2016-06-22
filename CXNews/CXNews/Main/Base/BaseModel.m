//
//  BaseModel.m
//  02 课堂练习
//
//  Created by liyoubing on 16/4/22.
//  Copyright © 2016年 liyoubing. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

//从外界传递字典
- (id)initWithJSONDic:(NSDictionary *)dic {
    
    self = [super init];
    if (self) {
        
        //将字典中的value值交给model的属性
        [self setAttributeWithDic:dic];
        
    }
    return self;
}

//将字典中的value值交给model的属性
- (void)setAttributeWithDic:(NSDictionary *)dic {
    
    //设置映射关系
    //字典key：model的属性名
    NSDictionary *mapDic = [self attributeMap:dic];
    
    //获取属性名并且设置属性值
    for (NSString *jsonKey in mapDic) {
        //（1）获取属性名
        NSString *modelArrt = mapDic[jsonKey];
        //（2）json中的value
        id jsonValue = dic[jsonKey];
        //（3）设置属性值
        //根据属性名获取setter方法
        //name  setName
        
        //<1>获取属性的setter方法
        SEL setterSel = [self modelNameToSetter:modelArrt];
        
        //注意：数据的容错判断
        if ([jsonValue isKindOfClass:[NSNull class]]) {
            jsonValue = @"";
        }
        
        //<2>调用setter方法
        if ([self respondsToSelector:setterSel]) {
            [self performSelector:setterSel withObject:jsonValue];
        }
    }
    
    
}

//根据属性名获取setter方法
- (SEL)modelNameToSetter:(NSString *)modelArrt {
    
    //获取方法（1）@selector
    //根据方法名获取方法
    //    NSSelectorFromString(<#NSString * _Nonnull aSelectorName#>)
    
    //name setName:
    //（1）首字母大写
    //    [modelArrt capitalizedString];  userName  ---  Username
    NSString *firstStr = [modelArrt substringToIndex:1];
    firstStr = [firstStr uppercaseString];
    
    //（2）其余的原方式
    NSString *otherStr = [modelArrt substringFromIndex:1];
    
    //（3）拼接方法名 set
    NSString *selectorName = [NSString stringWithFormat:@"set%@%@:",firstStr,otherStr];
    
    return NSSelectorFromString(selectorName);
}

//获取映射关系
//key：model的属性名
- (NSDictionary *)attributeMap:(NSDictionary *)jsonDic {
    
    NSMutableDictionary *mapDic = [[NSMutableDictionary alloc] init];
    for (NSString *key in jsonDic) {
        [mapDic setObject:key forKey:key];
    }
    
    return mapDic;
}

@end
