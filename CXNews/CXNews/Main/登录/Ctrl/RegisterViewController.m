//
//  RegisterViewController.m
//  CXNews
//
//  Created by liyoubing on 16/4/29.
//  Copyright © 2016年 liyoubing. All rights reserved.
//

#import "RegisterViewController.h"
#import "CXTextField.h"
#import "CodeButton.h"
#import <SMS_SDK/SMSSDK.h>
#import "UserInfoViewController.h"

@interface RegisterViewController ()<UITextFieldDelegate> {

    CXTextField *_phoneField;
    CXTextField *_codeField;
    CodeButton *_codeButton;
    UIButton *_button;
}

@end

@implementation RegisterViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"注册";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    
//    //监听键盘是否展开
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyBoard) name:UIKeyboardWillShowNotification object:nil];
    
    //创建子视图
    [self _initSubView];
    
    
}

//创建子视图
- (void)_initSubView {

    //创建输入手机号码的输入框
    _phoneField = [[CXTextField alloc] initWithFrame:CGRectMake(20, 20, KScreenWidth-40, 40)];
    _phoneField.placeholder = @"请输入手机号";
    _phoneField.delegate = self;
    _phoneField.backgroundColor = [UIColor clearColor];
    //设置边框
    _phoneField.layer.borderWidth = 1;
    _phoneField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _phoneField.layer.cornerRadius = 4;
    _phoneField.keyboardType = UIKeyboardTypeNumberPad;
    
    _phoneField.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_phoneField];
    
    //创建输入验证码的输入框
    _codeField = [[CXTextField alloc] initWithFrame:CGRectMake(_phoneField.left, _phoneField.bottom+20, _phoneField.width, _phoneField.height)];
    _codeField.delegate = self;
    _codeField.placeholder = @"请输入验证码";
    _codeField.backgroundColor = [UIColor clearColor];
    //设置边框
    _codeField.layer.borderWidth = 1;
    _codeField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _codeField.layer.cornerRadius = 4;
    _codeField.font = [UIFont systemFontOfSize:14];
    _codeField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_codeField];
    
    //创建按钮
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.frame = CGRectMake(_codeField.left, _codeField.bottom+20, _codeField.width, _codeField.height);
    [_button setTitle:@"开始验证" forState:UIControlStateNormal];
    [_button setBackgroundImage:[UIImage imageNamed:@"button@2x.png"] forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //禁用
    _button.enabled = NO;
    [_button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button];
    
    //创建验证码按钮
    _codeButton = [[CodeButton alloc] initWithFrame:CGRectMake(_codeField.right-70, _codeField.top+5, 70, 30)];
    [_codeButton addTarget:self action:@selector(getCodeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_codeButton];
    
}

//开始验证
- (void)buttonAction {

    //判断验证码是否正确
    [SMSSDK commitVerificationCode:_codeField.text phoneNumber:_phoneField.text zone:@"86" result:^(NSError *error) {
        
        if (error == nil) {
            UserInfoViewController *userInfoCtrl = [[UserInfoViewController alloc] init];
            //传递手机号
            userInfoCtrl.phoneNum = _phoneField.text;
            
            [self.navigationController pushViewController:userInfoCtrl animated:YES];
        }else {
            //提示
            iToast *itoast = [[iToast alloc] initWithText:@"验证码错误，请重新输入！"];
            [itoast show];
        }
        
    }];

    
}

//获取验证码
- (void)getCodeAction {

    //发送验证码
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:_phoneField.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
        
        if (error == nil) {//发送成功
            iToast *itoast = [[iToast alloc] initWithText:@"验证码已发送，请等待"];
            [itoast show];
        }else {
            iToast *itoast = [[iToast alloc] initWithText:@"验证码发送失败"];
            [itoast show];
            //按钮设置回以前的状态
            [_codeButton stop];
        }
        
    }];
    
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    //获取当前的文本
    NSString *content = textField.text;
    //判断当前输入的内容
    if (range.length == 0) {
        //输入内容
        content = [content stringByAppendingString:string];
    }else {
        //删除
        content = [content substringToIndex:content.length-1];
    }
    
    //判断获取验证码按钮是否可用
    if (textField == _phoneField) {
        //判断手机号码是否是11位
        if (content.length >= 11) {
            _codeButton.isPhoneNumber = YES;
        }else {
            _codeButton.isPhoneNumber = NO;
        }
    }
    
    //判断开始验证按钮是否可用
    if (textField == _codeField) {
       
        if (content.length >= 4 && _phoneField.text.length == 11) {
            _button.enabled = YES;
        }else {
            _button.enabled = NO;
        }
    }else {
    
        if (content.length>= 11 && _codeField.text.length == 4) {
            _button.enabled = YES;
        }else {
            _button.enabled = NO;
        }
        
    }
    
    //显示用户输入的长度
    if (textField == _phoneField) {
//        if (range.location <= 10) {
//            return YES;
//        }else {
//            return NO;
//        }
        
//        return range.location<=10?YES:NO;
        return range.location <= 10;
        
    }else {
//        if (range.location <= 3) {
//            return YES;
//        }else {
//            return NO;
//        }
        return range.location <= 3;
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
    
}

@end
