//
//  MyWaletViewController.m
//  FangXinCai
//
//  Created by ios-1 on 2018/1/10.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "MyWaletViewController.h"
#import "MineTableViewCell.h"
#import "WaletTableHeadView.h"
#import "RechargeViewController.h"
#import "DetailAndRecordViewController.h"
#import "WithdrawalsViewController.h"
@interface MyWaletViewController ()

@end

@implementation MyWaletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的钱包";
    self.tableView.mj_header.hidden = YES;
    self.tableView.mj_footer.hidden = YES;
    
    [self creatMainTableview];
}

- (void)creatMainTableview
{
    self.tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight-kTabBarHeight);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    
    WaletTableHeadView *headview = [[WaletTableHeadView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, KZOOM6pt(500))];
    self.tableView.tableHeaderView = headview;
    kWeakSelf(self);
    headview.moneyBlock = ^{//充值
        [weakself goMoneyVC];
    };
    
    headview.operaBlock = ^{//提现
        [weakself goTixianVC];
    };
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MineTableViewCell" bundle:nil] forCellReuseIdentifier:@"MineCell"];
    
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tabDataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //row = 0余额明细 1积分明细 2充值记录 3提现记录
    [self goMoneyDetaile:indexPath.row];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineCell"];
    if(!cell)
    {
        cell = [[MineTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MineCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.headImg.layer.cornerRadius = CGRectGetHeight(cell.headImg.frame)/2;
    cell.headImg.image = [UIImage imageNamed:self.imgDataArr[indexPath.row]];
    cell.headTitle.text = self.tabDataArr[indexPath.row];
    cell.headTitle.font = [UIFont systemFontOfSize:KZOOM6pt(30)];
    
    return cell;
}
//去充值
- (void)goMoneyVC
{
    RechargeViewController *recharge = [RechargeViewController new];
    [self.navigationController pushViewController:recharge animated:YES];
}
//去提现
- (void)goTixianVC
{
    WithdrawalsViewController *drawa = [WithdrawalsViewController new];
    [self.navigationController pushViewController:drawa animated:YES];
}
//余额明细
- (void)goMoneyDetaile:(NSInteger)rowindex
{
    DetailAndRecordViewController *detailrecord = [DetailAndRecordViewController new];
    
    switch (rowindex) {
        case 0:
            detailrecord.title = @"余额明细";
            detailrecord.detailRecordStyle = DetailRecore_Money;
            break;
        case 1:
            detailrecord.title = @"积分明细";
            detailrecord.detailRecordStyle = DetailRecore_Jifen;
            break;
        case 2:
            detailrecord.title = @"充值记录";
            detailrecord.detailRecordStyle = DetailRecore_Recharge;
            break;
        case 3:
            detailrecord.title = @"提现记录";
            detailrecord.detailRecordStyle = DetailRecore_Tixian;
            break;
            
        default:
            break;
    }
    
    [self.navigationController pushViewController:detailrecord animated:YES];
}

- (NSMutableArray*)tabDataArr
{
    if(_tabDataArr == nil)
    {
        _tabDataArr = [NSMutableArray array];
        NSArray *arr = @[@"余额明细",@"积分明细",@"充值记录",@"提现记录"];
        [_tabDataArr addObjectsFromArray:arr];
    }
    return _tabDataArr;
}
- (NSMutableArray*)imgDataArr
{
    if(_imgDataArr == nil)
    {
        _imgDataArr = [NSMutableArray array];
        NSArray *arr = @[@"icon_tabbar_mine_selected.png",@"icon_tabbar_mine_selected.png",@"icon_tabbar_mine_selected.png",@"icon_tabbar_mine_selected.png"];
        [_imgDataArr addObjectsFromArray:arr];
    }
    return _imgDataArr;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
