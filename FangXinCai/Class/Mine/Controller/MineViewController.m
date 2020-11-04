//
//  MineViewController.m
//  FangXinCai
//
//  Created by ios-1 on 2018/1/8.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "MineViewController.h"
#import "MapViewController.h"
#import "MineTableViewCell.h"
#import "MineTableHeadView.h"
#import "SettingViewController.h"
#import "MyWaletViewController.h"
#import "InvoiceViewController.h"
#import "BaseOrderViewController.h"
#import "UIScrollView+MyRefresh.h"
#import "MyOrderTabViewController.h"
#import "CouponViewController.h"
#import "StoreManagViewController.h"
#import "RootNavigationController.h"
#import "LoginViewController.h"
@interface MineViewController ()
@property (nonatomic , strong) MineTableHeadView *headerView;
@end

@implementation MineViewController
{
    CGFloat last;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //隐藏上下拉刷新
    self.tableView.mj_footer.hidden = YES;
    self.tableView.mj_header.hidden = YES;
    //隐藏导航栏
    self.isHidenNaviBar = YES;
    
    [self creatMainTableview];
}
- (void)viewWillAppear:(BOOL)animated
{
    [self getUserInfoHttp];
}
- (void)creatMainTableview
{
    self.tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight-kTabBarHeight);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.headerView = [[MineTableHeadView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 400)];
    
    kWeakSelf(self);
    self.headerView.settingBlock = ^{
        [weakself goSetting];
    };
    self.headerView.waletBlock = ^{
        [weakself goWalet];
    };
    self.headerView.orderBlock = ^{
        [weakself goOrder:0];
    };
    self.headerView.orderWaletBlock = ^(NSInteger tag) {
        [weakself goOrderAndWalet:tag];
    };
    
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.tableFootView;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MineTableViewCell" bundle:nil] forCellReuseIdentifier:@"MineCell"];
    
    [self.view addSubview:self.tableView];
}

#pragma mark ————— 下拉刷新 —————
-(void)headerRereshing{
    [self performSelector:@selector(stopfresh) withObject:nil afterDelay:3.0];
}
- (void)stopfresh
{
    [self.tableView.mj_header endRefreshing];
}
- (UIView*)tableFootView
{
    if(_tableFootView == nil)
    {
        _tableFootView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
        _tableFootView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _tableFootView.userInteractionEnabled = YES;
        
        UILabel *exitlab = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, 40)];
        exitlab.backgroundColor = KWhiteColor;
        exitlab.textColor = basegreenColor;
        exitlab.textAlignment = NSTextAlignmentCenter;
        exitlab.text = @"退出登录";
        exitlab.font = [UIFont systemFontOfSize:KZOOM6pt(28)];
        [_tableFootView addSubview:exitlab];
        
        UITapGestureRecognizer *exittap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(exit)];
        [_tableFootView addGestureRecognizer:exittap];
    }
    return _tableFootView;
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
    if(indexPath.row == 0)
    {
        [self goStoreManager];
    }else if (indexPath.row == 1)
    {
        [self goInvoice];
    }else if (indexPath.row == 2)
    {
        
    }
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


#pragma mark UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offset = scrollView.contentOffset.y ;
    
    CGFloat totalOffsetY = scrollView.contentInset.top + offset;
    
    self.headerView.userHeadview.frame = CGRectMake(0, offset, self.view.width, 130 - totalOffsetY);
}

//退出登录
- (void)exit
{
    [self logoutHttp];
}

- (void)gobaseorder
{
    BaseOrderViewController *baseorder = [[BaseOrderViewController alloc]init];
    baseorder.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:baseorder animated:YES];
}
//设置
- (void)goSetting
{
    SettingViewController *stting = [SettingViewController new];
    stting.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:stting animated:YES];
}
//钱包
- (void)goWalet
{
    MyWaletViewController *walet = [[MyWaletViewController alloc]init];
    walet.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:walet animated:YES];
}

//优惠券
- (void)goCoupon
{
    CouponViewController *coupon = [[CouponViewController alloc]init];
    coupon.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:coupon animated:YES];
}
//订单
- (void)goOrder:(NSInteger)headIndex
{
    MyOrderTabViewController *order = [[MyOrderTabViewController alloc]init];
    order.selectHeadIndex = headIndex;
    order.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:order animated:YES];
}
//门店管理
- (void)goStoreManager
{
    StoreManagViewController *store = [[StoreManagViewController alloc]init];
    store.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:store animated:YES];
}
//发票
- (void)goInvoice
{
    InvoiceViewController *invoice = [[InvoiceViewController alloc]init];
    invoice.title = @"发票";
    invoice.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:invoice animated:YES];
}

