//
//  StoreManagerViewController.m
//  FangXinCai
//
//  Created by ios-1 on 2018/1/17.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "StoreManagerViewController.h"
#import "SearchResultViewController.h"
#import "ChildAccountViewController.h"
#import "StoreManagerTableViewCell.h"
#import "StoreManagerModel.h"
@interface StoreManagerViewController ()<PYSearchViewControllerDelegate>

@end

@implementation StoreManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"门店管理";
    [self setupNavView];
    [self creatMainTableView];
    [self creatFootButton];
    
    [self creatData];
}

- (void)creatData
{
   
    for(int i =0; i <3; i++)
    {
        StoreManagerModel *model = [StoreManagerModel new];
        model.isSelected = NO;
        [self.tabDataArr addObject:model];
    }
    if(self.tabDataArr.count == 0)
    {
        self.Type=TBNODateType;
    }
    [self.tableView reloadData];
}
//导航栏上的搜索
-(void)setupNavView{
    [self addNavigationItemWithImageNames:@[@"searchImage"] isLeft:NO target:self action:@selector(storeSearch) tags:nil];
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
        
    };
    //门店删除
    cell.storeDeleateBlock = ^(StoreManagerModel *model) {
        
    };
    
    
    StoreManagerModel *model = self.tabDataArr[indexPath.row];
    [cell refreshData:model];
    return cell;
}

#pragma mark 门店搜索
- (void)storeSearch
{
    // 1.创建热门搜索
    NSArray *hotSeaches = @[@"大白菜", @"小白菜", @"阳澄湖大闸蟹", @"小龙虾", @"秋刀鱼", @"武昌鱼", @"牛肉", @"羊肉"];
    // 2. 创建控制器
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:@"请输入商品名称" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        // 开始搜索执行以下代码
        // 如：跳转到指定控制器
        SearchResultViewController *search = [SearchResultViewController new];
        [searchViewController.navigationController pushViewController:search animated:YES];
        
    }];
    searchViewController.searchBar.backgroundColor = CViewBgColor;
    searchViewController.searchBar.layer.cornerRadius = 15;
    
    searchViewController.hotSearchStyle = PYHotSearchStyleDefault; // 热门搜索风格为默认
    searchViewController.searchHistoryStyle = 4; // 搜索历史风格根据选择
    // 4. 设置代理
    searchViewController.delegate = self;
    // 5. 跳转到搜索控制器
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    [self presentViewController:nav  animated:NO completion:nil];
    
}

- (UIButton*)footButton
{
    if(_footButton == nil)
    {
        _footButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _footButton.frame = CGRectMake(0, kScreenHeight-40-64, kScreenWidth, 40);
        _footButton.backgroundColor = CNavBgColor;
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
- (void)addStore:(UIButton*)sender
{
    NSLog(@"新建门店");
}
- (NSMutableArray*)tabDataArr
{
    if(_tabDataArr == nil)
    {
        _tabDataArr = [NSMutableArray array];
    }
    return _tabDataArr;
}

@end
