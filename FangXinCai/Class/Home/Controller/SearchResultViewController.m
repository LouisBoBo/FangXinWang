//
//  SearchResultViewController.m
//  FangXinCai
//
//  Created by ios-1 on 2018/1/13.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "SearchResultViewController.h"
#import "RightTableViewCell.h"
#import "MultilHeadView.h"
@interface SearchResultViewController ()

@end

@implementation SearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPage = 1;
    self.sort = 1;
    
    [self creatMainTableView];
    [self searchGoodsHttp:self.sort];
}

//搜索
- (void)searchGoodsHttp:(NSInteger)sort
{
    self.sort = sort;
    
    NSString *token = [KUserDefaul objectForKey:User_Token];
    NSMutableDictionary *reqDict = [NSMutableDictionary dictionary];
    [reqDict setValue:token forKey:@"token"];
    [reqDict setValue:@"测试" forKey:@"keyword"];
    [reqDict setValue:@"1" forKey:@"page"];
    [reqDict setValue:@"20" forKey:@"pageSize"];
    [reqDict setValue:[NSString stringWithFormat:@"%zd",sort] forKey:@"sort"];
    
    BaseReqApi *LoginApi=[[BaseReqApi alloc]initWithRequestUrl:@"searchGoods.json" andrequestTime:5 andParams:reqDict andRequestMethod:YTKRequestMethodPOST andCache:NO andCacheTime:0 andPostToken:NO];
    [MBProgressHUD showMessage:@"加载中..." afterDeleay:10 WithView:self.view];
    [LoginApi StarRequest:^(TBResponseStatus responseStatus, NSString *message, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (responseStatus==1) {
            self.currentPage ++;
            GoodsShopModel *model = [GoodsShopModel mj_objectWithKeyValues:responseObject];
            [self.tabDataArr addObjectsFromArray:model.data];
            if(model.data.count == 0)
            {
                self.Type=TBSearchNoType;
            }

            [self.tableView reloadData];
        }else if (responseStatus==0||responseStatus==2)
        {
            [MBProgressHUD showError:message toView:self.view];
        }else{
            [MBProgressHUD showError:message toView:self.view];
            kWeakSelf(self);
            [self loginSuccess:^{
                [weakself searchGoodsHttp:self.sort];
            }];
        }
    }];
}

//上拉刷新
-(void)actionMJHeaderRefresh{
    self.currentPage = 1;
    [self.tabDataArr removeAllObjects];
    [self searchGoodsHttp:self.sort];
}
//下拉加载
-(void)actionMJFooterLoadMore{
    [self searchGoodsHttp:self.sort];
}

- (void)creatMainTableView
{
    [self.view addSubview:self.HeadView];
    kWeakSelf(self);
    self.HeadView.headClick = ^(NSInteger sort) {
        [weakself.tabDataArr removeAllObjects];
        [weakself searchGoodsHttp:sort];
    };
    
    self.tableView.frame = CGRectMake(0, 40, KScreenWidth, KScreenHeight-64-40);
    self.tableviewstyle = UITableViewStyleGrouped;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.tableView.tableHeaderView = self.HeadView;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RightTableViewCell" bundle:nil] forCellReuseIdentifier:@"RightCell"];
    
    [self configureNeedShowEmptyDataSetScrollView:self.tableView];

    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *dataArr = self.tabDataArr[section];
    return dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.tabDataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    footview.backgroundColor = CViewBgColor;
    return footview;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.创建cell
    RightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RightCell"];
    if(cell == nil)
    {
        cell = [[RightTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"RightCell"];
    }
    kWeakSelf(self);
    cell.selectSpecBlock = ^(GoodsShopData *shopmodel) {
        
    };
    
    GoodsShopData *shopData = self.tabDataArr[indexPath.section][indexPath.row];
    [cell refreshData:shopData];
    return cell;
}

- (MultilHeadView*)HeadView
{
    if(_HeadView == nil)
    {
        _HeadView = [[MultilHeadView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 40)];
    }
    return _HeadView;
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
