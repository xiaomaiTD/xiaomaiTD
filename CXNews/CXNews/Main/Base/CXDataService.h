//
//  CXDataService.h
//  CXNews
//
//  Created by liyoubing on 16/5/7.
//  Copyright © 2016年 liyoubing. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GetResultProtocol <NSObject>

- (void)getNetDataSuccess:(id)result;

- (void)getNetDataField:(id)result;

@end

@interface CXDataService : NSObject

+ (void)requestDataWithMethod:(NSString *)method
                  withParames:(NSDictionary *)parames
                withURLString:(NSString *)urlStr
                 withDelegate:(id<GetResultProtocol>)delegate;

@end
