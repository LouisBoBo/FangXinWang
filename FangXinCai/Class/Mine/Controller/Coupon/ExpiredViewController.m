//
//  ExpiredViewController.m
//  FangXinCai
//
//  Created by ios-1 on 2018/1/16.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "ExpiredViewController.h"

@interface ExpiredViewController ()

@end

@implementation ExpiredViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatData];
}
- (void)creatData
{
    [self.dataArray addObjectsFromArray:self.couponModel.coupon_list];
    self.httpDataArr = self.dataArray;

    [self loadDatas:NO];//刷新列表
}
//下拉刷新
- (void)actionMJHeaderRefresh
{
    [self.dataArray removeAllObjects];
    [self httpData];
}
//上拉加载
- (void)actionMJFooterLoadMore
{
    [self.tableView.mj_footer resetNoMoreData];
    [self httpData];
    
}

#pragma mark ************网络请求************
- (void)httpData
{
    NSMutableDictionary *reqDict = [NSMutableDictionary dictionary];
    [reqDict setValue:@"hbhb" forKey:@"loginName"];
    [reqDict setValue:@"123456" forKey:@"loginPwd"];
    [reqDict setValue:@"3" forKey:@"loginType"];
    
    BaseReqApi *api=[[BaseReqApi alloc]initWithRequestUrl:@"/index.php/FoodCheckApi/login.json" andrequestTime:5 andParams:reqDict andRequestMethod:YTKRequestMethodPOST andCache:NO andCacheTime:0 andPostToken:NO];
    
    [api StarRequest:^(TBResponseStatus responseStatus, NSString *message, id responseObject) {
        [self stopLoadingAnimation];
        
        if (responseStatus==1) {
//            //请求成功
//            NSArray *arr = @[@"余额明细",@"积分明细",@"充值记录",@"提现记录",@"余额明细",@"积分明细",@"充值记录",@"提现记录"];
//            [self.dataArray addObjectsFromArray:arr];
//            self.httpDataArr = self.dataArray;
            
            [self loadDatas:YES];//刷新列表
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            [self NetRequestSuccess:self scrollView:self.tableView];
            
        }else if (responseStatus==0||responseStatus==2)
        {
            [self NetRequestFail:self scrollView:self.tableView msg:message];
        }else{
            [self NetRequestFail:self scrollView:self.tableView msg:message];
            kWeakSelf(self);
            [self loginSuccess:^{
                [weakself httpData];
            }];
        }
        
    }];
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
