//
//  NotUsedViewController.m
//  FangXinCai
//
//  Created by ios-1 on 2018/1/16.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "NotUsedViewController.h"

@interface NotUsedViewController ()

@end

@implementation NotUsedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatData];
}
- (void)creatData
{
//        //测试数据后面删除
//        for(int i =0;i<2;i++)
//        {
//            CouponData *data = [CouponData new];
//            data.ID = [NSString stringWithFormat:@"%zd",i];
//            data.real_condition = @"325";
//            data.condition = @"300";
//            data.money = @"25";
//            data.name = @"消费满300赠送25";
//            data.use_end_time = @"1514789542";
//            [self.dataArray addObject:data];
//        }
    
    [self.dataArray addObjectsFromArray:self.couponModel.coupon_list];
    
    if(self.is_selectCoupon)//是订单过来的才能选择优惠券
    {
        NSString *couponID = [KUserDefaul objectForKey:SelectCoupon];
        for(CouponData *couponData in self.dataArray)
        {
            if([couponData.ID isEqualToString:couponID])
            {
                couponData.is_select = YES;
            }else{
                couponData.is_select = NO;
            }
        }
    }
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

//兑换优惠券
- (void)selectCouponHttp
{
    for(CouponData *data in self.dataArray)
    {
        if(data.is_select)
        {
            [self selectCouponHttp:data];
            return;
        }
    }
    
    CouponData *coupondata = [CouponData new];
    coupondata.is_select = NO;
    [self selectCouponHttp:coupondata];
}
#pragma mark ************网络请求************
//选中优惠券
- (void)selectCouponHttp:(CouponData*)coupondata
{
    NSString *token = [KUserDefaul objectForKey:User_Token];
    
    NSMutableDictionary *reqDict = [NSMutableDictionary dictionary];
    [reqDict setValue:token forKey:@"token"];
    [reqDict setValue:coupondata.is_select?coupondata.ID:@"0" forKey:@"id"];
    
    BaseReqApi *Api=[[BaseReqApi alloc]initWithRequestUrl:@"selectCoupon.json" andrequestTime:5 andParams:reqDict andRequestMethod:YTKRequestMethodPOST andCache:NO andCacheTime:0 andPostToken:NO];
    [self showLoadingAnimation];
    [Api StarRequest:^(TBResponseStatus responseStatus, NSString *message, id responseObject) {
        [self stopLoadingAnimation];
        if (responseStatus == 1) {
            
            if(coupondata.is_select)
            {
                //保存当前选中的优惠券
                [KUserDefaul setObject:coupondata.ID forKey:SelectCoupon];
            }else{
                [KUserDefaul removeObjectForKey:SelectCoupon];
            }
            
            if(self.selectCouponBlock)
            {
                self.selectCouponBlock(coupondata,responseObject[@"data"]);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else if (responseStatus==0||responseStatus==2)
        {
            [MBProgressHUD showError:message toView:kAppWindow];
        }else{
            
            [MBProgressHUD showError:message toView:kAppWindow];
        }
    }];
}
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
            //请求成功
            NSArray *arr = @[@"余额明细",@"积分明细",@"充值记录",@"提现记录",@"余额明细",@"积分明细",@"充值记录",@"提现记录"];
            [self.dataArray addObjectsFromArray:arr];
            self.httpDataArr = self.dataArray;
            [self loadDatas:NO];//刷新列表
            
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
