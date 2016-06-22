//
//  LoginView.m
//  CXNews
//
//  Created by liyoubing on 16/4/29.
//  Copyright © 2016年 liyoubing. All rights reserved.
//

#import "UnloginView.h"
#import "UIView+ViewController.h"

@implementation UnloginView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //创建子视图
        [self _initSubView];
    }
    return self;
}

//创建子视图
- (void)_initSubView {

    //创建背景视图
    UIImageView *logImgView = [[UIImageView alloc] initWithFrame:CGRectMake((KScreenWidth-115.5)/2.0, 50, 115.5, 151)];
    logImgView.image = [UIImage imageNamed:@"logo_background@2x.png"];
    [self addSubview:logImgView];
    
    //创建文字提示视图
    _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(logImgView.frame)+50, KScreenWidth, 20)];
    _messageLabel.textColor = [UIColor colorWithRed:29/255.0 green:43/255.0 blue:137/255.0 alpha:1];
    _messageLabel.font = [UIFont systemFontOfSize:13];
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    //设置显示的数据默认值
    _messageLabel.text = @"很遗憾，您还没有登录，赶紧加入我们吧!";
    [self addSubview:_messageLabel];
    
    //创建点击按钮
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake((KScreenWidth-273)/2.0, CGRectGetMaxY(_messageLabel.frame)+50, 273, 63);
    [loginButton setImage:[UIImage imageNamed:@"login_btn@2x.png"] forState:UIControlStateNormal];
    [loginButton  addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:loginButton];
}

- (void)setMessageString:(NSString *)messageString {

    _messageString = messageString;
    //设置显示的内容
    _messageLabel.text = _messageString;
}


//登录的点击事件
- (void)loginAction {

//    NSLog(@"%@",self.viewController);
    
    //调用block
    if (_block) {
        _block();
    }
    
    //回调代理方法
    if ([_delegate respondsToSelector:@selector(getLoginAction)]) {
        [_delegate getLoginAction];
    }
}





@end
