//
//  StoreManagViewController.m
//  FangXinCai
//
//  Created by ios-1 on 2018/1/21.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "StoreManagViewController.h"
#import "SearchResultViewController.h"
#import "ChildAccountViewController.h"
#import "StoreManagerTableViewCell.h"
#import "BuildStoreViewController.h"
#import "StoreManagerModel.h"
@interface StoreManagViewController ()

@end

@implementation StoreManagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"门店管理";
    
    [self creatMainTableView];
    [self creatFootButton];
    [self creatData];
}

- (void)creatData
{
    NSArray *namearr = @[@"张三的食堂",@"李四的食堂",@"王五的食堂"];
    for(int i =0; i <3; i++)
    {
        StoreManagerModel *model = [StoreManagerModel new];
        model.isSelected = NO;
        model.nickname = namearr[i];
        [self.tabDataArr addObject:model];
        [self.originalArray addObject:model];
    }
    if(self.tabDataArr.count == 0)
    {
        self.Type=TBNODateType;
    }
    [self.tableView reloadData];
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
    
    [self.tableView registerNib:[UINib nibWithNibName:@"StoreManagerTableViewCell" bundle:nil] forCellReuseIdentifier:@"StoreManagerCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self configureNeedShowEmptyDataSetScrollView:self.tableView];
    
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tabDataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    for(StoreManagerModel *model in self.tabDataArr)
    {
        model.isSelected = NO;
    }
    StoreManagerModel *model = self.tabDataArr[indexPath.row];
    model.isSelected = YES;
    
    [tableView reloadData];
    
    [self comingStore:NO];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StoreManagerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StoreManagerCell"];
    if(!cell)
    {
        cell = [[StoreManagerTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"StoreManagerCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    kWeakSelf(self);
    //子账号管理
    cell.childAccountBlock = ^(StoreManagerModel *model) {
        [weakself goChildAccountManager];
    };
    //门店编辑
    cell.storeEditBlock = ^(StoreManagerModel *model) {
        [weakself comingStore:YES];
    };
    //门店删除
    cell.storeDeleateBlock = ^(StoreManagerModel *model) {
        [weakself deleteStore:model];
    };
    
    StoreManagerModel *model = self.tabDataArr[indexPath.row];
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

- (void)goChildAccountManager
{
    ChildAccountViewController *childAccount = [[ChildAccountViewController alloc]init];
    [self.navigationController pushViewController:childAccount animated:YES];
}
//新建门店
- (void)addStore:(UIButton*)sender
{
    BuildStoreViewController *build = [BuildStoreViewController new];
    build.storetype = BuildStoreType;
    build.title = @"新建门店";
    [self.navigationController pushViewController:build animated:YES];
}
//进入门店
- (void)comingStore:(BOOL)isedit
{
    BuildStoreViewController *build = [BuildStoreViewController new];
    build.storetype = DetailStoreType;
    build.title = @"门店详情";
    [self.navigationController pushViewController:build animated:YES];
}
//删除门店
- (void)deleteStore:(StoreManagerModel*)model
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否删除此门店" preferredStyle:UIAlertControllerStyleAlert];
    kWeakSelf(self);
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定"style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        [weakself deleteStoreHttp:model];
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

#pragma mark 网络请求
- (void)deleteStoreHttp:(StoreManagerModel*)model
{
    NSLog(@"删除");
    [self.tabDataArr removeObject:model];
    [self.tableView reloadData];
    [MBProgressHUD show:@"删除成功" icon:nil view:self.view];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
