//
//  ConfirmOrderViewController.m
//  FangXinCai
//
//  Created by ios-1 on 2018/2/26.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "ConfirmOrderViewController.h"
#import "ConfirmOrderTableViewCell.h"
#import "ConfirmOrderTabHeadview.h"
#import "InvoiceViewController.h"
#import "CouponViewController.h"
#import "PayStyleViewController.h"
#import "ShopDetailViewController.h"
#import "SelectCouponViewController.h"
#import "ConfirmOrderFootViewController.h"
#import "CartCountModel.h"
#import "SubmitOrderModel.h"
#import "CouponModel.h"
#import "GoodsShopModel.h"
@interface ConfirmOrderViewController ()
@property (nonatomic , strong) ConfirmOrderTabHeadview *tabHeadView;
@property (nonatomic , strong) ConfirmOrderFootViewController *footvc;
@property (nonatomic , strong) UIView *tabFootView;
@property (nonatomic , strong) CartCountModel *countModel;
@property (nonatomic , strong) CouponModel *couponModel;
@property (nonatomic , strong) NSString *couponID;           //优惠券ID
@property (nonatomic , strong) UILabel *payLabel;            //实付
@end

@implementation ConfirmOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CViewBgColor;
    self.title = @"填写订单";
    self.couponID = @"0";
    
    [self creatData];
    [self creatTableView];
    [self creatFootView];
    [self getOrderInfoHttp];
}
- (void)creatData
{
    NSArray *titleArr = @[@"优惠券",@"备注"];
    NSArray *valueArr = @[@"",@"备注详情"];
    for(int i=0; i<titleArr.count;i++)
    {
        SubmitOrderModel *orderModel = [SubmitOrderModel new];
        orderModel.title = titleArr[i];
        orderModel.value = valueArr[i];
        [self.dataArray addObject:orderModel];
    }
}
- (void)creatTableView
{
    self.tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight-114);
    self.tableviewstyle = UITableViewStyleGrouped;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.tableHeaderView = self.tabHeadView;
    self.tableView.tableFooterView = self.tabFootView;
    
    self.tableView.mj_header.hidden = YES;
    self.tableView.mj_footer.hidden = YES;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ConfirmOrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"ConfirmOrderCell"];
    
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        SelectCouponViewController *coupon = [[SelectCouponViewController alloc]init];
        coupon.couponModel = self.couponModel;
        kWeakSelf(self);
        
        coupon.selectCouponBlock = ^(CouponData *data, NSDictionary *dic) {
            
            SubmitOrderModel *model = weakself.dataArray[0];
            
            if(data.is_select)
            {
                self.couponID = data.ID;
                model.value = [NSString stringWithFormat:@"%zd元优惠券",data.money.integerValue];
                self.payLabel.text = [NSString stringWithFormat:@"实付：%.2f",[dic[@"order_total_price"] floatValue]];
                [self.tableView reloadData];
            }else{
                self.couponID = @"0";
                [weakself getOrderInfoHttp];
            }
        };
       
        [self.navigationController pushViewController:coupon animated:YES];
    }else if (indexPath.row == 1)
    {
        InvoiceViewController *invoice = [[InvoiceViewController alloc]init];
        invoice.title = @"订单备注";
        kWeakSelf(self);
        invoice.OrderRemarksBlock = ^(id data) {
            SubmitOrderModel *model = weakself.dataArray[1];
            model.value = data;
            [weakself.tableView reloadData];
        };
        [self.navigationController pushViewController:invoice animated:YES];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConfirmOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConfirmOrderCell"];
    if(!cell)
    {
        cell = [[ConfirmOrderTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ConfirmOrderCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(indexPath.row == 0)
    {
        cell.valueLab.textColor = [UIColor redColor];
    }
    SubmitOrderModel *model = self.dataArray[indexPath.row];
    [cell refreshData:model];
    return cell;
}

- (void)creatFootView
{
    UIView *footview = [[UIView alloc]init];
    footview.backgroundColor = KWhiteColor;
    [self.view addSubview:self.submitFootview = footview];
    
    UILabel *payLabel = [[UILabel alloc]init];
    payLabel.textAlignment = NSTextAlignmentRight;
    payLabel.textColor = [UIColor redColor];
    payLabel.font = HBFont15;
    payLabel.text = @"实付：￥0.00";
    [footview addSubview:self.payLabel = payLabel];
    
    UIButton *payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [payButton setTitle:@"提交订单" forState:UIControlStateNormal];
    [payButton setTitleColor:KWhiteColor forState:UIControlStateNormal];
    payButton.titleLabel.font = HBFont15;
    payButton.backgroundColor = basegreenColor;
    [payButton addTarget:self action:@selector(payOrder:) forControlEvents:UIControlEventTouchUpInside];
    [footview addSubview:payButton];
    
    [footview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    
    [payLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.height.equalTo(footview);
        make.width.mas_equalTo(KScreenWidth-110);
    }];
    
    [payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.height.equalTo(footview);
        make.width.mas_equalTo(100);
    }];
}
- (void)payOrder:(UIButton*)sender
{
    [self payOrderHttp];
}
#pragma mark ************网络请求************
//获取订单信息
- (void)getOrderInfoHttp
{
    NSString *token = [KUserDefaul objectForKey:User_Token];
    
    NSMutableDictionary *reqDict = [NSMutableDictionary dictionary];
    [reqDict setValue:token forKey:@"token"];
    
    BaseReqApi *Api=[[BaseReqApi alloc]initWithRequestUrl:@"goToOrder.json" andrequestTime:5 andParams:reqDict andRequestMethod:YTKRequestMethodPOST andCache:NO andCacheTime:0 andPostToken:NO];
    [self showLoadingAnimation];
    [Api StarRequest:^(TBResponseStatus responseStatus, NSString *message, id responseObject) {
        [self stopLoadingAnimation];
        if (responseStatus == 1 && responseObject[@"data"]) {
            self.countModel = [CartCountModel mj_objectWithKeyValues:responseObject[@"data"][@"tongji"]];
            self.couponModel = [CouponModel mj_objectWithKeyValues:responseObject[@"data"]];
            
            [self refreshTabFootView:responseObject[@"data"][@"tongji"]];
            [self refreshTabHeadView:responseObject[@"data"]];
            
            NSString *coupon_count = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"coupon_count"]];
            SubmitOrderModel *model = self.dataArray[0];
            if(coupon_count.integerValue > 0){
                model.value = [NSString stringWithFormat:@"%zd张可用",coupon_count.integerValue];
            }else{
                model.value = @"";
            }
            [self.tableView reloadData];
            
        }else if (responseStatus==0||responseStatus==2)
        {
            [MBProgressHUD showError:message toView:kAppWindow];
        }else{
            
            [MBProgressHUD showError:message toView:kAppWindow];
            kWeakSelf(self);
            [self loginSuccess:^{
                [weakself getOrderInfoHttp];
            }];
        }
    }];
}

