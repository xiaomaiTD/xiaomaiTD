
//
//  UIView+ViewController.m
//  CXNews
//
//  Created by liyoubing on 16/4/29.
//  Copyright © 2016年 liyoubing. All rights reserved.
//

#import "UIView+ViewController.h"

@implementation UIView (ViewController)

//获取对应的控制器
- (UIViewController *)viewController {

    //响应者链  uiview  UIViewController  UIWindow UIApplication
    
    //获取下一个响应者
    UIResponder *next = self.nextResponder;
    
    while (next != nil) {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        
        next = next.nextResponder;
    }
    
    return nil;
    
}

@end
