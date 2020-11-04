//
//  BaseSearchViewController.m
//  FangXinCai
//
//  Created by ios-1 on 2018/1/21.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "BaseSearchViewController.h"
#import "ZYPinYinSearch.h"
#import "PickShopModel.h"
@interface BaseSearchViewController ()
@property (nonatomic , strong) NSString *searchBarStr;
@end

@implementation BaseSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavView];
}
- (void)viewWillAppear:(BOOL)animated
{
    UIView *searchbar = [self.navigationController.navigationBar viewWithTag:1000];
    [searchbar removeFromSuperview];
    [self.searchBar removeFromSuperview];
}
- (void)viewWillDisappear:(BOOL)animated
{
    UIView *searchbar = [self.navigationController.navigationBar viewWithTag:1000];
    [searchbar removeFromSuperview];
    [self.searchBar removeFromSuperview];
}
- (void)searchBarHttp:(NSString*)searchStr
{
    NSString *token = [KUserDefaul objectForKey:User_Token];
    NSMutableDictionary *reqDict = [NSMutableDictionary dictionary];
    [reqDict setValue:token forKey:@"token"];
    if(searchStr)
    {
        [reqDict setValue:searchStr forKey:@"keyword"];
    }
    
    BaseReqApi *Api=[[BaseReqApi alloc]initWithRequestUrl:@"pickShop.json" andrequestTime:5 andParams:reqDict andRequestMethod:YTKRequestMethodPOST andCache:NO andCacheTime:0 andPostToken:NO];
    [self showLoadingAnimation];
    [Api StarRequest:^(TBResponseStatus responseStatus, NSString *message, id responseObject) {
        [self stopLoadingAnimation];
        [self.tableView.mj_header endRefreshing];
        
        if (responseStatus == 1) {
            [self.tabDataArr removeAllObjects];

            PickShopModel *pickmodel = [PickShopModel mj_objectWithKeyValues:responseObject];
            if(pickmodel.data.count == 0)
            {
//                self.Type=TBSearchNoType;
            }else{
                [self.tabDataArr addObjectsFromArray:pickmodel.data];

                [self.tableView reloadData];
            }
        }else if (responseStatus==0||responseStatus==2)
        {
            [MBProgressHUD showError:message toView:kAppWindow];
        }else{
            
            [MBProgressHUD showError:message toView:kAppWindow];
            kWeakSelf(self);
            [self loginSuccess:^{
                [weakself searchBarHttp:self.searchBarStr];
            }];
        }
    }];
}
//导航栏上的搜索
-(void)setupNavView{
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(0, 0, 20, 20);
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"searchImage"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(storeSearch) forControlEvents:UIControlEventTouchUpInside];
    _searchButton= [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    self.navigationItem.rightBarButtonItem = _searchButton;
}

#pragma -mark searchBarDelegate
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.navigationItem.rightBarButtonItem = _searchButton;
    [self.searchBar resignFirstResponder];
    [self.searchBar removeFromSuperview];
    UIView *searchbar = [self.navigationController.navigationBar viewWithTag:1000];
    [searchbar removeFromSuperview];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if ([searchBar.text isEqualToString:@""]) {
        
        [self.tabDataArr removeAllObjects];
        [self.tabDataArr addObjectsFromArray:self.originalArray];
    }
    else{
#warning 主要功能，调用方法实现搜索
//        [ZYPinYinSearch searchByPropertyName:@"shops_name" withOriginalArray:self.originalArray searchText:searchBar.text success:^(NSArray *results) {
//
//            [self.tabDataArr removeAllObjects];
//            [self.tabDataArr addObjectsFromArray:results];
//            if(self.isSelectStore)
//            {
//                self.tableView.tableHeaderView = self.tabDataArr.count?self.tableHeadView:self.noresultHeadView;
//            }
//            [self.tableView reloadData];
//        } failure:^(NSString *errorMessage) {
//
//        }];
        self.searchBarStr = searchBar.text;
        [self searchBarHttp:searchBar.text];
    }
    
    self.navigationItem.rightBarButtonItem = _searchButton;
    [self.searchBar resignFirstResponder];
    [self.searchBar removeFromSuperview];

    UIView *searchbar = [self.navigationController.navigationBar viewWithTag:1000];
    [searchbar removeFromSuperview];
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if ([searchText isEqualToString:@""]) {
        
        [self.tabDataArr removeAllObjects];
        [self.tabDataArr addObjectsFromArray:self.originalArray];
        if(self.isSelectStore)
        {
            self.tableView.tableHeaderView = self.tabDataArr.count?self.tableHeadView:self.noresultHeadView;
        }
        [self.tableView reloadData];
    }
    else{
#warning 主要功能，调用方法实现搜索
        [ZYPinYinSearch searchByPropertyName:@"shops_name" withOriginalArray:self.originalArray searchText:searchBar.text success:^(NSArray *results) {
            [self.tabDataArr removeAllObjects];
            [self.tabDataArr addObjectsFromArray:results];
            if(self.isSelectStore)
            {
                self.tableView.tableHeaderView = self.tabDataArr.count?self.tableHeadView:self.noresultHeadView;
            }
            [self.tableView reloadData];
        } failure:^(NSString *errorMessage) {
            
        }];
    }
    
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    //取消按钮 重置
    UITextField *tf;
    for (UIView *view in [[_searchBar.subviews objectAtIndex:0] subviews]) {
        if ([view isKindOfClass:[UITextField class]]) {
            tf=(UITextField *)view;
        }
    }
    [self.searchBar setShowsCancelButton:YES animated:YES];
    self.searchBar.showsCancelButton=YES;
    for(UIView *subView in searchBar.subviews){
        if([subView isKindOfClass:UIButton.class]){
            [(UIButton*)subView setTitle:@"取消" forState:UIControlStateNormal];
            UIButton *button=(UIButton*)subView;
            button.titleLabel.textColor=[UIColor whiteColor];
        }
    }
    //取消字体变白
    UIButton *cancelButton;
    UIView *topView = self.searchBar.subviews[0];
    for (UIView *subView in topView.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
            cancelButton = (UIButton*)subView;
        }
    }
    if (cancelButton) {
        NSLog(@"%@",NSStringFromCGRect(cancelButton.frame));
        //Set the new title of the cancel button
        [cancelButton setTitle:@"       " forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cancelButton.titleLabel.textColor=[UIColor whiteColor];
        cancelButton.titleLabel.font = [UIFont fontWithName:@"Heiti SC" size:20];
        [cancelButton removeFromSuperview];
        UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(-5, -5,40,40)];
        lable.textAlignment=NSTextAlignmentLeft;
        lable.text=@"取消";
        lable.textColor=[UIColor whiteColor];
        [cancelButton addSubview:lable];
        lable.font = [UIFont fontWithName:@"Heiti SC" size:16];
        [cancelButton addSubview:lable];
        
    }
    UIButton * button;
    [button setTintColor:  nil];
    
}

