//
//  UserCollectionViewController.m
//  CXNews
//
//  Created by liyoubing on 16/5/11.
//  Copyright © 2016年 liyoubing. All rights reserved.
//

#import "UserCollectionViewController.h"
#import "InformationModel.h"
#import "RecommendCell.h"
#import "JokeCell.h"
#import "EnertaimentCell.h"
#import "VideoCell.h"
#import "DetailViewController.h"

@interface UserCollectionViewController ()<UITableViewDataSource,UITableViewDelegate> {

    NSArray *_dataList;
    UITableView *_tableView;
}

@end

@implementation UserCollectionViewController

- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"本地收藏";
        
        //添加通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_loadData) name:@"AddData" object:nil];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];


    
    //创建子视图
    [self _initTableView];
    
    [self _loadData];
    
}

//创建子视图
- (void)_initTableView {

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-64-49) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    _tableView.tableFooterView = [[UIView alloc] init];
    
}

//获取本地收藏的数据
- (void)_loadData {

    NSArray *dataArray = [[NSArray alloc] initWithContentsOfFile:SavePath];
    //如果有数据
    if (dataArray.count > 0) {
        //获取收藏数据
        NSMutableArray *modelArray = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in dataArray) {
            //创建model
            InformationModel *model = [[InformationModel alloc] initWithJSONDic:dic];
            [modelArray addObject:model];
        }
        
        _dataList = modelArray;
        
        if (_tableView.hidden) {
            _tableView.hidden = NO;
        }
        
        if (_tableView.superview == nil) {
            [self.view addSubview:_tableView];
        }
        
        //刷新界面
        [_tableView reloadData];
        
    }else {
    
        //移除表视图
        [_tableView removeFromSuperview];
        _dataList = nil;
        
        //提示
        iToast *itoast = [[iToast alloc] initWithText:@"当前没有收藏的数据"];
        [itoast show];
        
    }

}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *iden = nil;
    
    //获取数据
    InformationModel *model = _dataList[indexPath.row];
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
    InformationModel *model = _dataList[indexPath.row];
    //判断数据类型
    if ([model.pid isEqualToString:@"8"]) { //推荐
        
        return 200;

    }else if ([model.pid isEqualToString:@"9"]) { //娱乐
        
        return 100;
        
    }else if ([model.pid isEqualToString:@"10"]){ //视频
        
        return 220;
        
    }else { //段子
        InformationModel *model = _dataList[indexPath.row];
        
        CGFloat contentHeight = [JokeCell getRemarkHeight:model.remark];
        
        return contentHeight + 70;
    }
    
}

//单元格的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    DetailViewController *detailCtrl = [[DetailViewController alloc] init];
    detailCtrl.model = _dataList[indexPath.row];
    
    detailCtrl.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:detailCtrl animated:YES];
}

//表视图编辑模式
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    NSLog(@"%ld",indexPath.row);
    
    //（1）获取数据
    NSMutableArray *mutArray = [_dataList mutableCopy];
    //（2）删除动态数据
    [mutArray removeObjectAtIndex:indexPath.row];
    
    //（3）替换本地数据
    //数组  dic
    NSMutableArray *dicArray = [[NSMutableArray alloc] init];
    for (InformationModel *model in mutArray) {
        [dicArray addObject:model.modelInfo];
    }
    
    BOOL isSuccess = [dicArray writeToFile:SavePath atomically:YES];
    if (isSuccess) {
        iToast *itoast = [[iToast alloc] initWithText:@"删除成功 ..."];
        [itoast show];
        
        if (mutArray.count == 0) {
            _tableView.hidden = YES;
        }else {
            _tableView.hidden = NO;
        }
        
        _dataList = mutArray;
        [_tableView reloadData];
        
    }else {
        iToast *itoast = [[iToast alloc] initWithText:@"删除失败 ..."];
        [itoast show];
    }
    
    
    
}




@end
