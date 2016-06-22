//
//  PersonalViewController.m
//  CXNews
//
//  Created by liyoubing on 16/4/26.
//  Copyright © 2016年 liyoubing. All rights reserved.
//

#import "PersonalViewController.h"
#import "UnloginView.h"
#import "LoginViewController.h"
#import "ManagerUserInfo.h"
#import "MyTableView.h"


@interface PersonalViewController ()<LoginActionDelegate,UIAlertViewDelegate,GetResultProtocol> {

    UnloginView *_unloginView;
    MyTableView *_tableView;
    UIImageView *_bgImgView;
}

@end

@implementation PersonalViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"我的";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    [self _initSubView];
}

- (void)_initSubView {

    //当前界面可能显示两种视图
    //由当前用户是否登录决定
    //属性列表
    //判断当前用户是否登录
    //    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:LoginMessage];
    ManagerUserInfo *manager = [ManagerUserInfo shareInstance];
    if (manager.model == nil) { //当前用户未登录
        
        if (_unloginView.superview == nil) {
            
            [_tableView removeObserver:self forKeyPath:@"contentOffset"];
            
            [_tableView removeFromSuperview];
            
            [_bgImgView removeFromSuperview];
            self.navigationItem.rightBarButtonItem = nil;
            
            //当前界面显示未登录视图
            _unloginView = [[UnloginView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-64-49)];
            //设置代理
            _unloginView.delegate = self;
            [self.view addSubview:_unloginView];
        }
    
    }else { //当前是已经登录的状态
        //（1）移除登录提示视图
        [_unloginView removeFromSuperview];
        
        //（2）创建显示用户信息的视图
        [self _initTableView];
        
        //（3）创建注销按钮
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注销" style:UIBarButtonItemStylePlain target:self action:@selector(logoutAction)];
    }
}

- (void)_initTableView {

    if (_bgImgView.superview == nil) {
        _bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 150)];
        _bgImgView.image = [UIImage imageNamed:@"my_bj@2x.png"];
        [self.view addSubview:_bgImgView];
    }
    
    //限制创建一个视图
    if (_tableView.superview == nil) {
        _tableView = [[MyTableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-64-49) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_tableView];
        
        //添加监听
        [_tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }
    
    //传递数据
    _tableView.model = [ManagerUserInfo shareInstance].model;
    [_tableView reloadData];
}

//视图滚动的时候出发的方法
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {

    NSValue *value = change[@"new"];
    CGPoint contentoffset = [value CGPointValue];
    
    CGFloat offsetY = contentoffset.y;
    
    if (offsetY<=0) { //放大
        
        //放大之前  kW  150
        //放大之后  X  150+|offsetY|

        CGFloat Width = KScreenWidth*(150+ABS(offsetY))/150.0;
        
        _bgImgView.frame = CGRectMake((KScreenWidth-Width)/2.0, 0, Width, 150+ABS(offsetY));
        
    }else { //上推
    
        _bgImgView.top = -offsetY;
    }
    
    
    
}

//注销按钮的点击事件
- (void)logoutAction {

    //创建提示视图
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否注销当前用户" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 100;
    [alertView show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex == 1 && alertView.tag == 100) {
        
        //1.执行注销操作
        /*
        //（1）构造URL
        NSString *urlString = [NSString stringWithFormat:@"%@%@",BaseURL,LoginOutUser];
        NSURL *url = [NSURL URLWithString:urlString];
        
        //（2）构造request
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        request.HTTPMethod = @"POST";
        request.timeoutInterval = 30;
        
        //请求体
        ManagerUserInfo *manager = [ManagerUserInfo shareInstance];
        NSString *bodyStr = [NSString stringWithFormat:@"token=%@",manager.model.token];
        request.HTTPBody = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
            
            if (connectionError == nil) {
                //链接服务器成功
                //获取服务器返回的数据
                NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                if ([jsonDic[@"code"] isEqualToString:@"1000"]) {
                    
                    //用户选择的是强行推注
                    [ManagerUserInfo shareInstance].model = nil;
                    //刷新界面
                    [self _initSubView];
                }else {
                    //注销失败
                    //创建提示视图
                    //创建提示视图
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"注销失败，是否强行注销" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    alertView.tag = 102;
                    [alertView show];
                    
                }
                
                
            }else {
                //链接服务器失败
                //创建提示视图
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"由于网络问题，连接服务器失败，是否强行注销" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alertView.tag = 101;
                [alertView show];
            }
            
        }];*/
        
        //请求体
        ManagerUserInfo *manager = [ManagerUserInfo shareInstance];
        NSDictionary *parames = @{@"token":manager.model.token};
        
        [CXDataService requestDataWithMethod:@"POST" withParames:parames withURLString:LoginOutUser withDelegate:self];
        
        
        
    }else if (buttonIndex == 1 && alertView.tag == 101) {
        //用户选择的是强行推注
        [ManagerUserInfo shareInstance].model = nil;
        //刷新界面
        [self _initSubView];
    }else if (buttonIndex == 1 && alertView.tag == 102) {
        //用户选择的是强行推注
        [ManagerUserInfo shareInstance].model = nil;
        //刷新界面
        [self _initSubView];
    }
    
}


#pragma mark - UnLoginDelegate
- (void)getLoginAction {

    //进入登录界面
    LoginViewController *loginCtrl = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:loginCtrl animated:YES];
}

#pragma mark - 网络请求后调用的代理方法
- (void)getNetDataSuccess:(id)result {

    //链接服务器成功
    
    if ([result[@"code"] isEqualToString:@"1000"]) {
        
        //用户选择的是强行推注
        [ManagerUserInfo shareInstance].model = nil;
        //刷新界面
        [self _initSubView];
    }else {
        //注销失败
        //创建提示视图
        //创建提示视图
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"注销失败，是否强行注销" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 102;
        [alertView show];
        
    }
}

- (void)getNetDataField:(id)result {
    //创建提示视图
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"由于网络问题，连接服务器失败，是否强行注销" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 101;
    [alertView show];
}

@end
