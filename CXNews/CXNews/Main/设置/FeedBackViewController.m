//
//  FeedBackViewController.m
//  CXNews
//
//  Created by liyoubing on 16/4/27.
//  Copyright © 2016年 liyoubing. All rights reserved.
//

#import "FeedBackViewController.h"

@interface FeedBackViewController () {

    UITextView *_textView;
}

@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //创建子视图
    [self _initSubView];
    
}

//创建子视图
- (void)_initSubView {

    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, KScreenWidth-30, 30)];
    textLabel.text = @"提出您的宝贵意见（500以内）";
    [self.view addSubview:textLabel];
    
    //创建输入框
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(textLabel.frame), KScreenWidth-30, 150)];
    [self.view addSubview:_textView];
    
    //创建按钮
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.frame = CGRectMake(15, CGRectGetMaxY(_textView.frame)+10,  KScreenWidth-30, 35);
    [sendButton setBackgroundImage:[UIImage imageNamed:@"button@2x.png"] forState:UIControlStateNormal];
    [sendButton setTitle:@"提 交" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendButton];
    
    //添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    
    //弹出键盘
    [_textView becomeFirstResponder];
}

//手势的相应事件
- (void)tapAction {

    //收起键盘
    [_textView resignFirstResponder];
}

//发送事件
- (void)sendAction {
    
    //判断是否输入内容
    if (_textView.text.length == 0) {
        //显示提示
        iToast *itoast = [iToast makeText:@"当前没有输入内容"];
        [itoast show];
        return;
    }
    if (_textView.text.length > 500) {
        //显示提示
        iToast *itoast = [iToast makeText:@"当前输入内容超过500"];
        [itoast show];
        return;
    }
    
    //向服务器提交内容
    //（1）获取用户输入的内容
    NSString *text = _textView.text;
    
    //（2）构造URL
    NSString *stringURL = [NSString stringWithFormat:@"%@%@",BaseURL,AddFeedback];
    NSURL *url = [NSURL URLWithString:stringURL];

    //（3）构造request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    //请求方式
    request.HTTPMethod = @"POST";
    //设置请求时间
    request.timeoutInterval = 30;
    
    //json  xml  key1=value1&key2=value2
    //设置请求体
    NSString *bodyString = [NSString stringWithFormat:@"remark=%@",text];
    request.HTTPBody = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    
    //网络加载提示
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    //（4）connection
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        
        if (connectionError != nil) {
            //链接失败
            //提示
            iToast *toast = [[iToast alloc] initWithText:@"请检查网络"];
            [toast show];
            return;
        }
        
        //解析json数据
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

        //判断是否提交成功
        NSString *errorStr = dic[@"errorMsg"];
        if (errorStr.length > 0) {
            //提示
            iToast *toast = [[iToast alloc] initWithText:errorStr];
            [toast show];
        }else {
            //提示
            iToast *toast = [[iToast alloc] initWithText:@"提交成功，我们会考虑采纳"];
            [toast show];
            
            //返回前一个界面
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        //网络加载提示
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
    
}


@end
