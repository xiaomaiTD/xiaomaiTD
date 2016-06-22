
//
//  MyTableView.m
//  CXNews
//
//  Created by liyoubing on 16/5/6.
//  Copyright © 2016年 liyoubing. All rights reserved.
//

#import "MyTableView.h"
#import "UserModel.h"
#import "UIView+ViewController.h"
#import "iToast.h"
#import "MyCell.h"
#import "ChangeMessageController.h"
#import "UIButton+WebCache.h"

@interface MyTableView ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate> {

    UILabel *_nickLabel;
    UIImageView *_vipImg;
    UILabel *_contentLabel;
    UIButton *_userButton;
    
    NSArray *_data;
}

@end

@implementation MyTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {

    self = [super initWithFrame:frame style:style];
    if (self) {
        
        //设置代理
        self.dataSource = self;
        self.delegate = self;
        
        //取消分割线
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        //创建头视图
        [self _initHeaderView];
        
    }
    return self;
}

- (void)_initHeaderView {

    //(1)创建头视图
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 200)];
    headerView.backgroundColor = [UIColor clearColor];
    self.tableHeaderView = headerView;
    
    //（2）创建显示用户头像等信息的视图
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, headerView.height-50, KScreenWidth, 50)];
    bottomView.backgroundColor = DefaultBgColor;
    [headerView addSubview:bottomView];
    
    //（3）创建用户头像
    _userButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _userButton.frame = CGRectMake(10, headerView.height-80-5, 80, 80);
    _userButton.layer.cornerRadius = _userButton.width/2.0;
    _userButton.layer.masksToBounds = YES;
    [_userButton setImage:[UIImage imageNamed:@"userImg_default@2x.jpg"] forState:UIControlStateNormal];
    [_userButton addTarget:self action:@selector(userButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:_userButton];
    
    //（4）创建显示昵称
    _nickLabel = [[UILabel alloc] initWithFrame:CGRectMake(_userButton.right+10, 5, 0, 0)];
    _nickLabel.font = [UIFont boldSystemFontOfSize:15];
    [bottomView addSubview:_nickLabel];
    UIControl *tapCtrl = [[UIControl alloc] initWithFrame:CGRectMake(_userButton.right+10, 5, 50, 20)];
    tapCtrl.backgroundColor = [UIColor clearColor];
    [tapCtrl addTarget:self action:@selector(changeNickNameAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:tapCtrl];
    
    
    //（5）创建显示VIP的视图
    _vipImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vip@2x.png"]];
    _vipImg.frame = CGRectMake(0, 0, 10.5, 10.5);
    [bottomView addSubview:_vipImg];
    
    //（6）创建显示用户详情的视图
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nickLabel.left, _nickLabel.bottom+5, 200, 15)];
    _contentLabel.textColor = [UIColor grayColor];
    _contentLabel.font = [UIFont systemFontOfSize:12];
    [bottomView addSubview:_contentLabel];
    
}

- (void)setModel:(UserModel *)model {

    _model = model;
    
    //设置用户的头像
    //如果有头像
    if (model.headImg.length > 0) {
        
        NSString *imgURL = [NSString stringWithFormat:@"http:/123.57.246.163:8044%@",model.headImg];
        [_userButton sd_setImageWithURL:[NSURL URLWithString:imgURL] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"userImg_default@2x.jpg"]];
    }
    
    
    //设置显示的数据
    _nickLabel.text = _model.nickName;
    [_nickLabel sizeToFit];
    
    //设置vip的布局
    _vipImg.left = _nickLabel.right;
    _vipImg.top = _nickLabel.top;
    
    //设置用户详情
    NSString *sex = @"保密";
    if ([_model.sex integerValue] == 0) {
        sex = @"男";
    }else if ([_model.sex integerValue] == 1) {
        sex = @"女";
    }
    
    //获取用户的年龄
    NSString *birthdayStr = _model.birthDayString;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:birthdayStr];
    NSTimeInterval time = [date timeIntervalSinceNow];
    int age = - (int)time/(60*60*24*365);
    
    _contentLabel.text = [NSString stringWithFormat:@"%@ %d %@",sex,age,_model.address];
    _contentLabel.top =  _nickLabel.bottom+5;
    
    //设置数据
    NSString *name = [NSString stringWithFormat:@"姓名：%@",_model.trueName];
    NSString *birthday = [NSString stringWithFormat:@"生日：%@",_model.birthDayString];
    NSString *sexStr = [NSString stringWithFormat:@"性别：%@",sex];
    NSString *phoneNum = [NSString stringWithFormat:@"电话：%@",_model.tel];
    NSString *address = [NSString stringWithFormat:@"地址：%@",model.address];
    NSString *changePass = @"修改密码";
    _data = @[name,birthday,sexStr,phoneNum,address,changePass];
    
}


//用户头像的点击事件
- (void)userButtonAction {

    //创建提示框
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"提示" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"调用本地摄像头" otherButtonTitles:@"访问本地相册", nil];
    [actionSheet showInView:self.viewController.view];
    
}

