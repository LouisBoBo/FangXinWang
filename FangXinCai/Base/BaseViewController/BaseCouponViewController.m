//
//  BaseCouponViewController.m
//  FangXinCai
//
//  Created by ios-1 on 2018/1/16.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "BaseCouponViewController.h"
#import "CouponTableViewCell.h"

@interface BaseCouponViewController ()<UIAlertViewDelegate>

@end

@implementation BaseCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatMainTableView];
}
- (void)loadDatas:(BOOL)isExpired;
{
    self.isExpired = isExpired;
    self.tabDataArr = self.httpDataArr;
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
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"CouponTableViewCell" bundle:nil] forCellReuseIdentifier:@"CouponCell"];
    
    [self configureNeedShowEmptyDataSetScrollView:self.tableView];
    [self configScrollViewFooterLoadMore:self.tableView];//加载更多
    self.tableView.tableFooterView=[[UIView alloc]init];
    
    [self.view addSubview:self.tableView];
}
- (void)actionMJHeaderRefresh
{
    NSLog(@"开始刷新");
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tabDataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CouponData *couponData = self.httpDataArr[indexPath.row];
    
    for(CouponData *data in self.httpDataArr)
    {
        if(data == couponData)
        {
            couponData.is_select = !couponData.is_select;
        }else{
            data.is_select = NO;
        }
    }
    [self.tableView reloadData];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CouponCell"];
    if(!cell)
    {
        cell = [[CouponTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CouponCell"];
    }
    cell.status.text=self.isExpired?@"已过期":@"未使用";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CouponData *couponData = self.httpDataArr[indexPath.row];
    [cell refreshData:couponData];
    
    return cell;
}

//添加优惠券的输入框
- (void)creatAltView
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"添加优惠券" message:@"请输入优惠券密码" preferredStyle:UIAlertControllerStyleAlert];
    //以下方法就可以实现在提示框中输入文本；
    
    //在AlertView中添加一个输入框
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.placeholder = @"请输入优惠券密码";
    }];
    

    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定"style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        UITextField *envirnmentNameTextField = alertController.textFields.firstObject;
        
        //输出 检查是否正确无误
        NSLog(@"你输入的文本%@",envirnmentNameTextField.text);
    }];
    
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消"style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
        
    }];
    
    [sure setValue:basegreenColor forKey:@"_titleTextColor"];
    [cancle setValue:KGrayColor forKey:@"_titleTextColor"];
    [alertController addAction:sure];
    [alertController addAction:cancle];
    
    //present出AlertView
    [self presentViewController:alertController animated:true completion:nil];
}

#pragma mark ************网络请求************
//选中优惠券
- (void)selectCouponHttp:(CouponData*)coupondata
{
    NSString *token = [KUserDefaul objectForKey:User_Token];
    
    NSMutableDictionary *reqDict = [NSMutableDictionary dictionary];
    [reqDict setValue:token forKey:@"token"];
    [reqDict setValue:coupondata.is_select?@"0":coupondata.ID forKey:@"id"];
    
    BaseReqApi *Api=[[BaseReqApi alloc]initWithRequestUrl:@"selectCoupon.json" andrequestTime:5 andParams:reqDict andRequestMethod:YTKRequestMethodPOST andCache:NO andCacheTime:0 andPostToken:NO];
    [self showLoadingAnimation];
    [Api StarRequest:^(TBResponseStatus responseStatus, NSString *message, id responseObject) {
        [self stopLoadingAnimation];
        if (responseStatus == 1) {
            coupondata.is_select = !coupondata.is_select;
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