//提交订单
- (void)payOrderHttp
{
    NSString *token = [KUserDefaul objectForKey:User_Token];
    SubmitOrderModel *model = self.dataArray[1];
    NSString *user_note = [model.value isEqualToString:@"备注详情"]?@"":model.value;
    NSMutableDictionary *reqDict = [NSMutableDictionary dictionary];
    [reqDict setValue:token forKey:@"token"];
    [reqDict setValue:self.couponID forKey:@"id"];
    [reqDict setValue:user_note forKey:@"user_note"];
    
    BaseReqApi *Api=[[BaseReqApi alloc]initWithRequestUrl:@"addOrder.json" andrequestTime:5 andParams:reqDict andRequestMethod:YTKRequestMethodPOST andCache:NO andCacheTime:0 andPostToken:NO];
    [self showLoadingAnimation];
    [Api StarRequest:^(TBResponseStatus responseStatus, NSString *message, id responseObject) {
        [self stopLoadingAnimation];
        if (responseStatus == 1 && responseObject[@"data"]) {
        
            PayStyleViewController *paystyle = [PayStyleViewController new];
            paystyle.order_id = responseObject[@"data"][@"order_id"];
            [self.navigationController pushViewController:paystyle animated:YES];
        }else if (responseStatus==0||responseStatus==2)
        {
            [MBProgressHUD showError:message toView:kAppWindow];
        }else{
            
            [MBProgressHUD showError:message toView:kAppWindow];
            kWeakSelf(self);
            [self loginSuccess:^{
                [weakself payOrderHttp];
            }];
        }
    }];
}
//刷新列表尾
- (void)refreshTabFootView:(NSDictionary*)data
{
    self.payLabel.text = [NSString stringWithFormat:@"实付：%.2f",[data[@"order_total_price"] floatValue]];
    [self.footvc refreshUI:data];
}
//刷新列表头
- (void)refreshTabHeadView:(NSDictionary*)data
{
    [self.tabHeadView refreshUI:data];
}
- (ConfirmOrderTabHeadview*)tabHeadView
{
    if(_tabHeadView == nil)
    {
        _tabHeadView = [[ConfirmOrderTabHeadview alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KZOOM6pt(460))];
        kWeakSelf(self);
        _tabHeadView.selectShopClick = ^(GoodsShopData *shopdata) {
            ShopDetailViewController *shopdetail = [[ShopDetailViewController alloc]init];
            shopdetail.goods_id = shopdata.goods_id;
            shopdetail.spec_key = shopdata.spec_key;
            [weakself.navigationController pushViewController:shopdetail animated:YES];
        };
    }
    return _tabHeadView;
}
- (UIView*)tabFootView
{
    if(_tabFootView == nil)
    {
        _tabFootView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 160)];
        _footvc = [[ConfirmOrderFootViewController alloc]init];
        [self addChildViewController:_footvc];
        _footvc.view.frame = CGRectMake(0, KZOOM6pt(20), KScreenWidth, 150);
        kWeakSelf(self);
        _footvc.joinSingleBlock = ^{
            weakself.tabBarController.selectedIndex = 1;
            [weakself.navigationController popToRootViewControllerAnimated:NO];
        };
        [_tabFootView addSubview:_footvc.view];
    }
    return _tabFootView;
}

- (NSMutableArray*)dataArray{
    if(_dataArray == nil)
    {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSMutableArray*)shopDataArray
{
    if(_shopDataArray == nil)
    {
        _shopDataArray = [NSMutableArray array];
    }
    return _shopDataArray;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