//修改昵称
- (void)changeNickNameAction {

    //创建修改信息的控制器
    ChangeMessageController *messageCtrl = [[ChangeMessageController alloc] init];
    
    //传递数据
    messageCtrl.dataStr = _model.nickName;
    
    //隐藏标签栏
    messageCtrl.hidesBottomBarWhenPushed = YES;
    messageCtrl.index = 6;
    [self.viewController.navigationController pushViewController:messageCtrl animated:YES];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    MyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[MyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.content = _data[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    //创建修改信息的控制器
    ChangeMessageController *messageCtrl = [[ChangeMessageController alloc] init];
    
    //传递数据 
    NSArray *array = [_data[indexPath.row] componentsSeparatedByString:@"："];
    NSString *str = [array lastObject];
    messageCtrl.dataStr = str;

    //隐藏标签栏
    messageCtrl.hidesBottomBarWhenPushed = YES;
    messageCtrl.index = indexPath.row;
    [self.viewController.navigationController pushViewController:messageCtrl animated:YES];
    
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    UIImagePickerController *imgPickerCtrl = [[UIImagePickerController alloc] init];
    
    //设置编辑图片
    imgPickerCtrl.allowsEditing = YES;
    
    //设置代理
    imgPickerCtrl.delegate = self;
    
    //设置媒体类类型：
    /*
     @"public.image":图片 默认的
     @“public.movie”：视频
     */
//    imgPickerCtrl.mediaTypes = @[@"public.image"];

    if (buttonIndex == 0) {
        
        //判断当前设置是否有摄像头
        BOOL isAvailable = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
        if (!isAvailable) {
            
            iToast *itoast = [[iToast alloc] initWithText:@"当前无可用摄像头"];
            [itoast show];
            
            return;
        }
        
        //设置资源类型（相册集、摄像头、相册库）
        imgPickerCtrl.sourceType = UIImagePickerControllerSourceTypeCamera;
        
    }else if (buttonIndex == 1) {
        imgPickerCtrl.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }else {
        return;
    }
    
    [self.viewController presentViewController:imgPickerCtrl animated:YES completion:nil];
}

#pragma mark - UIImagePickerCtrl
//这个代理方式只可以获取原图
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
//
//    NSLog(@"imagePickerController");
//    
//    //获取选择的图片
//    UIImage *img = info[UIImagePickerControllerOriginalImage];
//    
//    //设置给按钮显示
//    [_userButton setImage:img forState:UIControlStateNormal];
//    
//    //关闭当前的界面
//    [picker dismissViewControllerAnimated:YES completion:nil];
//    
//}

//获取编辑后的图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {

    //设置给按钮显示
//    [_userButton setImage:image forState:UIControlStateNormal];

    //（1）关闭当前的界面
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    //（2）将用户选择的图片传递给服务器
    //<1>构造URL
    NSString *stringURL = [NSString stringWithFormat:@"%@%@",BaseURL,UpHeading];
    NSURL *url = [NSURL URLWithString:stringURL];
    
    //<2>构造request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 30;
    
    //将图片转换成data
    //方式一：
    NSData *imgData = UIImagePNGRepresentation(image);
    //方式二：
//    NSData *imgData = UIImageJPEGRepresentation(image, .2);
    NSDictionary *parames = @{
                              @"token":[ManagerUserInfo shareInstance].model.token,
                              @"headimg":imgData
                              };
    //设置请求头
    [request setValue:@"multipart/form-data, boundary=cxwl" forHTTPHeaderField:@"Content-type"];
    //设置请求体
    request.HTTPBody = [self getDataWithParames:parames];
    
    //（3）connection
    //UI修改
    self.viewController.title = @"正在上传头像 ...";
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        //UI修改
        self.viewController.title = @"我的";
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        if (connectionError == nil) {
            //服务器响应成功
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            if ([jsonDic[@"code"] isEqualToString:@"1000"]) {
                //修改成功
                iToast *toast = [[iToast alloc] initWithText:@"修改头像成功！"];
                [toast show];
                
                //获取用户的model
                NSArray *resultArray = jsonDic[@"result"];
                NSDictionary *dic = resultArray[0];
                UserModel *model = [[UserModel alloc] initWithJSONDic:dic];
                
                //修改本地保存的数据
                ManagerUserInfo *manager = [ManagerUserInfo shareInstance];
                manager.model = model;
                
                //修改显示的头像
                [_userButton setImage:image forState:UIControlStateNormal];
                
            }else {
                iToast *toast = [[iToast alloc] initWithText:jsonDic[@"errorMsg"]];
                [toast show];
            }
            
        }else {
            //服务器响应失败
            iToast *toast = [[iToast alloc] initWithText:@"网络链接失败，稍后重试"];
            [toast show];
        }
        
    }];
}

//将图片参数类型的字典转换成data
- (NSData *)getDataWithParames:(NSDictionary *)parames {
    
    NSMutableData *data = [[NSMutableData alloc] init];
    
    //遍历字典
    for (NSString *key in parames) {
        //获取对应的value  string  data
        id value = parames[key];
        //判断数据类型
        if ([value isKindOfClass:[NSData class]]) {
            //分割线 --cxwl
            [data appendData:[@"--cxwl\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            //添加参数
            NSString *keyStr = [NSString stringWithFormat:@"content-disposition:form-data;name=\"%@\";filename=\"img.png\" \r\n",key];
            [data appendData:[keyStr dataUsingEncoding:NSUTF8StringEncoding]];
            [data appendData:[@"Content-Type:image/png \r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            //拼接换行
            [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            //拼接图片data
            [data appendData:value];
            //拼接换行
            [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
        }else {
            //如果是token的时候
            //分割线 --cxwl
            [data appendData:[@"--cxwl\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            NSString *keyStr = [NSString stringWithFormat:@"content-disposition:form-data; name=\"%@\"\r\n",key];
            [data appendData:[keyStr dataUsingEncoding:NSUTF8StringEncoding]];
            //拼接换行
            [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            //拼接数据
            [data appendData:[value dataUsingEncoding:NSUTF8StringEncoding]];
            //拼接换行
            [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
    }
    
    
    //标记结束
    [data appendData:[@"--cxwl--" dataUsingEncoding:NSUTF8StringEncoding]];

    return data;
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {

    //关闭视图
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSLog(@"取消");
}


@end
