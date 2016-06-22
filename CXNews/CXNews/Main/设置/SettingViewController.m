//
//  SettingViewController.m
//  CXNews
//
//  Created by liyoubing on 16/4/26.
//  Copyright © 2016年 liyoubing. All rights reserved.
//

#import "SettingViewController.h"
#import "AboutViewController.h"
#import "FeedBackViewController.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "WeiboSDK.h"

@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate> {

    NSArray *_data;
    UITableView *_tableView;
}

@end

@implementation SettingViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"设置";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _data = @[@"当前版本",
              @"清楚缓存",
              @"关于我们",
              @"联系我们",
              @"意见反馈",
              @"咨询退送"];
    
    //创建子视图
    [self _initSubView];
    
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
     UILabel *label = (UILabel *)[_tableView viewWithTag:1001];
    
     label.text = [self getImgSize];
}

//计算缓存的大小
- (NSString *)getImgSize {
    long long size = 0;
    
    //(1)获取需要计算缓存的路径
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
    
    //(2)计算当前缓存的大小
    NSFileManager *manager = [NSFileManager defaultManager];
    //获取filePath下的所有子路径
    NSArray *pathArray = [manager subpathsAtPath:filePath];
    for (NSString *subPath in pathArray) {
        //<1>拼接路径
        NSString *path = [filePath stringByAppendingPathComponent:subPath];
        //计算文件的大小
        NSDictionary *attribute = [manager attributesOfItemAtPath:path error:nil];
        size += [attribute fileSize];
        
    }
    
    //字节 -> M   1024
    NSString *sizeStr = [NSString stringWithFormat:@"当前的缓存:%0.2fM",size/(1000.0*1000.0)];
    
    return sizeStr;
}

//创建子视图
- (void)_initSubView {

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-64-49) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //关闭滚动
    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
    
    //创建尾部视图
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 120)];
    footerView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = footerView;
    //添加子视图
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 0, 0)];
    titleLabel.textColor = [UIColor darkGrayColor];
    titleLabel.text = @"把畅想未来推荐给好友：";
    [titleLabel sizeToFit];
    [footerView addSubview:titleLabel];
    NSArray *imgArray = @[@"qq_share_app@2x.png",
                          @"qzone_share_app@2x.png",
                          @"sina_share_app@2x.png",
                          @"weixin_share_app@2x.png"
                          ];
    NSArray *titleArray = @[@"QQ好友",
                            @"QQ空间",
                            @"新浪微博",
                            @"微信好友"
                            ];
    CGFloat y = CGRectGetMaxY(titleLabel.frame)+20;
    for (int i=0; i<titleArray.count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor clearColor];
        button.frame = CGRectMake(15+62*i, y, 55, 55);
        [button setImage:[UIImage imageNamed:imgArray[i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        button.imageEdgeInsets = UIEdgeInsetsMake(-15, 0, 0, 0);
        [footerView addSubview:button];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 55-15, 55, 15)];
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor darkGrayColor];
        titleLabel.text = titleArray[i];
        [button addSubview:titleLabel];
    }

}