//订单+余额
- (void)goOrderAndWalet:(NSInteger)tag
{
    switch (tag) {
        case 10000:
            [self goOrder:tag-10000+1];//待付款
            break;
        case 10001:
            [self goOrder:tag-10000+1];//待发货
            break;
        case 10002:
            [self goOrder:tag-10000+1];//待收货
            break;
        case 10003:
            [self goOrder:tag-10000+1];//已完成
            break;
        case 20000:
            [self goWalet];//余额
            break;
        case 20001:
            [self goCoupon];//优惠券
            break;
        case 20002:
            [self goWalet];//积分
            break;
            
        default:
            break;
    }
}

#pragma mark ************网络请求************
//退出登录
- (void)logoutHttp
{
    NSString *token = [KUserDefaul objectForKey:User_Token];
    
    NSMutableDictionary *reqDict = [NSMutableDictionary dictionary];
    [reqDict setValue:token forKey:@"token"];
   
    BaseReqApi *Api=[[BaseReqApi alloc]initWithRequestUrl:@"logout.json" andrequestTime:5 andParams:reqDict andRequestMethod:YTKRequestMethodPOST andCache:NO andCacheTime:0 andPostToken:NO];
    [self showLoadingAnimation];
    [Api StarRequest:^(TBResponseStatus responseStatus, NSString *message, id responseObject) {
        [self stopLoadingAnimation];
        if (responseStatus == 1) {
            
            [KUserDefaul removeObjectForKey:User_Token];
            RootNavigationController *loginNavi =[[RootNavigationController alloc] initWithRootViewController:[LoginViewController new]];
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            window.rootViewController = loginNavi;
        }else if (responseStatus==0||responseStatus==2)
        {
            [MBProgressHUD showError:message toView:kAppWindow];
        }else{
            
            [MBProgressHUD showError:message toView:kAppWindow];
            
            [KUserDefaul removeObjectForKey:User_Token];
            RootNavigationController *loginNavi =[[RootNavigationController alloc] initWithRootViewController:[LoginViewController new]];
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            window.rootViewController = loginNavi;
        }
    }];
}

//获取用户信息 钱包信息 订单信息
- (void)getUserInfoHttp
{
    NSString *token = [KUserDefaul objectForKey:User_Token];
    NSMutableDictionary *reqDict = [NSMutableDictionary dictionary];
    [reqDict setValue:token forKey:@"token"];
    
    BaseReqApi *LoginApi=[[BaseReqApi alloc]initWithRequestUrl:@"userCenter.json" andrequestTime:5 andParams:reqDict andRequestMethod:YTKRequestMethodPOST andCache:NO andCacheTime:0 andPostToken:NO];
//    [MBProgressHUD showMessage:@"加载中..." afterDeleay:10 WithView:self.view];
    [LoginApi StarRequest:^(TBResponseStatus responseStatus, NSString *message, id responseObject) {
        [MBProgressHUD hideHUD];
        
        if (responseStatus==1) {
            [self.headerView refreshUI:responseObject[@"data"]];
        }else if (responseStatus==0||responseStatus==2)
        {
            [MBProgressHUD showError:message toView:self.view];
        }else{
            [MBProgressHUD showError:message toView:self.view];
            kWeakSelf(self);
            [self loginSuccess:^{
                [weakself getUserInfoHttp];
            }];
        }
    }];
}

- (NSMutableArray*)tabDataArr
{
    if(_tabDataArr == nil)
    {
        _tabDataArr = [NSMutableArray array];
        NSArray *arr = @[@"门店管理",@"发票",@"服务中心"];
        [_tabDataArr addObjectsFromArray:arr];
    }
    return _tabDataArr;
}
- (NSMutableArray*)imgDataArr
{
    if(_imgDataArr == nil)
    {
        _imgDataArr = [NSMutableArray array];
        NSArray *arr = @[@"icon_tabbar_mine_selected.png",@"icon_tabbar_mine_selected.png",@"icon_tabbar_mine_selected.png"];
        [_imgDataArr addObjectsFromArray:arr];
    }
    return _imgDataArr;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
