//
//  AppDelegate.h
//  CXNews
//
//  Created by liyoubing on 16/4/26.
//  Copyright © 2016年 liyoubing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WeiboSDK.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate> {

    TencentOAuth *_tencentOAuth;
}

@property (strong, nonatomic) UIWindow *window;


@end

