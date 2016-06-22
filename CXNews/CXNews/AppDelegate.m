//
//  AppDelegate.m
//  CXNews
//
//  Created by liyoubing on 16/4/26.
//  Copyright © 2016年 liyoubing. All rights reserved.
//

#import "AppDelegate.h"
#import "CXTabbarController.h"
#import "LunchViewController.h"
#import <SMS_SDK/SMSSDK.h>

#define VersionString @"Version"

@interface AppDelegate ()<UIAlertViewDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //设置程序的启动界面
    //判断当前的版本是否和本地保存的版本一致
    //（1）获取当前的版本
    NSDictionary *dic = [[NSBundle mainBundle] infoDictionary];
    NSString *version = dic[@"CFBundleShortVersionString"];
    //（2）获取本地保存的版本
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *localVersion = [userDefault objectForKey:VersionString];
    
    if (![version isEqualToString:localVersion]) {
        //将版本号保存到本地
        [userDefault setObject:version forKey:VersionString];
        [userDefault synchronize];
        
        //启动图片
        self.window.rootViewController = [[LunchViewController alloc] init];
        
    }else {
    
        //获取当前是否有新的版本
        [self getAppstoreNewVersion];
        
        //设置根控制器
        self.window.rootViewController = [[CXTabbarController alloc] init];
    }
    
    //初始化应用，appKey和appSecret从后台申请得
    [SMSSDK registerApp:@"12560f05303da"
             withSecret:@"3ac2b74de7a4e37ea9f1de72d0cbc2e7"];
    
    //注册腾讯登录的auth
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:APPID andDelegate:nil];
    
//    //注册微博
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:@"1179867711"];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [TencentOAuth HandleOpenURL:url] || [WeiboSDK handleOpenURL:url delegate:nil];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [TencentOAuth HandleOpenURL:url] || [WeiboSDK handleOpenURL:url delegate:nil];
}

- (void)getAppstoreNewVersion {

    //（1）构造URL
    NSURL *url = [NSURL URLWithString:KApi_appInfo];
    
    //(2)构造request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"GET";
    request.timeoutInterval = 30;
    
    //（3）connection
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if (connectionError == nil) {
            
            //请求成功
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            //判断是否有数据
            NSInteger count = [dic[@"resultCount"] integerValue];
            if (count > 0) { //有新的版本
                //获取新的版本
                NSArray *resultArray = dic[@"results"];
                NSDictionary *resultDic = resultArray[0];
                NSString *version = resultDic[@"version"];
                
                //判断是否一样
                NSDictionary *dic = [[NSBundle mainBundle] infoDictionary];
                NSString *version1 = dic[@"CFBundleShortVersionString"];
                
                if (![version isEqualToString:version1]) {
                    NSString *message = [NSString stringWithFormat:@"畅想新闻有新的版本：%@,是否更新",version];
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    [alertView show];

                }
                
            }
            
        }
        
    }];
    
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex == 1) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:KApi_updataInfo]];
    }
}

@end
