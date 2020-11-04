//
//  DetailAndRecordViewController.m
//  FangXinCai
//
//  Created by ios-1 on 2018/1/11.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "DetailAndRecordViewController.h"
#import "DetailRecordTableViewCell.h"

@interface DetailAndRecordViewController ()

@end

@implementation DetailAndRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatMainTableview];
}
- (void)creatMainTableview
{
    self.tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight-kTabBarHeight);
    self.tableviewstyle = UITableViewStyleGrouped;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    

    [self.tableView registerNib:[UINib nibWithNibName:@"DetailRecordTableViewCell" bundle:nil] forCellReuseIdentifier:@"DRCell"];
    
    [self.view addSubview:self.tableView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *headlab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
    headlab.backgroundColor = [UIColor groupTableViewBackgroundColor];
    headlab.font = [UIFont systemFontOfSize:KZOOM6pt(28)];
    headlab.textColor = KGrayColor;
    headlab.text = @"  本月记录";
    return headlab;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tabDataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DRCell"];
    if(!cell)
    {
        cell = [[DetailRecordTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"DRCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   
    return cell;
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
