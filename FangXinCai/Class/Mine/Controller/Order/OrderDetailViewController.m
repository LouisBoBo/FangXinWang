//
//  OrderDetailViewController.m
//  FangXinCai
//
//  Created by ios-1 on 2018/1/15.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderShopTableViewCell.h"
#import "MyOrderTabViewController.h"
#import "OrderShopDetailTableViewCell.h"
#import "OrderShopHeadView.h"
#import "OrderShopFootView.h"
@interface OrderDetailViewController ()
@property (nonatomic , strong) OrderShopHeadView *headView;
@property (nonatomic , strong) OrderShopFootView *footView;
@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    //隐藏上下拉刷新
    self.tableView.mj_footer.hidden = YES;
    self.tableView.mj_header.hidden = YES;
    
    [self creatData];
    [self creatMainTableView];
    [self creatOrderFootView];
}
- (void)creatData
{
    NSArray *arr = @[@"",@""];
    [self.tabDataArr addObjectsFromArray:arr];
    
    [self.orderDic setValue:@"67890745678jhghj" forKey:@"orderCode"];
    [self.orderDic setValue:@"2018-1-14" forKey:@"orderTime"];
    [self.orderDic setValue:@"微信支付" forKey:@"paystyle"];
    [self.orderDic setValue:@"及时送货" forKey:@"message"];
    
    [self.payDic setValue:@"458" forKey:@"orderMoney"];
    [self.payDic setValue:@"10" forKey:@"Discount"];
    [self.payDic setValue:@"10" forKey:@"freight"];
    [self.payDic setValue:@"100" forKey:@"integral"];
    
}
- (void)creatMainTableView
{
    self.tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight-64-50);
    self.tableviewstyle = UITableViewStyleGrouped;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = self.headView;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderShopTableViewCell" bundle:nil] forCellReuseIdentifier:@"OrderShopCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderShopDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"ShopDetailCell"];
    
    [self.view addSubview:self.tableView];
}

//处理订单的视图
- (void)creatOrderFootView
{
    [self.view addSubview:self.footView];
    self.footView.orderHandleBlock = ^(NSString *text) {
        NSLog(@"&&&&&&&=%@",text);
    };
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tabDataArr.count + 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row +1 > self.tabDataArr.count)
    {
        return 150;
    }
    return 80;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row +1 > self.tabDataArr.count)
    {
        OrderShopDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopDetailCell"];
        if(!cell)
        {
            cell = [[OrderShopDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ShopDetailCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if(indexPath.row +1 == self.tabDataArr.count+2)
        {
            [cell refreshPayData:self.payDic];
        }else{
            [cell refreshOrderData:self.orderDic];
        }
        return cell;
    }else{
        OrderShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderShopCell"];
        if(!cell)
        {
            cell = [[OrderShopTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"OrderShopCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
}

- (NSMutableArray*)tabDataArr
{
    if(_tabDataArr == nil)
    {
        _tabDataArr = [NSMutableArray array];
    }
    return _tabDataArr;
}
- (NSMutableDictionary*)orderDic
{
    if(_orderDic == nil)
    {
        _orderDic = [NSMutableDictionary dictionary];
    }
    return _orderDic;
}
- (NSMutableDictionary*)payDic
{
    if(_payDic == nil)
    {
        _payDic = [NSMutableDictionary dictionary];
    }
    return _payDic;
}
- (UIView*)headView
{
    if(_headView == nil)
    {
        _headView = [[OrderShopHeadView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 180)];
    }
    return _headView;
}
- (UIView*)footView
{
    if(_footView == nil)
    {
        _footView = [[OrderShopFootView alloc]initWithFrame:CGRectMake(0, KScreenHeight-50-64, kScreenWidth, 50)];
    }
    return _footView;
}

- (void)backBtnClicked
{
    if([self.comefrom isEqualToString:@"支付"])
    {
        MyOrderTabViewController *order = [[MyOrderTabViewController alloc]init];
        order.selectHeadIndex = 1;
        order.comefrom = self.comefrom;
        order.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:order animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
