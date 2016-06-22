//
//  LoginViewController.m
//  CXNews
//
//  Created by liyoubing on 16/4/29.
//  Copyright © 2016年 liyoubing. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "UserModel.h"
#import "ManagerUserInfo.h"
#import <TencentOpenAPI/TencentOAuth.h>

@interface LoginViewController ()<TencentSessionDelegate> {

    UITextField *_phoneNumField;
    UITextField *_passWordField;
    
    TencentOAuth *_tencentOAuth;
}

@end

@implementation LoginViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"登录";
        //隐藏标签栏
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //创建子视图
    [self _initSubView];
    
}


//创建子视图
- (void)_initSubView {

    //创建图片
    UIImageView *imgView1 = [[UIImageView alloc] initWithFrame:CGRectMake((KScreenWidth-190)/2.0, 40, 190, 16)];
    imgView1.image = [UIImage imageNamed:@"login_sj@2x.png"];
    [self.view addSubview:imgView1];
    
    //创建按钮
    NSArray *imgArray = @[@"qq_login@2x.png",@"sina_login@2x.png",@"weixin_login@2x.png"];
    for (int i=0; i<3; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((KScreenWidth-47.5*3-20*2)/2.0+(47.5+20)*i, imgView1.bottom+20, 47.5, 47.5);
        [button setImage:[UIImage imageNamed:imgArray[i]] forState:UIControlStateNormal];
        button.tag = i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
    UIImageView *imgView2 = [[UIImageView alloc] initWithFrame:CGRectMake((KScreenWidth-190)/2.0, imgView1.bottom+40+47.5, 190, 16)];
    imgView2.image = [UIImage imageNamed:@"login_cx@2x.png"];
    [self.view addSubview:imgView2];
    
    //创建输入框
    UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, imgView2.bottom+50, 40, 30)];
    countLabel.text = @"账号:";
    countLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:countLabel];
    
    _phoneNumField = [[UITextField alloc] initWithFrame:CGRectMake(countLabel.right+20, countLabel.top, KScreenWidth-countLabel.right-20, 30)];
    _phoneNumField.placeholder = @"请输入手机号";
    _phoneNumField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_phoneNumField];
    
    //创建分隔线
    UIImageView *lineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, countLabel.bottom+2, KScreenWidth-40, 1)];
    lineImgView.image = [UIImage imageNamed:@"line_gray@2x.png"];
    [self.view addSubview:lineImgView];
    
    //创建输入框
    UILabel *passWordLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,lineImgView.bottom+20, 40, 30)];
    passWordLabel.text = @"密码:";
    passWordLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:passWordLabel];
    
    _passWordField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(passWordLabel.frame)+20, CGRectGetMinY(passWordLabel.frame), KScreenWidth-CGRectGetMaxX(passWordLabel.frame)-20, 30)];
    _passWordField.secureTextEntry = YES;
    _passWordField.placeholder = @"请输入密码";
    [self.view addSubview:_passWordField];
    
    //创建分隔线
    UIImageView *lineImgView1 = [[UIImageView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(passWordLabel.frame)+2, KScreenWidth-40, 1)];
    lineImgView1.image = [UIImage imageNamed:@"line_gray@2x.png"];
    [self.view addSubview:lineImgView1];
    
    //创建登录按钮
    UIButton *logButton = [UIButton buttonWithType:UIButtonTypeCustom];
    logButton.frame = CGRectMake((KScreenWidth-141.5)/2.0, CGRectGetMaxY(lineImgView1.frame)+20, 141.5, 35);
    [logButton setImage:[UIImage imageNamed:@"login.png"] forState:UIControlStateNormal];
    [logButton addTarget:self action:@selector(logAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logButton];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(logButton.frame), CGRectGetMaxY(logButton.frame)+10, 70, 20)];
    textLabel.font = [UIFont systemFontOfSize:11];
    textLabel.textColor = [UIColor lightGrayColor];
    textLabel.text = @"没有账号?";
    [self.view addSubview:textLabel];
    
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registerButton.frame = CGRectMake(CGRectGetMaxX(textLabel.frame), CGRectGetMaxY(logButton.frame)+10, 70, 20);
    registerButton.titleLabel.font = [UIFont systemFontOfSize:11];
    
    //属性字符串
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:@"免费注册"];
    //设置内容的颜色
    [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, attributeStr.length)];
    [attributeStr addAttribute:NSUnderlineStyleAttributeName value:@1 range:NSMakeRange(0, attributeStr.length)];
    
    [registerButton setAttributedTitle:attributeStr forState:UIControlStateNormal];
    [registerButton addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerButton];
    
}

- (void)buttonAction:(UIButton *)button {

    if (button.tag == 0) {
        //QQ登录
        NSArray* permissions = [NSArray arrayWithObjects:
                                kOPEN_PERMISSION_GET_USER_INFO,
                                kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                                kOPEN_PERMISSION_ADD_SHARE,
                                nil];
        _tencentOAuth = [[TencentOAuth alloc] initWithAppId:APPID andDelegate:self];
        [_tencentOAuth authorize:permissions inSafari:NO];
        
    }else if (button.tag == 1) {
        //微博
    }else {
        //微信
    }
    
}

