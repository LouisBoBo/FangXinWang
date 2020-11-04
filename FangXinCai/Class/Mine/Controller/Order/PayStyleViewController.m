//
//  PayStyleViewController.m
//  FangXinCai
//
//  Created by ios-1 on 2018/3/1.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "PayStyleViewController.h"
#import "PayStyleTableViewCell.h"
#import "OrderDetailViewController.h"
#import "PayStyleModel.h"
@interface PayStyleViewController ()
@property (nonatomic , strong) PayStyleModel *PayStylemodel;
@property (nonatomic , strong) UILabel *orderPriceLab;
@end

@implementation PayStyleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付方式";
    self.view.backgroundColor = CViewBgColor;
    
    [self creatTableView];
    [self getpayStyleHttp];
}

- (void)getpayStyleHttp
{
    NSString *token = [KUserDefaul objectForKey:User_Token];
    
    NSMutableDictionary *reqDict = [NSMutableDictionary dictionary];
    [reqDict setValue:token forKey:@"token"];
    [reqDict setValue:self.order_id forKey:@"id"];
    [reqDict setValue:@"3" forKey:@"scene"];
    
    BaseReqApi *Api=[[BaseReqApi alloc]initWithRequestUrl:@"payMethod.json" andrequestTime:5 andParams:reqDict andRequestMethod:YTKRequestMethodPOST andCache:NO andCacheTime:0 andPostToken:NO];
    [self showLoadingAnimation];
    [Api StarRequest:^(TBResponseStatus responseStatus, NSString *message, id responseObject) {
        [self stopLoadingAnimation];
        if (responseStatus == 1 && responseObject[@"data"]) {
            self.PayStylemodel = [PayStyleModel mj_objectWithKeyValues:responseObject[@"data"]];
            self.PayStylemodel.payment_list[0].is_select = YES;
            self.orderPriceLab.text = [NSString stringWithFormat:@"￥%@",self.PayStylemodel.order_price];
            [self.tableView reloadData];
        }else if (responseStatus==0||responseStatus==2)
        {
            [MBProgressHUD showError:message toView:kAppWindow];
        }else{
            
            [MBProgressHUD showError:message toView:kAppWindow];
            kWeakSelf(self);
            [self loginSuccess:^{
                [weakself getpayStyleHttp];
            }];
        }
    }];
}
- (void)creatTableView
{
    self.tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight-64);
    self.tableviewstyle = UITableViewStyleGrouped;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.tableHeaderView = [self tabHeadView];
    self.tableView.tableFooterView = [self tabFootView];
    
    self.tableView.mj_header.hidden = YES;
    self.tableView.mj_footer.hidden = YES;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PayStyleTableViewCell" bundle:nil] forCellReuseIdentifier:@"PayStyleCell"];
    
    [self.view addSubview:self.tableView];
}

- (UIView*)tabHeadView
{
    UIView *headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 100)];
    headview.backgroundColor = KWhiteColor;
    
    UILabel *titlelab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, KZOOM6pt(160), 45)];
    titlelab.text = @"订单金额：";
    titlelab.textColor = KGrayColor;
    titlelab.font = HBFont14;
    [headview addSubview:titlelab];
    
    UILabel *pricelab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titlelab.frame), 0, KZOOM6pt(180), 45)];
    pricelab.text = @"";
    pricelab.font = HBFont16;
    pricelab.textColor = [UIColor redColor];
    [headview addSubview:self.orderPriceLab = pricelab];
    
    UILabel *linelab1 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titlelab.frame), KScreenWidth, 15)];
    linelab1.backgroundColor = CViewBgColor;
    [headview addSubview:linelab1];
    
    UILabel *stylelab = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(pricelab.frame)+15, KZOOM6pt(260), 40)];
    stylelab.text = @"选择支付方式";
    stylelab.font = HBFont14;
    stylelab.textColor = KGrayColor;
    [headview addSubview:stylelab];
    
    UILabel *linelab2 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(headview.frame)-1, KScreenWidth, 1)];
    linelab2.backgroundColor = CLineColor;
    [headview addSubview:linelab2];
    return headview;
}
- (UIView*)tabFootView
{
    UIView *footview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 80)];
    footview.backgroundColor = CViewBgColor;
    
    UIButton *paymentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    paymentBtn.frame = CGRectMake(20, 20, KScreenWidth-40, 40);
    paymentBtn.backgroundColor = basegreenColor;
    paymentBtn.titleLabel.font = HBFont16;
    paymentBtn.clipsToBounds = YES;
    paymentBtn.layer.cornerRadius = 20;
    [paymentBtn setTitle:@"支付" forState:UIControlStateNormal];
    [footview addSubview:paymentBtn];
    
    [paymentBtn addTarget:self action:@selector(payClick:) forControlEvents:UIControlEventTouchUpInside];
    return footview;
}
//支付
- (void)payClick:(UIButton*)sender
{
    NSLog(@"支付");
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.PayStylemodel.payment_list.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PayStyleData *data = self.PayStylemodel.payment_list[indexPath.row];
    for(PayStyleData *styledata in self.PayStylemodel.payment_list)
    {
        if(styledata == data)
        {
            styledata.is_select = YES;
        }else{
            styledata.is_select = NO;
        }
    }
    [self.tableView reloadData];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PayStyleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PayStyleCell"];
    if(!cell)
    {
        cell = [[PayStyleTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"PayStyleCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    PayStyleData *data = self.PayStylemodel.payment_list[indexPath.row];
    [cell refreshData:data];
    
    kWeakSelf(self);
    cell.selectPayStyleBlock = ^(PayStyleData *data) {
        for(PayStyleData *styledata in weakself.PayStylemodel.payment_list)
        {
            if(styledata == data)
            {
                styledata.is_select = YES;
            }else{
                styledata.is_select = NO;
            }
        }
        [weakself.tableView reloadData];
    };
    return cell;
}

- (void)backBtnClicked
{
    OrderDetailViewController *orderdetail = [OrderDetailViewController new];
    orderdetail.comefrom = @"支付";
    [self.navigationController pushViewController:orderdetail animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
