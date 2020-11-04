//
//  BaseOrderViewController.m
//  FangXinCai
//
//  Created by ios-1 on 2018/1/12.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "BaseOrderViewController.h"
#import "DetailRecordTableViewCell.h"
#import "MyOrderTableViewCell.h"
#import "OrderDetailViewController.h"

@interface BaseOrderViewController ()

@end

@implementation BaseOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatMainTableView];
}
- (void)loadDatas;
{
    [self.tabDataArr addObjectsFromArray:self.httpDataArr];
    if(self.tabDataArr.count == 0)
    {
        self.Type=TBNODateType;
    }
    [self.tableView reloadData];
}
- (void)creatMainTableView
{
    self.tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight-104);
    self.tableviewstyle = UITableViewStyleGrouped;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MyOrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"OrderCell"];
    
    [self configureNeedShowEmptyDataSetScrollView:self.tableView];
    
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tabDataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderDetailViewController *orderdetail = [[OrderDetailViewController alloc]init];
    [self.navigationController pushViewController:orderdetail animated:YES];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderCell"];
    if(!cell)
    {
        cell = [[MyOrderTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"OrderCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (NSMutableArray*)tabDataArr
{
    if(_tabDataArr == nil)
    {
        _tabDataArr = [NSMutableArray array];
    }
    return _tabDataArr;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
