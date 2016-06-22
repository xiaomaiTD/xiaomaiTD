//
//  LoginViewController.h
//  CXNews
//
//  Created by liyoubing on 16/4/29.
//  Copyright © 2016年 liyoubing. All rights reserved.
//

#import "BaseViewController.h"

@protocol LoginSuccessProtocol <NSObject>

- (void)loginSuccess;

@end

@interface LoginViewController : BaseViewController

@property(nonatomic, strong)id<LoginSuccessProtocol> delegate;

@end
