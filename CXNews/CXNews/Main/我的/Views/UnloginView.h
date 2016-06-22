//
//  LoginView.h
//  CXNews
//
//  Created by liyoubing on 16/4/29.
//  Copyright © 2016年 liyoubing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginActionDelegate <NSObject>

- (void)getLoginAction;

@end

typedef void(^LoginActionBlock)();

@interface UnloginView : UIView {

    UILabel *_messageLabel;
}

@property(nonatomic, copy)NSString *messageString;
@property(nonatomic, copy)LoginActionBlock block;

@property(nonatomic, weak)id<LoginActionDelegate> delegate;

@end
