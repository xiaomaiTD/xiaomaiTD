//
//  EntertainmentViewController.m
//  CXNews
//
//  Created by liyoubing on 16/5/7.
//  Copyright © 2016年 liyoubing. All rights reserved.
//

#import "EntertainmentViewController.h"
#import "InformationModel.h"
#import "EnertaimentCell.h"
#import "UIImageView+WebCache.h"
#import "DetailViewController.h"

@interface EntertainmentViewController ()<UITableViewDataSource,UITableViewDelegate,GetResultProtocol> {

    NSMutableArray *_data;
    
    UITableView *_tableView;
}

@end

@implementation EntertainmentViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"娱乐";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = DefaultBgColor;
    
    _data = [[NSMutableArray alloc] init];
    
    //创建子视图
    [self _initTableView];
    
    //加载数据
    [self _loadData];
    
}

- (void)_initTableView {

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-49-30-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    //注册
    [_tableView registerClass:[EnertaimentCell class] forCellReuseIdentifier:@"ECell"];
}

//加载数据
- (void)_loadData {

    NSDictionary *dic = @{@"Pid":@"9"};
    [CXDataService requestDataWithMethod:@"POST" withParames:dic withURLString:GetNewList withDelegate:self];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 150)];
        
        InformationModel *model = _data[indexPath.row];
        NSString *imgURL = [NSString stringWithFormat:@"http:/123.57.246.163:8044%@",model.img];
        [imgView sd_setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[UIImage imageNamed:@"g_01.jpg"]];
        
        [cell.contentView addSubview:imgView];
        
        return cell;
        
    }else {
        EnertaimentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ECell"];
        
        //获取显示的数据
        InformationModel *model = _data[indexPath.row];
        cell.model = model;
        
        return cell;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DetailViewController *detailCtrl = [[DetailViewController alloc] init];
    detailCtrl.hidesBottomBarWhenPushed = YES;
    detailCtrl.model = _data[indexPath.row];
    [self.navigationController pushViewController:detailCtrl animated:YES];
    
}

//设置单元格的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        return 150;
    }
    
    return 100;
}

#pragma mark - GetResultProtocol
- (void)getNetDataSuccess:(id)result {

    //如果返回数据失败
    if (![result[@"code"] isEqualToString:@"1000"]) {
        iToast *itoast = [[iToast alloc] initWithText:result[@"errorMsg"]];
        [itoast show];
        
        return;
    }
    
    //获取result对应的value
    NSArray *jsonArray = result[@"result"];
    for (NSDictionary *jsonDic in jsonArray) {
        InformationModel *model = [[InformationModel alloc] initWithJSONDic:jsonDic];
     
        [_data addObject:model];
    }
    
    //刷新
    [_tableView reloadData];
}

- (void)getNetDataField:(id)result {

    iToast *itoast = [[iToast alloc] initWithText:result[@"网络连接失败！"]];
    [itoast show];
    
}

@end
