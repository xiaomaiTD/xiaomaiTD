//
//  ChangeMessageController.m
//  CXNews
//
//  Created by liyoubing on 16/5/6.
//  Copyright © 2016年 liyoubing. All rights reserved.
//

#import "ChangeMessageController.h"
#import "CXTextField.h"
#import "DatePickerController.h"
#import "SexControl.h"

@interface ChangeMessageController ()<GetSelectDateDelegate,UITextFieldDelegate> {

    UIWindow *_birthDayWindow;
    
    NSString *_changeStr;
}

@end

@implementation ChangeMessageController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSArray *titleArray = @[
                            @"修改姓名",
                            @"修改生日",
                            @"修改性别",
                            @"修改电话",
                            @"修改地址",
                            @"修改密码",
                            @"修改昵称"
                            ];
    
    self.title = titleArray[_index];
    
    [self _initSubViewWithIndex:_index];
}

- (void)_initSubViewWithIndex:(NSInteger)index {

    NSArray *placeHolderArray = @[@"请输入姓名",@"",@"",@"请输入电话号码",@"请输入地址",@"请输入新密码",@"请输入昵称"];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 30, 60, 20)];
    titleLabel.text = [NSString stringWithFormat:@"%@：",[self.title substringFromIndex:2]];
    titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:titleLabel];
    
    //创建提交按钮
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [commitButton setBackgroundImage:[UIImage imageNamed:@"button@2x.png"] forState:UIControlStateNormal];
    commitButton.frame = CGRectMake(15, 110, KScreenWidth-30, 40);
    [commitButton setTitle:@"提 交" forState:UIControlStateNormal];
    [commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [commitButton addTarget:self action:@selector(commitAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commitButton];
    
    if (index == 1) {
        //修改生日
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 100;
        button.frame = CGRectMake(titleLabel.right, 20, 150, 40);
        [button setTitle:_dataStr forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(changeBirthdayAction) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:button];
        
        //调整按钮的位置
        commitButton.top = button.bottom+20;
        
    }else if (index == 2) {
        //修改性别
        SexControl *ctrl = [[SexControl alloc] initWithFrame:CGRectMake(titleLabel.right, 20, 200, 40)];
        ctrl.selectIndex = [_dataStr integerValue];
        [ctrl addTarget:self action:@selector(changeSex:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:ctrl];
        
        //调整按钮的位置
        commitButton.top = ctrl.bottom+20;
        
    }else if (index == 5) {
        //修改密码
        //创建输入框
        CXTextField *textField = [[CXTextField alloc] initWithFrame:CGRectMake(titleLabel.right, 20, KScreenWidth-15-titleLabel.right-5, 40)];
        textField.layer.cornerRadius = 4;
        textField.layer.borderWidth = 1;
        textField.tag = 101;
        textField.layer.borderColor = [UIColor grayColor].CGColor;
        textField.placeholder = placeHolderArray[_index];
        textField.layer.masksToBounds = YES;
        textField.secureTextEntry = YES;
        [self.view addSubview:textField];
        
        //创建输入框
        CXTextField *textField1 = [[CXTextField alloc] initWithFrame:CGRectMake(titleLabel.right, textField.bottom+30, KScreenWidth-15-titleLabel.right-5, 40)];
        textField1.layer.cornerRadius = 4;
        textField1.layer.borderWidth = 1;
        textField1.tag = 102;
        textField1.layer.borderColor = [UIColor grayColor].CGColor;
        textField1.secureTextEntry = YES;
        textField1.placeholder = @"请再次输入新密码";
        textField1.layer.masksToBounds = YES;
        [self.view addSubview:textField1];

        UILabel *sureLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, textField1.center.y-10, 60, 20)];
        sureLabel.text = @"验证：";
        [self.view addSubview:sureLabel];
        
        
        //调整按钮的位置
        commitButton.top = textField1.bottom+20;
        
    }else {
    
        //创建输入框
        CXTextField *textField = [[CXTextField alloc] initWithFrame:CGRectMake(titleLabel.right, 20, KScreenWidth-15-titleLabel.right-5, 40)];
        textField.layer.cornerRadius = 4;
        textField.layer.borderWidth = 1;
        textField.layer.borderColor = [UIColor grayColor].CGColor;
        textField.delegate = self;
        textField.placeholder = placeHolderArray[_index];
        textField.layer.masksToBounds = YES;
        textField.text = _dataStr;
        [self.view addSubview:textField];
        
        
        //调整按钮的位置
        commitButton.top = textField.bottom+20;
        
    }
    
}

