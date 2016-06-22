//
//  RecommendViewController.m
//  CXNews
//
//  Created by liyoubing on 16/5/7.
//  Copyright © 2016年 liyoubing. All rights reserved.
//

#import "RecommendViewController.h"
#import "InformationModel.h"
#import "RecommendCell.h"
#import "DetailViewController.h"

@interface RecommendViewController ()<UITableViewDataSource,UITableViewDelegate,GetResultProtocol> {

    NSMutableArray *_data;
    UITableView *_tableView;
}

@end

@implementation RecommendViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"推荐";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = DefaultBgColor;

    _data = [[NSMutableArray alloc] init];
    
    //创建子视图
    [self _initSubView];
    
    //加载数据
    [self _loadData];
}

//创建子视图
- (void)_initSubView {

    //创建tableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-64-49-30) style:UITableViewStylePlain];
    //设置代理
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    //隐藏表视图
    _tableView.hidden = YES;
    
    //设置行高
    _tableView.rowHeight = 200;
    [self.view addSubview:_tableView];
    
}

//加载数据
- (void)_loadData {

    //显示本地数据
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *localDic = [userDefault objectForKey:@"LocalData"];
    if (localDic != nil) {
        
        //显示数据
        //获取数据成功
        //获取result对应的vlaue
        NSArray *jsonArray = localDic[@"result"];
        for (NSDictionary *dic in jsonArray) {
            InformationModel *model = [[InformationModel alloc] initWithJSONDic:dic];
            [_data addObject:model];
        }
        
        _tableView.hidden = NO;
        //刷新界面
        [_tableView reloadData];
        
    }
    
    
    NSDictionary *parames = @{@"Pid":@"8"};
    [CXDataService requestDataWithMethod:@"POST" withParames:parames withURLString:GetNewList withDelegate:self];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *iden = @"RecommendCell";
    
    RecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RecommendCell" owner:self options:nil] lastObject];
    }
    
    InformationModel *model = _data[indexPath.row];
    
    cell.model = model;
    
    return cell;
}

//单元格的点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    //取消选中效果
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DetailViewController *detailCtrl = [[DetailViewController alloc] init];
    detailCtrl.hidesBottomBarWhenPushed = YES;
    //传递model数据
    detailCtrl.model = _data[indexPath.row];
    [self.navigationController pushViewController:detailCtrl animated:YES];
    
}

#pragma mark - GetResultProtocol
//获取数据成功后调用的代理方法
- (void)getNetDataSuccess:(id)result {

    //如果返回数据失败
    if (![result[@"code"] isEqualToString:@"1000"]) {
        iToast *itoast = [[iToast alloc] initWithText:result[@"errorMsg"]];
        [itoast show];
        
        return;
    }
    
//    result
    //将数据保存到本地
//    plist  dic
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:result forKey:@"LocalData"];
    [userDefault synchronize];
    
    
    //获取数据成功
    //获取result对应的vlaue
    [_data removeAllObjects];
    NSArray *jsonArray = result[@"result"];
    for (NSDictionary *dic in jsonArray) {
        InformationModel *model = [[InformationModel alloc] initWithJSONDic:dic];
        [_data addObject:model];
    }
    
    _tableView.hidden = NO;
    //刷新界面
    [_tableView reloadData];
}

//获取数据失败后调用的代理方法
- (void)getNetDataField:(id)result {

    //如果返回数据失败
    iToast *itoast = [[iToast alloc] initWithText:@"网络连接失败"];
    [itoast show];
    
    
}

@end