//登录的点击事件
- (void)logAction {

    //（1）参数
    NSString *paramesStr = [NSString stringWithFormat:@"userName=%@&pwd=%@",_phoneNumField.text,_passWordField.text];
    //（2）构造URL
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BaseURL,LoginUser];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    //（3）构造request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 30;
    //设置请求体
    request.HTTPBody = [paramesStr dataUsingEncoding:NSUTF8StringEncoding];
    
    //设置标题
    self.title = @"正在登录 ...";
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        self.title = @"登录";
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        if (connectionError == nil) {
            //服务器连接成功
            NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if ([resultDic[@"code"] isEqualToString:@"1000"]) {
                //登录成功
                //提示
                iToast *itoast = [[iToast alloc] initWithText:@"登录成功!"];
                [itoast show];
                
                //将数据保存到本地
                //获取用户信息
                NSDictionary *userDic = [resultDic[@"result"] lastObject];
                //将用户信息存放到model中
                UserModel *model = [[UserModel alloc] initWithJSONDic:userDic];
//                //将用户信息保存到本地
                ManagerUserInfo *manager = [ManagerUserInfo shareInstance];
                manager.model = model;
                
                //回调
                if ([_delegate respondsToSelector:@selector(loginSuccess)]) {
                    [_delegate loginSuccess];
                }
                
                //返回“我的”界面
                [self.navigationController popViewControllerAnimated:YES];
                
            }else {
                //登录失败
                iToast *itoast = [[iToast alloc] initWithText:resultDic[@"errorMsg"]];
                [itoast show];
            }
            
            
        }else {
            //服务器连接失败
            //提示
            iToast *itoast = [[iToast alloc] initWithText:@"服务器连接失败！"];
            [itoast show];
        }
        
        
    }];
}

//注册事件
- (void)registerAction {

    RegisterViewController *registerCtrl = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:registerCtrl animated:YES];
    
}

//注册用户
- (void)registerUserWithUserName:(NSString *)userName withNickName:(NSString *)nickName {

    //(3)开始提交注册
    //<1>构造URL
    NSString *registerStr = [NSString stringWithFormat:@"%@%@",BaseURL,RegisterUser];
    NSURL *url = [NSURL URLWithString:registerStr];
    
    //<2>构造request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 30;
    
    //设置请求体
    //1>userName  pwd  key=value&
    NSString *paramesStr = [NSString stringWithFormat:@"userName=%@&pwd=12345667&nickName=%@",userName,nickName];
    
    request.HTTPBody = [paramesStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {

        if (connectionError == nil) {
            //链接服务器成功
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            
            //判断是否注册成功
            if ([[result objectForKey:@"code"] isEqualToString:@"1000"] || [result[@"errorMsg"] isEqualToString:@"用户名已存在！"]) {
                
                //提示
                iToast *itoast = [[iToast alloc] initWithText:@"登录成功！"];
                [itoast show];
                
                //第三方登入
                [self loginUserName:userName];
                
                
            }else {
                //提示
                iToast *itoast = [[iToast alloc] initWithText:@"登录失败"];
                [itoast show];
            }
            
        }else {
            //提示
            iToast *itoast = [[iToast alloc] initWithText:@"连接服务器失败，请稍后再试！"];
            [itoast show];
        }
        
    }];
    
}

//第三方登入
- (void)loginUserName:(NSString *)userName {

    //（1）参数
    NSString *paramesStr = [NSString stringWithFormat:@"userName=%@&pwd=12345667",userName];
    //（2）构造URL
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BaseURL,LoginUser];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    //（3）构造request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 30;
    //设置请求体
    request.HTTPBody = [paramesStr dataUsingEncoding:NSUTF8StringEncoding];
    
    //设置标题
    self.title = @"正在登录 ...";
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        self.title = @"登录";
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        if (connectionError == nil) {
            //服务器连接成功
            NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if ([resultDic[@"code"] isEqualToString:@"1000"]) {
                //登录成功
                //提示
                iToast *itoast = [[iToast alloc] initWithText:@"登录成功!"];
                [itoast show];
                
                //将数据保存到本地
                //获取用户信息
                NSDictionary *userDic = [resultDic[@"result"] lastObject];
                //将用户信息存放到model中
                UserModel *model = [[UserModel alloc] initWithJSONDic:userDic];
                //                //将用户信息保存到本地
                ManagerUserInfo *manager = [ManagerUserInfo shareInstance];
                manager.model = model;
                
                //回调
                if ([_delegate respondsToSelector:@selector(loginSuccess)]) {
                    [_delegate loginSuccess];
                }
                
                //返回“我的”界面
                [self.navigationController popViewControllerAnimated:YES];
                
            }else {
                //登录失败
                iToast *itoast = [[iToast alloc] initWithText:resultDic[@"errorMsg"]];
                [itoast show];
            }
            
            
        }else {
            //服务器连接失败
            //提示
            iToast *itoast = [[iToast alloc] initWithText:@"服务器连接失败！"];
            [itoast show];
        }
        
        
    }];

    
    
}

#pragma mark -
//获取用户个人信息回调
- (void)getUserInfoResponse:(APIResponse*)response {

    //jsonResponse
    NSDictionary *jsonDic = response.jsonResponse;
    NSLog(@"jsonDic:%@",jsonDic);
    //获取用户名
    //figureurl_2
    NSString *nickName = jsonDic[@"nickname"];
    //用户名
    NSString *userName = _tencentOAuth.openId;
    //密码
    //随意设置 222222
    //12345678911
    
    [self registerUserWithUserName:userName withNickName:nickName];
    
}

// 登录成功后的回调
- (void)tencentDidLogin {

    //获取用户的信息
    [_tencentOAuth getUserInfo];
    
}
// 登录失败后的回调
- (void)tencentDidNotLogin:(BOOL)cancelled {

    iToast *itoast = [[iToast alloc] initWithText:@"登录失败"];
    [itoast show];
    
}

// 登录时网络有问题的回调
- (void)tencentDidNotNetWork {
    iToast *itoast = [[iToast alloc] initWithText:@"登录失败"];
    [itoast show];
}

@end
