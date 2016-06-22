//
//  UserFollowViewController.m
//  CXNews
//
//  Created by liyoubing on 16/5/11.
//  Copyright © 2016年 liyoubing. All rights reserved.
//

#import "UserFollowViewController.h"
#import "InformationModel.h"
#import "RecommendCell.h"
#import "JokeCell.h"
#import "VideoCell.h"
#import "EnertaimentCell.h"
#import "DetailViewController.h"
#import "LoginViewController.h"
#import "UnloginView.h"

@interface UserFollowViewController ()<UITableViewDataSource,UITableViewDelegate,GetResultProtocol,LoginActionDelegate,LoginSuccessProtocol> {

    UITableView *_tableView;
    NSMutableArray *_data;
    UnloginView *_unloginView;
}


@end

@implementation UserFollowViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"用户关注";
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_loadData) name:@"addNewAttation" object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _data = [[NSMutableArray alloc] init];
    
    //创建表视图
    [self _initTableView];
    
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    //判断当前用户是否登录
    if ([ManagerUserInfo shareInstance].model == nil) {
        
        if (_unloginView.superview == nil) {
            [_tableView removeFromSuperview];
            //创建未登录视图
            _unloginView = [[UnloginView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-64-49)];
            _unloginView.messageString = @"当前未登录，无法获取信息";
            _unloginView.delegate = self;
            [self.view addSubview:_unloginView];
        }
        //清空动态数据
        [_data removeAllObjects];
        
    
    }else {
        
        if (_tableView.superview == nil) {
            [self.view addSubview:_tableView];
        }
        
        [self _loadData];
        
    }
    
}

//创建子视图
- (void)_initTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-64-49) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
}

//加载数据
- (void)_loadData {

    NSDictionary *parames = @{@"token":[ManagerUserInfo shareInstance].model.token};
    [CXDataService requestDataWithMethod:@"POST" withParames:parames withURLString:GetMyFollowList withDelegate:self];
    
}

#pragma mark - UITableDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *iden = nil;
    
    //获取数据
    InformationModel *model = _data[indexPath.row];
    //判断数据类型
    if ([model.pid isEqualToString:@"8"]) { //推荐
        
        iden = @"recommendCell";
        
        RecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RecommendCell" owner:self options:nil] lastObject];
        }
        
        //给数据
        cell.model = model;
        
        return cell;
        
    }else if ([model.pid isEqualToString:@"9"]) { //娱乐
        
        iden = @"EnertaimentCell";
        
        EnertaimentCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
        if (cell == nil) {
            cell = [[EnertaimentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        }
        
        cell.model = model;
        
        return cell;
        
    }else if ([model.pid isEqualToString:@"10"]){ //视频
        
        iden = @"VideoCell";
        
        VideoCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
        if (cell == nil) {
            cell = [[VideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        }
        
        cell.model = model;
        
        return cell;
        
    }else { //段子
        
        iden = @"JokeCell";
        
        JokeCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
        if (cell == nil) {
            cell = [[JokeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        }
        cell.model = model;
        return cell;
    }
    
}

//设置单元格的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //获取数据
    InformationModel *model = _data[indexPath.row];
    //判断数据类型
    if ([model.pid isEqualToString:@"8"]) { //推荐
        
        return 200;
        
    }else if ([model.pid isEqualToString:@"9"]) { //娱乐
        
        return 100;
        
    }else if ([model.pid isEqualToString:@"10"]){ //视频
        
        return 220;
        
    }else { //段子
        InformationModel *model = _data[indexPath.row];
        
        CGFloat contentHeight = [JokeCell getRemarkHeight:model.remark];
        
        return contentHeight + 70;
    }
    
}

//单元格的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DetailViewController *detailCtrl = [[DetailViewController alloc] init];
    detailCtrl.model = _data[indexPath.row];
    
    detailCtrl.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:detailCtrl animated:YES];
}

#pragma mark - GetResultProtocol
- (void)getNetDataSuccess:(id)result {

    if (![result[@"code"] isEqualToString:@"1000"]) {
        iToast *itoast = [[iToast alloc] initWithText:result[@"errorMsg"]];
        [itoast show];
        return;
    }
    
    for (NSDictionary *dic in result[@"result"]) {
     
        InformationModel *model = [[InformationModel alloc] initWithJSONDic:dic];
        [_data addObject:model];
    }
    
    [_tableView reloadData];

}

- (void)getNetDataField:(id)result {

    iToast *itoast = [[iToast alloc] initWithText:@"网络连接失败 ..."];
    [itoast show];
}

#pragma mark - 点击登录
- (void)getLoginAction {

    LoginViewController *loginViewCtrl = [[LoginViewController alloc] init];
    loginViewCtrl.delegate = self;
    [self.navigationController pushViewController:loginViewCtrl animated:YES];
}

//#pragma mark - 登录成功
//- (void)loginSuccess {
//
//    [_unloginView removeFromSuperview];
//    
//    [self _loadData];
//    
//}


@end
