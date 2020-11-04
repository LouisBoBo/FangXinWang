//
//  StoreSelectViewController.m
//  FangXinCai
//
//  Created by ios-1 on 2018/1/21.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "StoreSelectViewController.h"
#import "SearchResultViewController.h"
#import "ChildAccountViewController.h"
#import "StoreSelectTableViewCell.h"
#import "BuildStoreViewController.h"
#import "StoreExamineViewController.h"

@interface StoreSelectViewController ()

@end

@implementation StoreSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择门店";
    self.isSelectStore = YES;
    
    [self creatMainTableView];
    [self creatFootButton];
    
    [self creatData];
}

- (void)creatData
{
    [self getpickShopHttp:NO];
}

- (void)actionMJHeaderRefresh
{
    NSLog(@"开始刷新");
    [self getpickShopHttp:YES];
}
//新建门店按钮
- (void)creatFootButton
{
    [self.view addSubview:self.footButton];
}

//主列表
- (void)creatMainTableView
{
    self.tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight-64-40);
    self.tableviewstyle = UITableViewStyleGrouped;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = self.tableHeadView;
    self.tableView.mj_footer.hidden = YES;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"StoreSelectTableViewCell" bundle:nil] forCellReuseIdentifier:@"StoreSelect"];
    
    [self configureNeedShowEmptyDataSetScrollView:self.tableView];
    
    [self.view addSubview:self.tableView];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.tableView.tableHeaderView = self.tabDataArr.count?self.tableHeadView:self.noresultHeadView;
}
- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    self.tableView.tableHeaderView = self.tabDataArr.count?self.tableHeadView:self.noresultHeadView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tabDataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StoreSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StoreSelect"];
    if(!cell)
    {
        cell = [[StoreSelectTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"StoreSelect"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    kWeakSelf(self);
    cell.claimStoreBlock = ^(PickshopData *model) {
        [weakself gotoStoreExamine:model.apply_id];//审核界面
    };
    
    PickshopData *model = self.tabDataArr[indexPath.row];
    [cell refreshData:model];
    
    return cell;
}

- (UIButton*)footButton
{
    if(_footButton == nil)
    {
        _footButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _footButton.frame = CGRectMake(0, kScreenHeight-40-64, kScreenWidth, 40);
        _footButton.backgroundColor = basegreenColor;
        _footButton.titleLabel.textColor = KWhiteColor;
        [_footButton setTitle:@"新建门店" forState:UIControlStateNormal];
        [_footButton addTarget:self action:@selector(addStore:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _footButton;
}

- (void)addStore:(UIButton*)sender
{
    NSLog(@"新建门店");
    BuildStoreViewController *build = [BuildStoreViewController new];
    build.storetype = BuildStoreType;
    build.title = @"新建门店";
    kWeakSelf(self);
    build.buildSuccess = ^(NSString *title) {
        if(weakself.selectSuccess)
        {
            weakself.selectSuccess();
        }
    };
    [self.navigationController pushViewController:build animated:YES];
}
//商户审核
- (void)gotoStoreExamine:(NSString*)applyid
{
    StoreExamineViewController *storeexamine = [StoreExamineViewController new];
    storeexamine.applyid = applyid;
    [self.navigationController pushViewController:storeexamine animated:YES];
}
#pragma mark ************网络请求****************
//获取商户列表
- (void)getpickShopHttp:(BOOL)isfresh
{
    NSString *token = [KUserDefaul objectForKey:User_Token];
    NSMutableDictionary *reqDict = [NSMutableDictionary dictionary];
    [reqDict setValue:token forKey:@"token"];
    if(self.searchBar.text.length >0)
    {
        [reqDict setValue:self.searchBar.text forKey:@"keyword"];
    }
    
    BaseReqApi *Api=[[BaseReqApi alloc]initWithRequestUrl:@"pickShop.json" andrequestTime:5 andParams:reqDict andRequestMethod:YTKRequestMethodPOST andCache:NO andCacheTime:0 andPostToken:NO];
    [self showLoadingAnimation];
    [Api StarRequest:^(TBResponseStatus responseStatus, NSString *message, id responseObject) {
        [self stopLoadingAnimation];
        [self.tableView.mj_header endRefreshing];
        
        if (responseStatus == 1) {
            isfresh?[self.tabDataArr removeAllObjects]:nil;
            isfresh?[self.originalArray removeAllObjects]:nil;
            PickShopModel *pickmodel = [PickShopModel mj_objectWithKeyValues:responseObject];
            if(pickmodel.data.count == 0)
            {
                self.Type=TBNODateType;
            }else{
                [self.tabDataArr addObjectsFromArray:pickmodel.data];
                [self.originalArray addObjectsFromArray:pickmodel.data];
                [self.tableView reloadData];
            }
        }else if (responseStatus==0||responseStatus==2)
        {
            [MBProgressHUD show:message icon:nil view:self.view];
        }else{
            
            [MBProgressHUD show:message icon:nil view:self.view];
            kWeakSelf(self);
            [self loginSuccess:^{
                [weakself getpickShopHttp:NO];
            }];
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
