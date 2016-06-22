//
//  JokeViewController.m
//  CXNews
//
//  Created by liyoubing on 16/5/7.
//  Copyright © 2016年 liyoubing. All rights reserved.
//

#import "JokeViewController.h"
#import "InformationModel.h"
#import "JokeCell.h"
#import "SDRefresh.h"
#import "DetailViewController.h"

@interface JokeViewController ()<UITableViewDataSource,UITableViewDelegate,GetResultProtocol> {

    NSMutableArray *_data;
    UITableView *_tableView;
    
    SDRefreshHeaderView *_refreshHeaderView;
    SDRefreshFooterView *_refreshFooterView;
    
    NSInteger _loadTtype;   //0  第一次加载数据  1  下拉   2  上拉
    
}


@end

@implementation JokeViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"段子";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _data = [[NSMutableArray alloc] init];
    
    self.view.backgroundColor = DefaultBgColor;
    
    [self _initSubView];
    
    [self _loadData];
    
    //添加刷新控件
    [self _initRefreshView];
}

- (void)_initSubView {

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-64-30-49) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
}

//添加刷新控件
- (void)_initRefreshView {

    //头
    _refreshHeaderView = [[SDRefreshHeaderView alloc] init];
    [_refreshHeaderView addToScrollView:_tableView];
    //添加下拉刷新事件
    [_refreshHeaderView addTarget:self refreshAction:@selector(loadNewData)];
    
    //尾
    _refreshFooterView = [SDRefreshFooterView refreshView];
    [_refreshFooterView addToScrollView:_tableView];
    //添加事件
    [_refreshFooterView addTarget:self refreshAction:@selector(_loadMoreData)];
    
}

//获取最新数据
- (void)loadNewData {

    _loadTtype = 1;
    
    InformationModel *model = _data[0];
    
    NSDictionary *parames = @{
                              @"Pid":@"11",
                              @"pageSize":@"5",
                              @"Id":model.InformationID,
                              @"pageType":@"0"
                              };

    [CXDataService requestDataWithMethod:@"POST" withParames:parames withURLString:GetNewList withDelegate:self];
    
}

- (void)_loadMoreData {

    _loadTtype = 2;
    
    InformationModel *model = [_data lastObject];
    
    NSDictionary *parames = @{
                              @"Pid":@"11",
                              @"pageSize":@"5",
                              @"Id":model.InformationID,
                              @"pageType":@"1"
                              };
    
    [CXDataService requestDataWithMethod:@"POST" withParames:parames withURLString:GetNewList withDelegate:self];
}

//加载数据
- (void)_loadData {

    NSDictionary *parames = @{@"Pid":@"11",
                              @"pageSize":@"5"};
    [CXDataService requestDataWithMethod:@"POST" withParames:parames withURLString:GetNewList withDelegate:self];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    JokeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"jokeCell"];
    if (cell == nil) {
        cell = [[JokeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"jokeCell"];
    }
    
    InformationModel *model = _data[indexPath.row];
    
    cell.model = model;
    
    return cell;
}

//设置单元格的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    //5 + 5 + 30+ 5 + 20 + 5  + contentHeight
    
    //死循环
//    [tableView cellForRowAtIndexPath:indexPath];
    
    InformationModel *model = _data[indexPath.row];
    
    CGFloat contentHeight = [JokeCell getRemarkHeight:model.remark];
    
    return contentHeight + 70;
    
}

//点击单元格
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DetailViewController *detailCtrl = [[DetailViewController alloc] init];
    detailCtrl.hidesBottomBarWhenPushed = YES;
    detailCtrl.model = _data[indexPath.row];
    [self.navigationController pushViewController:detailCtrl animated:YES];
    
}

#pragma mark - GetResultProtocol
//连接服务器成功
- (void)getNetDataSuccess:(id)result {

    if (![result[@"code"] isEqualToString:@"1000"]) {
        iToast *toast = [[iToast alloc] initWithText:result[@"errorMsg"]];
        [toast show];
        
        return;
    }
    
    //解析数据
    NSArray *jsonArray = result[@"result"];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSDictionary *jsonDic in jsonArray) {
        InformationModel *model = [[InformationModel alloc] initWithJSONDic:jsonDic];
        
        [array addObject:model];    //123456
        
    }
    
    if (_loadTtype == 1) {
        //插入数据
        //1 2 3 4 5 6
        [array addObjectsFromArray:_data]; //123456789 10
        _data = array;
        
    }else if (_loadTtype == 2){
        [_data addObjectsFromArray:array];
    } else {
        //            [_data addObject:model];
        _data = array;
    }
   
    //刷新视图
    [_tableView reloadData];
    
    //关闭视图
    [_refreshHeaderView endRefreshing];
    //关闭视图
    [_refreshFooterView endRefreshing];
    
}

//连接服务器失败
- (void)getNetDataField:(id)result {

    iToast *toast = [[iToast alloc] initWithText:@"网络连接失败！"];
    [toast show];
    
}

@end
