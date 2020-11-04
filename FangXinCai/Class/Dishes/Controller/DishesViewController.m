//
//  DishesViewController.m
//  FangXinCai
//
//  Created by ios-1 on 2018/1/8.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "DishesViewController.h"
#import "SearchResultViewController.h"
#import "DishesShopViewController.h"
#import "SearchBarNavView.h"
#import "GoodsCategoryModel.h"

@interface DishesViewController ()<PYSearchViewControllerDelegate,UITextFieldDelegate,SGPageTitleViewDelegate, SGPageContentViewDelegate>
@property (nonatomic , strong) SGPageTitleView *pageTitleView;
@property (nonatomic , strong) SGPageContentView *pageContentView;
@property (nonatomic , strong) DishesShopViewController *dishesShop;

@end

@implementation DishesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CViewBgColor;
    //隐藏导航栏
    self.isHidenNaviBar = YES;
    self.isShowLiftBack = NO;//每个根视图需要设置该属性为NO，否则会出现导航栏异常
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSelectedIndex:) name:@"changeSelectedIndex" object:nil];
    
    [self creatNavagationView];

    [self goodsCatoryHttp];
}

//导航条
- (void)creatNavagationView
{
    SearchBarNavView *searhview = [[SearchBarNavView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 64) back:YES];
    [self.view addSubview:searhview];
    kWeakSelf(self);
    
    //textField代理方法回调
    searhview.textFieldBlock = ^(NSString *text) {
        [weakself textFieldDidBeginEditing];
    };
    
    searhview.customerBlock = ^{
        
    };
    
    searhview.backBlock = ^{
        
    };
}

- (void)changeSelectedIndex:(NSNotification *)noti {
    _pageTitleView.resetSelectedIndex = [noti.object integerValue];
}

- (void)setupPageView:(NSArray*)titleArr {
    CGFloat pageTitleViewY = 64;

    SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
    configure.titleSelectedColor = basegreenColor;
    configure.indicatorColor     = basegreenColor;
    
    configure.indicatorAdditionalWidth = 10; // 说明：指示器额外增加的宽度，不设置，指示器宽度为标题文字宽度；若设置无限大，则指示器宽度为按钮宽度
    
    /// pageTitleView
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, pageTitleViewY, self.view.frame.size.width, 44) delegate:self titleNames:titleArr configure:configure];
    self.pageTitleView.backgroundColor = KWhiteColor;
    self.pageTitleView.selectedIndex = self.selectHeadIndex;
    [self.view addSubview:_pageTitleView];
    
    UILabel *linelab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 1)];
    linelab.backgroundColor = CLineColor;
    [_pageTitleView addSubview:linelab];
    
    self.dishesShop = [[DishesShopViewController alloc]init];
    self.dishesShop.CategoryDataArray = self.CategoryDataArry;
    [self addChildViewController:self.dishesShop];
    
    self.dishesShop.view.frame = CGRectMake(0, CGRectGetMaxY(_pageTitleView.frame), KScreenWidth, KScreenHeight-CGRectGetMaxY(_pageTitleView.frame)-CGRectGetHeight(_pageTitleView.frame));
    [self.view addSubview:self.dishesShop.view];
    
    if(self.selectHeadIndex)
    {
        [self.pageTitleView setPageTitleViewWithProgress:KScreenWidth*self.selectHeadIndex originalIndex:self.selectHeadIndex targetIndex:self.selectHeadIndex];
    }
}

- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex {
    [self.pageContentView setPageCententViewCurrentIndex:selectedIndex];
    
    //刷新二级分类商品
    [self.dishesShop reloadData:self.CategoryDataArry SelectIndex:selectedIndex];
}

- (void)pageContentView:(SGPageContentView *)pageContentView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}
#pragma mark ********************网络请求********************
- (void)goodsCatoryHttp
{
    NSString *token = [KUserDefaul objectForKey:User_Token];
    NSMutableDictionary *reqDict = [NSMutableDictionary dictionary];
    [reqDict setValue:token forKey:@"token"];
    
    BaseReqApi *LoginApi=[[BaseReqApi alloc]initWithRequestUrl:@"goodsCategory.json" andrequestTime:5 andParams:reqDict andRequestMethod:YTKRequestMethodPOST andCache:NO andCacheTime:0 andPostToken:NO];
    [MBProgressHUD showMessage:@"加载中..." afterDeleay:10 WithView:self.view];
    [LoginApi StarRequest:^(TBResponseStatus responseStatus, NSString *message, id responseObject) {
        [MBProgressHUD hideHUD];
        
        if (responseStatus==1) {
            GoodsCategoryModel *model = [GoodsCategoryModel mj_objectWithKeyValues:responseObject];
            [self.CategoryDataArry addObjectsFromArray:model.data];
            NSMutableArray *titles = [NSMutableArray array];
            for(GoodsCategoryData *categoryData in model.data)
            {
                [titles addObject:[NSString stringWithFormat:@"%@",categoryData.name]];
            }
            
            [self setupPageView:titles];
        }else if (responseStatus==0||responseStatus==2)
        {
            [MBProgressHUD showError:message toView:self.view];
        }else{
            [MBProgressHUD showError:message toView:self.view];
            kWeakSelf(self);
            [self loginSuccess:^{
                [weakself goodsCatoryHttp];
            }];
        }
    }];
}

#pragma mark *********************搜索***********************
- (void)textFieldDidBeginEditing
{
    // 1.创建热门搜索
    NSArray *hotSeaches = @[@"大白菜", @"小白菜", @"阳澄湖大闸蟹", @"小龙虾", @"秋刀鱼", @"武昌鱼", @"牛肉", @"羊肉"];
    hotSeaches = @[];
    // 2. 创建控制器
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:@"请输入商品名称" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        // 开始搜索执行以下代码
        // 如：跳转到指定控制器
        SearchResultViewController *search = [SearchResultViewController new];
        search.title = searchText;
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

#pragma mark - PYSearchViewControllerDelegate
- (void)searchViewController:(PYSearchViewController *)searchViewController searchTextDidChange:(UISearchBar *)seachBar searchText:(NSString *)searchText
{
    if (searchText.length) { // 与搜索条件再搜索
        // 根据条件发送查询（这里模拟搜索）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 搜索完毕
            // 显示建议搜索结果
            NSMutableArray *searchSuggestionsM = [NSMutableArray array];
            for (int i = 0; i < arc4random_uniform(5) + 10; i++) {
                NSString *searchSuggestion = [NSString stringWithFormat:@"搜索建议 %d", i];
                [searchSuggestionsM addObject:searchSuggestion];
            }
            // 返回
            searchViewController.searchSuggestions = searchSuggestionsM;
        });
    }
}

- (NSMutableArray*)CategoryDataArry
{
    if(_CategoryDataArry == nil)
    {
        _CategoryDataArry = [NSMutableArray array];
    }
    return _CategoryDataArry;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
