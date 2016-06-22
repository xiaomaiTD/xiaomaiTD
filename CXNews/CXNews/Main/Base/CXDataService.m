
//
//  CXDataService.m
//  CXNews
//
//  Created by liyoubing on 16/5/7.
//  Copyright © 2016年 liyoubing. All rights reserved.
//

#import "CXDataService.h"

@implementation CXDataService

+ (void)requestDataWithMethod:(NSString *)method
                  withParames:(NSDictionary *)parames
                withURLString:(NSString *)urlStr
                 withDelegate:(id<GetResultProtocol>)delegate {

    //1.执行注销操作
    //（1）构造URL
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BaseURL,urlStr];
    NSURL *url = [NSURL URLWithString:urlString];
    
    //（2）构造request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = method;
    request.timeoutInterval = 30;

    //添加参数
    if ([method isEqualToString:@"GET"]) {
        
        NSMutableString *str = [[NSMutableString alloc] init];
        [str appendString:@"?"];
        for (NSString *key in parames) {
            [str appendFormat:@"%@=%@&",key,parames[key]];
        }
        //将最后的&移除 123456789&
        [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];
        
        urlString = [NSString stringWithFormat:@"%@%@",urlString,str];
        url = [NSURL URLWithString:urlString];
        request.URL = url;
    }else {
        
        NSMutableString *str = [[NSMutableString alloc] init];
        for (NSString *key in parames) {
            [str appendFormat:@"%@=%@&",key,parames[key]];
        }
        //将最后的&移除 123456789&
        [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];
        
        NSData *bodyData = [str dataUsingEncoding:NSUTF8StringEncoding];
        request.HTTPBody = bodyData;
    }
    
    //发送请求
    //显示网络加载提示
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        //隐藏网络加载提示
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        if (connectionError == nil) {
            //响应了
            //解析数据
            id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            [delegate getNetDataSuccess:result];
            
        }else {
            //失败了
            [delegate getNetDataField:connectionError];
        }
    }];
    
}

@end
