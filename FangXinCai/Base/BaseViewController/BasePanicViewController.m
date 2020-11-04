//
//  BasePanicViewController.m
//  FangXinCai
//
//  Created by ios-1 on 2018/1/22.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "BasePanicViewController.h"
#import "DetailRecordTableViewCell.h"
#import "PanicBuyingTableViewCell.h"
#import "OrderDetailViewController.h"
#import "ShopDetailViewController.h"
@interface BasePanicViewController ()

@end

@implementation BasePanicViewController

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
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PanicBuyingTableViewCell" bundle:nil] forCellReuseIdentifier:@"PanicCell"];
    
    [self configureNeedShowEmptyDataSetScrollView:self.tableView];
    
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tabDataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    OrderDetailViewController *orderdetail = [[OrderDetailViewController alloc]init];
//    [self.navigationController pushViewController:orderdetail animated:YES];
    
    ShopDetailViewController *shopdetail = [[ShopDetailViewController alloc]init];
    [self.navigationController pushViewController:shopdetail animated:YES];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PanicBuyingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PanicCell"];
    if(!cell)
    {
        cell = [[PanicBuyingTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"PanicCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.shopName.text = [NSString stringWithFormat:@"生菜%zd",self.index];
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
