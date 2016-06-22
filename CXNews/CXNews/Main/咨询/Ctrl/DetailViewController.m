//
//  DetailViewController.m
//  CXNews
//
//  Created by liyoubing on 16/5/10.
//  Copyright © 2016年 liyoubing. All rights reserved.
//

#import "DetailViewController.h"
#import "InformationModel.h"
#import "ImageListController.h"
#import "CXNewNavgationController.h"
#import "LoginViewController.h"

@interface DetailViewController ()<UIWebViewDelegate,UIActionSheetDelegate,LoginSuccessProtocol,GetResultProtocol> {

    UIWebView *_webView;
    NSString *_htmlSource;
}

@end

@implementation DetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    //设置标题
    self.title = _model.title;
    
    //创建子视图
    [self _initSubView];
    
    //如果是视频
    if ([_model.pid isEqualToString:@"10"]) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_model.url]];
        [_webView loadRequest:request];
    }else {
    
        //加载数据
        [self _loadData];
    }
    
    //创建导航向的按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"more@2x.png"] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 36, 10);
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
}

//导航栏右侧的点击事件
- (void)buttonAction {

    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"收藏新闻" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"收藏本地" otherButtonTitles:@"用户关注", nil];
    [actionSheet showInView:self.view];
    
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    NSLog(@"buttonIndex:%ld",buttonIndex);
    
    if (buttonIndex == 0) {
        //收藏本地
        //将数据保存到本地
        [self saveData];
        
    }else if(buttonIndex == 1) {
        //关注
        
        [self attentionAction];
        
    }
    
}

//关注
- (void)attentionAction {

    //判断当前是否登录
    if ([ManagerUserInfo shareInstance].model == nil) {
        //说明未登录
        //跳转到登录界面
        LoginViewController *loginCtrl = [[LoginViewController alloc] init];
        loginCtrl.delegate = self;
        [self.navigationController pushViewController:loginCtrl animated:YES];
        
    }else { //已经登录
        //执行关注操作
        [self getAttention];
    }
    
}

//执行关注操作
- (void)getAttention {

    //AddFollow
    NSDictionary *parames = @{@"token":[ManagerUserInfo shareInstance].model.token,
                              @"newid":_model.InformationID};
    //http://123.57.246.163:8044/api/AddFollow.aspx
    //http://123.57.246.163:8044/api/AddFollow.aspx
    [CXDataService requestDataWithMethod:@"POST" withParames:parames withURLString:AddFollow withDelegate:self];
    
}

//将数据收藏到本地
- (void)saveData {
    
    //如果是视频资源
    NSMutableDictionary *saveDic = nil;
    
    if (![_model.pid isEqualToString:@"10"]) {
        //model
        saveDic = [_model.modelInfo mutableCopy];
        //_htmlSource
        [saveDic setObject:_htmlSource forKey:@"htmlSource"];
    }else {
        saveDic = [_model.modelInfo mutableCopy];
    }
    
    //将数据写入本地
    
    //（1）获取本地已经收藏的数据
    NSArray *newsArray = [[NSArray alloc] initWithContentsOfFile:SavePath];
    
    if (newsArray.count == 0) { //没有收藏的数据
        newsArray = @[saveDic];
        BOOL isSuccess = [newsArray writeToFile:SavePath atomically:YES];
        if (isSuccess) {
            iToast *itoast = [[iToast alloc] initWithText:@"收藏成功!"];
            [itoast setDuration:2000];
            [itoast show];
            
            //发送通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AddData" object:self];
            
        }else {
            iToast *itoast = [[iToast alloc] initWithText:@"收藏失败!"];
            [itoast setDuration:2000];
            [itoast show];
        }
    }else { //有收藏的数据
        
        //newsArray [dic dic dic]
        //通过newid搜索
        //谓词
        //01 创建谓词
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"newid = %@",_model.newid];
        NSArray *resultArray = [newsArray filteredArrayUsingPredicate:predicate];
        if (resultArray.count == 0) {
            //（1）如果该新闻没有被收藏
            //收藏 dic 插入到已有的前面
            //newsArray  已经收藏的数据  需要加入的数据saveDic
//            [[newsArray mutableCopy] insertObject:saveDic atIndex:0];
            NSMutableArray *mutArray = [[NSMutableArray alloc] initWithArray:newsArray];
            [mutArray insertObject:saveDic atIndex:0];
            
            //将数据写入本地
            BOOL isSuccess = [mutArray writeToFile:SavePath atomically:YES];
            if (isSuccess) {
                iToast *itoast = [[iToast alloc] initWithText:@"收藏成功!"];
                [itoast setDuration:2000];
                [itoast show];
                
                //发送通知
                [[NSNotificationCenter defaultCenter] postNotificationName:@"AddData" object:self];
            }else {
                iToast *itoast = [[iToast alloc] initWithText:@"收藏失败!"];
                [itoast setDuration:2000];
                [itoast show];
            }
            
        }else {
            //（2）如果该新闻已经被收藏了
            iToast *itoast = [[iToast alloc] initWithText:@"该新闻已经被收藏，不可以重复收藏!"];
            [itoast setDuration:2000];
            [itoast show];
        }
    }
}

