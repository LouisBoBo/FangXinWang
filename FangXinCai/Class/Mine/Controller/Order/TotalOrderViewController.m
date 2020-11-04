//
//  TotalOrderViewController.m
//  FangXinCai
//
//  Created by ios-1 on 2018/1/12.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "TotalOrderViewController.h"

@interface TotalOrderViewController ()

@end

@implementation TotalOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatData];
}

- (void)creatData
{
    NSArray *arr = @[@"余额明细",@"积分明细",@"充值记录",@"提现记录"];
    [self.dataArray addObjectsFromArray:arr];
    self.httpDataArr = self.dataArray;
    
    [self loadDatas];//刷新列表
}
- (void)actionMJHeaderRefresh
{
    NSLog(@"ok");
}
- (NSMutableArray*)dataArray
{
    if(_dataArray == nil)
    {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