//修改生日
- (void)changeBirthdayAction {

    _birthDayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _birthDayWindow.backgroundColor = [UIColor clearColor];
    _birthDayWindow.windowLevel = UIWindowLevelAlert;
    _birthDayWindow.hidden = NO;
    
    //创建提示视图
    DatePickerController *pickerCtrl = [[DatePickerController alloc] init];
    _birthDayWindow.rootViewController = pickerCtrl;
    pickerCtrl.selectDate = _dataStr;
    
    pickerCtrl.delegate = self;
    
}

//修改性别
- (void)changeSex:(SexControl *)ctrl {

    //保存数据
    _changeStr = [NSString stringWithFormat:@"%ld",ctrl.selectIndex];
}

//提交
- (void)commitAction {

    [self.view endEditing:YES];
    
    //如果是修改密码
    if (_index == 5) {
        CXTextField *tf1 = (CXTextField *)[self.view viewWithTag:101];
        CXTextField *tf2 = (CXTextField *)[self.view viewWithTag:102];
        
        if (tf1.text.length < 6) {
            
            iToast *toas = [[iToast alloc] initWithText:@"密码不合法"];
            [toas show];
            return;
        }else if (![tf1.text isEqualToString:tf2.text]) {
            iToast *toas = [[iToast alloc] initWithText:@"密码前后不同，请核实"];
            [toas show];
            return;
        }
        
        _changeStr = tf1.text;
    }
    
    //获取key
    NSArray *keyArray = @[@"trueName",
                           @"birthdaystring",
                           @"Sex",
                           @"Tel",
                           @"Address",
                           @"Pwd",
                           @"nickName"];
    
    //(1)构造URL
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BaseURL,EditUserInfo];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    //（2）构造request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 20;
    
    //设置请求体
    NSString *token = [ManagerUserInfo shareInstance].model.token;
    NSString *paramesStr = [[NSString alloc] initWithFormat:@"token=%@&%@=%@",token,keyArray[_index],_changeStr];
    
    request.HTTPBody = [paramesStr dataUsingEncoding:NSUTF8StringEncoding];
    
    //（3）connection
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if (connectionError == nil) {
            //服务器响应了
            NSDictionary *jsonDic= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            //判断是否修改成功
            if ([jsonDic[@"code"] isEqualToString:@"1000"]) {
                
                iToast *toas = [[iToast alloc] initWithText:@"修改成功！"];
                [toas show];
                
                //获取用户的model
                NSArray *resultArray = jsonDic[@"result"];
                NSDictionary *dic = resultArray[0];
                UserModel *model = [[UserModel alloc] initWithJSONDic:dic];
                
                //修改本地保存的数据
                ManagerUserInfo *manager = [ManagerUserInfo shareInstance];
                manager.model = model;
                
                //回到前一个界面
                [self.navigationController popViewControllerAnimated:YES];
                
            }else {
                iToast *toas = [[iToast alloc] initWithText:jsonDic[@"修改失败"]];
                [toas show];
            }
            
        }else {
            iToast *toas = [[iToast alloc] initWithText:@"网络连接错误！"];
            [toas show];
        }
        
    }];
    
    
}

#pragma mark - GetSelectDateDelegate
- (void)getSelectResult:(NSString *)dateStr {
    
    NSLog(@"dateStr:%@",dateStr);
    
    UIButton *button = (UIButton *)[self.view viewWithTag:100];
    [button setTitle:dateStr forState:UIControlStateNormal];
    
    //保存数据
    _changeStr = dateStr;
    
    NSLog(@"ahahh");
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {

    //保存数据
    _changeStr = textField.text;
}



@end
