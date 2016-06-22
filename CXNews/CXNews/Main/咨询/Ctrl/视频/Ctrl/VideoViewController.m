//
//  VideoViewController.m
//  CXNews
//
//  Created by liyoubing on 16/5/7.
//  Copyright © 2016年 liyoubing. All rights reserved.
//

#import "VideoViewController.h"
#import "InformationModel.h"
#import "VideoCell.h"
#import "DetailViewController.h"

@interface VideoViewController ()<UITableViewDataSource,UITableViewDelegate,GetResultProtocol> {

    NSMutableArray *_data;
    UITableView *_tableView;
}

@end

@implementation VideoViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"视频";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _data = [[NSMutableArray alloc] init];
    
    [self _initSubView];
    
    [self _loadData];
}

- (void)_initSubView {

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-64-30-49) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //设置行高
    _tableView.rowHeight = 220;
    
    [self.view addSubview:_tableView];
    
}

//加载数据
- (void)_loadData {

    NSDictionary *parames = @{@"Pid":@"10"};
    [CXDataService requestDataWithMethod:@"POST" withParames:parames withURLString:GetNewList withDelegate:self];

}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    VideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"videoCell"];
    if (cell == nil) {
        cell = [[VideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"videoCell"];
    }
    
    InformationModel *model = _data[indexPath.row];
    
    cell.model = model;
    
    return cell;
}

//点击单元格的时候调用的代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DetailViewController *detailCtrl = [[DetailViewController alloc] init];
    detailCtrl.hidesBottomBarWhenPushed = YES;
    
    detailCtrl.model = _data[indexPath.row];
    
    [self.navigationController pushViewController:detailCtrl animated:YES];
    
}

#pragma mark - GetResultProtocol
- (void)getNetDataSuccess:(id)result {

    //如果返回数据失败
    if (![result[@"code"] isEqualToString:@"1000"]) {
        iToast *itoast = [[iToast alloc] initWithText:result[@"errorMsg"]];
        [itoast show];
        
        return;
    }
    
    NSArray *jsonArray = result[@"result"];
    
    for (NSDictionary *dic in jsonArray) {
        InformationModel *model = [[InformationModel alloc] initWithJSONDic:dic];
        [_data addObject:model];
    }
    
    //刷新
    [_tableView reloadData];
    
}

- (void)getNetDataField:(id)result {

}

@end