//创建子视图
- (void)_initSubView {

    //创建网页
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-64)];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    
}

//加载数据
- (void)_loadData {

    if (_model == nil) {
        return;
    }
    
    //（1）构造URL
    NSString *urlString = GetNewInfo(_model.newid);
    NSURL *url = [NSURL URLWithString:urlString];
    
    //(2)request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.timeoutInterval = 30;
    request.HTTPMethod = @"GET";
    

    //（3）connection
    //
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if (connectionError != nil) {
            iToast *itoast = [[iToast alloc] initWithText:@"网络连接失败 ..."];
            [itoast show];
        }else {
        
            //解析数据
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSLog(@"%@",jsonDic);
            
            //获取newid对应的value （Dic）
            //title ptime body source img
            
            //获取数据
            NSDictionary *newDic = jsonDic[_model.newid];
            //（1）标题
            NSString *title = newDic[@"title"];
            //（2）时间
            NSString *time = newDic[@"ptime"];
            //（3）主体数据
            NSString *body = newDic[@"body"];
            //（4）source
            NSString *source = newDic[@"source"];
            //（5）图片
            NSArray *imgArray = newDic[@"img"];
            
            //遍历图片替换body中的<!--IMG#2-->
            //<img src="url"/>
            for (NSDictionary *imgDic in imgArray) {
                //获取替换的内容
                NSString *src = imgDic[@"src"];
                //转换
//                <p align="center"><img src="url"></p>
                src = [NSString stringWithFormat:@"<p align=\"center\"><img src=\"%@\"/></p>",src];
                
                //获取需要被替换的内容
                NSString *ref = imgDic[@"ref"];
                
                //替换数据
                body = [body stringByReplacingOccurrencesOfString:ref withString:src];
            }
            
            //加载html模板
            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"news" ofType:@"html"];
            NSString *htmlStr = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
            //%@%@%@%@
            //替换数据
            _htmlSource = [NSString stringWithFormat:htmlStr,title,time,body,source];
            
            //将数据交给webView显示
            NSURL *baseURL = [[NSBundle mainBundle] resourceURL];
            [_webView loadHTMLString:_htmlSource baseURL:baseURL];
            
        }
        
    }];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *urlString = [request.URL absoluteString];
    
    //判断是否是点击的图片
    if ([urlString hasPrefix:@"click:"]) {
        
        //（1）截取字符串
        NSString *imgURL = [urlString substringFromIndex:6];
        //（2）获取每一个图片的URL
        NSMutableArray *imgArray = [[imgURL componentsSeparatedByString:@";"] mutableCopy];
        
        //123456789  // 8 123456789   2 123456789
        
        //（3）获取点击的图片的url
        NSString *clickURL = imgArray[0];
        
        //（4）移除第一个元素
        [imgArray removeObjectAtIndex:0];
        
        //（4）获取点击的下标
        NSInteger index = [imgArray indexOfObject:clickURL];
        
        //创建控制器
        ImageListController *listCtrl = [[ImageListController alloc] init];
        CXNewNavgationController *navCtrl = [[CXNewNavgationController alloc] initWithRootViewController:listCtrl];
        
        //传递数据
        listCtrl.selectIndex = index;
        listCtrl.imgArray = imgArray;
        
        //设置是模态
        listCtrl.isModal = YES;
        
        [self presentViewController:navCtrl animated:YES completion:nil];
        
        
    }

    
    return YES;
}

//登录成功后调用的代理方法
- (void)loginSuccess {

    //执行关注的操作
    [self getAttention];
    
    
}

#pragma mark - GetResultDelegate
- (void)getNetDataSuccess:(id)result {

    if ([result[@"code"] isEqualToString:@"1000"]) {
        iToast *itoast = [[iToast alloc] initWithText:@"关注成功!"];
        [itoast show];
        
        //发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"addNewAttation" object:self];
        
    }else {
        iToast *itoast = [[iToast alloc] initWithText:result[@"errorMsg"]];
        [itoast setDuration:2000];
        [itoast show];
    }
    
}

- (void)getNetDataField:(id)result {
    iToast *itoast = [[iToast alloc] initWithText:@"网络连接失败 ..."];
    [itoast setDuration:2000];
    [itoast show];
}


@end