#pragma mark 门店搜索
- (void)storeSearch
{
    self.navigationItem.rightBarButtonItems = nil;
    [self.navigationController.navigationBar addSubview:self.searchBar];
}

- (UISearchBar*)searchBar
{
    _searchBar = [[UISearchBar alloc] init];
    _searchBar.frame = CGRectMake(40, 20,KScreenWidth-40, 0);
    [_searchBar setContentMode:UIViewContentModeBottomLeft];
    _searchBar.delegate = self;
    _searchBar.backgroundColor=[UIColor clearColor];
    _searchBar.searchBarStyle=UISearchBarStyleDefault;
    _searchBar.showsCancelButton =YES;
    _searchBar.tintColor = KGrayColor;
    _searchBar.tag=1000;
    _searchBar.placeholder = @"请输入门店名地址";
    [_searchBar becomeFirstResponder];
    
    return _searchBar;
}
- (UIView*)tableHeadView
{
    if(_tableHeadView == nil)
    {
        _tableHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
        _tableHeadView.backgroundColor = RGBCOLOR(255, 244, 220);
        
        UIImageView *titleimage = [UIImageView new];
        titleimage.image = [UIImage imageNamed:@"提示"];
        [_tableHeadView addSubview:titleimage];
        
        UILabel *titlelab = [UILabel new];
        titlelab.text = @"选择门店完成注册";
        titlelab.textColor = baseyellowColor;
        titlelab.font = [UIFont systemFontOfSize:KZOOM6pt(26)];
        [_tableHeadView addSubview:titlelab];
        
        [titleimage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(5);
            make.left.mas_equalTo(10);
            make.width.height.mas_equalTo(20);
        }];
        
        [titlelab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.height.equalTo(titleimage);
            make.left.equalTo(titleimage).offset(30);
            make.width.mas_equalTo(200);
        }];
    }
    return _tableHeadView;
}

- (UIView*)noresultHeadView
{
    if(_noresultHeadView == nil)
    {
        _noresultHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
        
        UILabel *titlelab = [UILabel new];
        titlelab.text = @"没有找到你搜索的门店";
        titlelab.textColor = KGrayColor;
        titlelab.font = [UIFont systemFontOfSize:KZOOM6pt(26)];
        [_noresultHeadView addSubview:titlelab];
        
        [titlelab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(5);
            make.left.mas_equalTo(10);
            make.width.mas_equalTo(KScreenWidth);
            make.height.mas_equalTo(20);
        }];
    }
    return _noresultHeadView;
}
- (NSMutableArray*)tabDataArr
{
    if(_tabDataArr == nil)
    {
        _tabDataArr = [NSMutableArray array];
    }
    return _tabDataArr;
}
- (NSMutableArray*)originalArray
{
    if(_originalArray == nil)
    {
        _originalArray = [NSMutableArray array];
    }
    return _originalArray;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
