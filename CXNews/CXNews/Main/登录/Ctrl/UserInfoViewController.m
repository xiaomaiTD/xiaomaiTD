//
//  UserInfoViewController.m
//  CXNews
//
//  Created by liyoubing on 16/5/3.
//  Copyright © 2016年 liyoubing. All rights reserved.
//

#import "UserInfoViewController.h"
#import "CXTextField.h"
#import "SexControl.h"
#import "DatePickerController.h"

@interface UserInfoViewController ()<GetSelectDateDelegate> {

    UIWindow *_dateWindow;
    UIButton *_birthdayButton;
    NSInteger _sexNum;
}

@end

@implementation UserInfoViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"注册信息";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _sexNum = 2;
    //创建子视图
    [self _initSubView];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyBoard:) name:UIKeyboardWillShowNotification object:nil];
}

//- (void)showKeyBoard:(NSNotification *)notif {
//
//    NSLog(@"%@",notif.userInfo);
//    
//}

//创建子视图
- (void)_initSubView {

    //创建显示的文字内容数组
    NSArray *titleArray = @[@"密码：",
                            @"验证：",
                            @"姓名：",
                            @"昵称：",
                            @"性别：",
                            @"生日：",
                            @"地址："];
    NSArray *holdArray = @[@"请输入密码",
                           @"请再次输入密码",
                           @"请输入姓名",
                           @"请输入昵称",
                           @"",
                           @"",
                           @"请输入地址（保密）"];
    
    for (int i=0; i<titleArray.count; i++) {
        //创建显示文字的文本
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 20+i*(35+25), 50, 35)];
        titleLabel.text = titleArray[i];
        titleLabel.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:titleLabel];
        
        if ([titleArray[i] isEqualToString:@"性别："]) {
            //创建单选按钮
            SexControl *sexCtrl = [[SexControl alloc] initWithFrame:CGRectMake(titleLabel.right+5, 20+i*(35+25), 200, 40)];
            //添加点击事件
            [sexCtrl addTarget:self action:@selector(selectSexAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:sexCtrl];
            
        }else if ([titleArray[i] isEqualToString:@"生日："]) {
            //创建按钮
            _birthdayButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _birthdayButton.backgroundColor = [UIColor clearColor];
            _birthdayButton.frame = CGRectMake(titleLabel.right+5, 20+i*(35+25), 120, 35);
            [_birthdayButton setTitle:@"1993-01-01" forState:UIControlStateNormal];
            [_birthdayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_birthdayButton addTarget:self action:@selector(selectBirtydayAction) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:_birthdayButton];
            
            
        }else {
            //创建输入框
            CXTextField *textField = [[CXTextField alloc] initWithFrame:CGRectMake(titleLabel.right+5, 20+i*(35+25), KScreenWidth-titleLabel.right-5-15, 35)];
            //设置边框
            textField.layer.cornerRadius = 4;
            textField.layer.borderWidth = 1;
            textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
            textField.placeholder = holdArray[i];
            textField.tag = 100+i;
            [self.view addSubview:textField];
            
            if ([titleArray[i] isEqualToString:@"密码："] || [titleArray[i] isEqualToString:@"验证："]) {
                textField.secureTextEntry = YES;
            }

        }
        
    }
    
    //获取视图
    CXTextField *placeField = (CXTextField *)[self.view viewWithTag:100+6];
    
    //创建提交按钮
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commitButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"button@2x.png"]];
    [commitButton setTitle:@"提交" forState:UIControlStateNormal];
    [commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    commitButton.frame = CGRectMake(20, placeField.bottom+20, KScreenWidth-40, 40);
    [commitButton addTarget:self action:@selector(commitAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commitButton];
    
    
}

//提交按钮
- (void)commitAction {

    CXTextField *passField = (CXTextField *)[self.view viewWithTag:100+0];
    CXTextField *rPassField = (CXTextField *)[self.view viewWithTag:100+1];
    CXTextField *nameField = (CXTextField *)[self.view viewWithTag:100+2];
    CXTextField *nickField = (CXTextField *)[self.view viewWithTag:100+3];
    CXTextField *addressField = (CXTextField *)[self.view viewWithTag:100+6];
    
    //注册用户
    //(1)判断验证密码是否正确
    if (![passField.text isEqualToString:rPassField.text]) {
        //提示
        iToast *itoast = [[iToast alloc] initWithText:@"两次密码不一致，请核对再输入！"];
        [itoast show];
        passField.text = @"";
        rPassField.text = @"";
        
        return;
    }
    
    //（2）判断密码的长度
    if (passField.text.length < 6) {
        //提示
        iToast *itoast = [[iToast alloc] initWithText:@"密码强度不够，请重新设置！"];
        [itoast show];
        
        return;
    }
    
    //(3)开始提交注册
    //<1>构造URL
    NSString *registerStr = [NSString stringWithFormat:@"%@%@",BaseURL,RegisterUser];
    NSURL *url = [NSURL URLWithString:registerStr];
    
    //<2>构造request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 30;
    
    NSString *nickName = nickField.text.length==0?@"未知":nickField.text;
    NSString *trueName = nameField.text.length==0?@"未知":nameField.text;
    NSString *address = addressField.text.length==0?@"未知":addressField.text;
    
    //设置请求体
    //1>userName  pwd  key=value&
    NSString *paramesStr = [NSString stringWithFormat:@"userName=%@&pwd=%@&birthDayString=%@&sex=%ld&tel=%d&nickName=%@&trueName=%@&Address=%@",_phoneNum,passField.text,_birthdayButton.titleLabel.text,_sexNum,[_phoneNum intValue],nickName,trueName,address];
    
    request.HTTPBody = [paramesStr dataUsingEncoding:NSUTF8StringEncoding];
    
    //设置请求提示
    self.title = @"正在注册 ...";
    //网络加载提示
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        //设置请求提示
        self.title = @"注册信息";
        //网络加载提示
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        if (connectionError == nil) {
            //链接服务器成功
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            //判断是否注册成功
            if ([[result objectForKey:@"code"] isEqualToString:@"1000"]) {
                
                //提示
                iToast *itoast = [[iToast alloc] initWithText:@"注册成功！"];
                [itoast show];
        
                //跳转到登录界面
                UIViewController *viewCtrl = self.navigationController.viewControllers[1];
                [self.navigationController popToViewController:viewCtrl animated:YES];
                
            }else {
                //提示
                iToast *itoast = [[iToast alloc] initWithText:result[@"errorMsg"]];
                [itoast show];
            }
            
        }else {
            //提示
            iToast *itoast = [[iToast alloc] initWithText:@"连接服务器失败，请稍后再试！"];
            [itoast show];
        }
        
    }];
    
    
    
}

//选择生日的时候调用的方法
- (void)selectBirtydayAction {
    
//    DatePickerController *datePickerCtrl = [[DatePickerController alloc] init];
//    [self presentViewController:datePickerCtrl animated:NO completion:nil];

    //创建窗口以承载DatePickerController
    _dateWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //设置优先级
    _dateWindow.windowLevel = UIWindowLevelStatusBar;
    _dateWindow.backgroundColor = [UIColor clearColor];
    
     DatePickerController *datePickerCtrl = [[DatePickerController alloc] init];
    //传递默认的日期
    datePickerCtrl.selectDate = _birthdayButton.titleLabel.text;
    
    //设置代理
    datePickerCtrl.delegate = self;
    
    _dateWindow.rootViewController = datePickerCtrl;
    _dateWindow.hidden = NO;
    
}

//选择性别
- (void)selectSexAction:(SexControl *)sexCtrl {

    NSLog(@"%ld",sexCtrl.selectIndex);
    _sexNum = sexCtrl.selectIndex;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    [self.view endEditing:YES];
    
}

#pragma mark - GetSelectDateDelegate
- (void)getSelectResult:(NSString *)dateStr {

    [_birthdayButton setTitle:dateStr forState:UIControlStateNormal];
}


@end