//按钮的点击事件
- (void)buttonAction:(UIButton *)button {

    if (button.tag == 0) {
        //QQ好友
        //分享跳转URL
        NSString *url = @"http://www.baidu.com/";
        //分享图预览图URL地址
        NSString *previewImageUrl = @"http://www.cxwlbj.com/imgs/logo.jpg";
        QQApiNewsObject *newsObj = [QQApiNewsObject
                                    objectWithURL :[NSURL URLWithString:url]
                                    title: @"畅想新闻"
                                    description :@"这是一个描述"
                                    previewImageURL:[NSURL URLWithString:previewImageUrl]];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
        //将内容分享到qq
        QQApiSendResultCode sent = [QQApiInterface sendReq:req];
        //将内容分享到qzone
//        QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
        
    }else if (button.tag == 1) {
        //QQ空间
        
        //分享跳转URL
        NSString *url = @"http://www.baidu.com/";
        //分享图预览图URL地址
        NSString *previewImageUrl = @"http://www.cxwlbj.com/imgs/logo.jpg";
        QQApiNewsObject *newsObj = [QQApiNewsObject
                                    objectWithURL :[NSURL URLWithString:url]
                                    title: @"畅想新闻"
                                    description :@"这是一个描述"
                                    previewImageURL:[NSURL URLWithString:previewImageUrl]];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
        //将内容分享到qzone
        QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
    }else if (button.tag == 2) {
    
        //创建需要分享的对象
        WBMessageObject *shareObj = [WBMessageObject message];
        shareObj.text = @"畅想新闻";

        //获取分享的图片
        WBImageObject *imgObj = [WBImageObject object];
//        NSString *str = @"http://www.cxwlbj.com/imgs/logo.jpg";
        UIImage *img = [UIImage imageNamed:@"loading@2x.png"];
        imgObj.imageData = UIImagePNGRepresentation(img);

        shareObj.imageObject =imgObj;
        
        WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:shareObj];
        [WeiboSDK sendRequest:request];
    }
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *iden = @"settingCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor darkGrayColor];
    }
    
    if (indexPath.row <= 1) {
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        textLabel.textColor = [UIColor darkGrayColor];
        textLabel.textAlignment = NSTextAlignmentRight;
        textLabel.font = [UIFont systemFontOfSize:10];
        textLabel.tag = 1000+indexPath.row;
        if (indexPath.row == 0) {
            //显示当前的版本号
            //判断是否一样
            NSDictionary *dic = [[NSBundle mainBundle] infoDictionary];
            NSString *version1 = dic[@"CFBundleShortVersionString"];
            textLabel.text = version1;
        }else {
            textLabel.text = [self getImgSize];
        }
        cell.accessoryView = textLabel;
    }else if (indexPath.row == 2) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo@2x.png"]];
        imgView.frame = CGRectMake(0, 0, 23, 23);
        cell.accessoryView = imgView;
    }else if (indexPath.row == 3 || indexPath.row == 4) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else {
        UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 90, 20)];
        sw.transform = CGAffineTransformMakeScale(0.6,0.6);
        sw.onTintColor = [UIColor colorWithRed:23/255.0 green:7/255.0 blue:168/255.0 alpha:1];
        sw.center = CGPointMake(KScreenWidth-CGRectGetWidth(sw.frame), 44-CGRectGetHeight(sw.frame));
        [cell.contentView addSubview:sw];
    }
    
    cell.textLabel.text = _data[indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    //取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 2) {
        //关于我们
        AboutViewController *aboutCtrl = [[AboutViewController alloc] init];
        aboutCtrl.title = @"关于我们";
        aboutCtrl.content = kText_aboutUSText;
        [self.navigationController pushViewController:aboutCtrl animated:YES];
        
    }else if (indexPath.row == 3) {
        //联系我们
        AboutViewController *aboutCtrl = [[AboutViewController alloc] init];
        aboutCtrl.title = @"联系我们";
        aboutCtrl.content = kText_ContactUSText;
        [self.navigationController pushViewController:aboutCtrl animated:YES];
    }else if (indexPath.row == 4) {
        
        //意见反馈
        FeedBackViewController *feedBackCtrl = [[FeedBackViewController alloc] init];
        //隐藏标签栏
        feedBackCtrl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:feedBackCtrl animated:YES];

    }else if (indexPath.row == 1) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否清除缓存" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex == 1) {

        NSFileManager *manager = [NSFileManager defaultManager];
        
        //(1)获取需要计算缓存的路径
        NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
        //获取filePath所有子路径
        //获取filePath下的所有子路径
        NSArray *pathArray = [manager subpathsAtPath:filePath];
        for (NSString *subPath in pathArray) {
            
            NSString *path = [filePath stringByAppendingPathComponent:subPath];
            [manager removeItemAtPath:path error:nil];
            
        }
        
        //重新计算
        UILabel *label = (UILabel *)[_tableView viewWithTag:1001];
        label.text = [self getImgSize];
        
        /*
        //删除图片所在的文件夹
        NSFileManager *manager = [NSFileManager defaultManager];
        BOOL isSuccess = [manager removeItemAtPath:filePath error:nil];
        if (isSuccess) {
            iToast *toast = [[iToast alloc] initWithText:@"清除成功 ..."];
            [toast show];
            
            //重新创建cache文件夹
            [manager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
            
            //重新计算
            UILabel *label = (UILabel *)[_tableView viewWithTag:1001];
            label.text = [self getImgSize];
        }else {
            iToast *toast = [[iToast alloc] initWithText:@"清除失败 ..."];
            [toast show];
        }*/
        
    }
    
}




@end
