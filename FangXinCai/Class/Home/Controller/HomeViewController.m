//
//  HomeViewController.m
//  FangXinCai
//
//  Created by ios-1 on 2018/1/8.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "HomeViewController.h"
#import "SearchResultViewController.h"
#import "ChildAccountTableViewCell.h"
#import "PanicbuyingViewController.h"
#import "SearchBarNavView.h"
#import "SDCycleScrollView.h"
#import "StoreManagerModel.h"
#import "LoginViewController.h"
#import "BasePanicViewController.h"
#import "ShopDetailViewController.h"
#import "RightTableViewCell.h"
#import "ShopBanaModel.h"
#import "CartViewModel.h"
#import "CartShopManager.h"
#import "PageClassView.h"

@interface HomeViewController ()<PYSearchViewControllerDelegate,UITextFieldDelegate>
@property (nonatomic , strong) PageClassView *pageclassview;
@end

@implementation HomeViewController
{
    BOOL isfresh;         //是否刷新列表
    BOOL isDragging;      //是否滑动列表
    CGFloat oldOffsetY;   //记录列表上一次滑动的位置
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CViewBgColor;
    //隐藏导航栏
    self.isHidenNaviBar = YES;
    self.isShowLiftBack = NO;//每个根视图需要设置该属性为NO，否则会出现导航栏异常
    
    [self creatMainTableView];
    [self creatNavagationView];
    
    [self creatData];
}

- (void)creatData
{
//    for(int i =0; i <3; i++)
//    {
//        StoreManagerModel *model = [StoreManagerModel new];
//        model.isSelected = NO;
//        [self.tabDataArr addObject:model];
//    }
//    if(self.tabDataArr.count == 0)
//    {
//        self.Type=TBNODateType;
//    }
//    [self.tableView reloadData];
    
    [self getBananHttp];
    [self getNinePointShopHttp];
    [self getgoodsCollectHttp];
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

//主列表
- (void)creatMainTableView
{
    self.tableView.frame = CGRectMake(0, 64, KScreenWidth, KScreenHeight-64-49);
    self.tableviewstyle = UITableViewStyleGrouped;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = self.hometabHeadView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RightTableViewCell" bundle:nil] forCellReuseIdentifier:@"RightCell"];
    
    [self configureNeedShowEmptyDataSetScrollView:self.tableView];
    
    [self.view addSubview:self.tableView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    ShopCartModel *model = self.tabDataArr[section];
    
    return model.list.count?40:0;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
    headview.backgroundColor = RGBCOLOR(250, 250, 250);
    
    ShopCartModel *model = self.tabDataArr[section];
    UILabel *headlab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 40)];
    headlab.font = [UIFont systemFontOfSize:KZOOM6pt(28)];
    headlab.textColor = KGrayColor;
    headlab.text = model.cat_name;
    [headview addSubview:headlab];
    
    return headview;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.tabDataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    ShopCartModel *model = self.tabDataArr[section];
    return model.list.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShopCartData *shopdata = [ShopCartData alloc];
    if(self.tabDataArr.count)
    {
        ShopCartModel *model = self.tabDataArr[indexPath.section];
        shopdata = model.list[indexPath.row];
    }
    
    ShopDetailViewController *shopdetail = [[ShopDetailViewController alloc]init];
    shopdetail.goods_id = shopdata.goods_id;
    shopdetail.spec_key = shopdata.spec_key;
    [self.navigationController pushViewController:shopdetail animated:YES];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShopCartData *shopdata = [ShopCartData alloc];
    if(self.tabDataArr.count)
    {
        ShopCartModel *model = self.tabDataArr[indexPath.section];
        shopdata = model.list[indexPath.row];
    }
    // 1.创建cell
    RightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RightCell"];
    if(cell == nil)
    {
        cell = [[RightTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"RightCell"];
    }
    
    kWeakSelf(self);
    kWeakSelf(cell);
    //清除商品
    cell.collectBlock = ^(GoodsShopData *shopmodel) {
        
        [weakself creatAltViewTitle:@"温馨提示" Message:@"是否要清除此商品" Sure:@"确定" Cancle:@"取消" SureBlock:^(id data) {
            
            [[CartShopManager cartShopManarer] goodsCollectHttp:shopmodel.goods_id Success:^(id data) {
                [weakself deleteShopCat:indexPath];
            }];
            
        } CaccleBlock:^(id data) {
            
        }];
    };
    
    //加购物车
    cell.addCartBlock = ^(NSDictionary *data, BOOL add) {
        if(add)
        {
            CGRect parentRect = [weakcell convertRect:weakcell.addactiveBtn.frame toView:weakself.view];
            // 这里是动画开始的方法
            [weakself joinCartAnimationWithRect:parentRect];
            
        }else{
            [self changeTabbarCartNum];
        }
        
    };
    [cell refreshTextData:shopdata];

    return cell;
}

#pragma mark 滑动改变title
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    NSLog(@"*********section=%zd",section);
    if(isDragging && !isfresh)
    {
        self.selectHeadIndex = section;
        [self.pageclassview setTitle:self.selectHeadIndex];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section NS_AVAILABLE_IOS(6_0);
{
    NSLog(@"*********2222222section=%zd",section);
    if(isDragging && !isfresh)
    {
        if (self.tableView.contentOffset.y > oldOffsetY) {
            // 上滑
            self.selectHeadIndex = section+1;
            
            [self.pageclassview setTitle:self.selectHeadIndex];
        }
        else{
            // 下滑
            self.selectHeadIndex = section-1;
            
            [self.pageclassview setTitle:self.selectHeadIndex];
        }
    }
}

- (void)scrollViewDidChangeAdjustedContentInset:(UIScrollView *)scrollView
{
    isfresh = NO;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    isDragging = YES;
    
    // 获取开始拖拽时tableview偏移量
    oldOffsetY = self.tableView.contentOffset.y;
}
#pragma mark 清除单个商品
- (void)deleteShopCat:(NSIndexPath*)indexPath
{
    ShopCartModel *model = self.tabDataArr[indexPath.section];
    NSMutableArray *dataArray = [NSMutableArray arrayWithArray:model.list];
    
    [dataArray removeObjectAtIndex:indexPath.row];
    
    model.list = dataArray;
    if(model.list.count == 0)
    {
        [self.tabDataArr removeObjectAtIndex:indexPath.section];
    }else{
        [self.tabDataArr replaceObjectAtIndex:indexPath.section withObject:model];
    }
    
    [self.tableView reloadData];
}

#pragma mark *********************搜索***********************
- (void)textFieldDidBeginEditing
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
    
    [self.navigationController pushViewController:nav animated:YES];
    
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

#pragma mark 首页分类
- (void)myClass:(NSInteger)selectIndex
{
    NSLog(@"分类=%zd",selectIndex);
    switch (selectIndex) {
        case 10000:
            
            break;
        case 10001:
            
            break;
        case 10002:
            
            break;
        case 10003:
            
            break;
            
        default:
            break;
    }
}
#pragma mark 特价专区
- (void)specialArea:(NSInteger)selectIndex
{
    NSLog(@"特价专区商品=%zd",selectIndex);
    PanicbuyingViewController *panic = [PanicbuyingViewController new];
    [self.navigationController pushViewController:panic animated:YES];
}
#pragma mark 9.9专区商品
- (void)moreNine
{
    NSLog(@"更多");
//    BasePanicViewController *basePanic = [BasePanicViewController new];
//    [self.navigationController pushViewController:basePanic animated:YES];
    
    ShopDetailViewController *shopdetail = [[ShopDetailViewController alloc]init];
//    shopdetail.goods_id = shopdata.goods_id;
//    shopdetail.spec_key = shopdata.spec_key;
    [self.navigationController pushViewController:shopdetail animated:YES];
}
- (void)niniPointShop:(NSInteger)selectIndex
{
    NSLog(@"9.9专区商品=%zd",selectIndex);
}

- (HometabHeadView*)hometabHeadView
{
    if(_hometabHeadView == nil)
    {
        _hometabHeadView = [[HometabHeadView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KZOOM6pt(1180))];
        _hometabHeadView.backgroundColor = KWhiteColor;
        
        kWeakSelf(self);
        _hometabHeadView.myclassIndexBlock = ^(NSInteger selectIndex) {
            [weakself myClass:selectIndex];
        };
        _hometabHeadView.specialAreaBlock = ^(NSInteger selectIndex) {
            [weakself specialArea:selectIndex];
        };
        _hometabHeadView.moreNinePointBlock = ^{
            [weakself moreNine];
        };
        _hometabHeadView.ninePointBlock = ^(NSInteger selectIndex) {
            [weakself niniPointShop:selectIndex];
        };
    }
    return _hometabHeadView;
}

#pragma mark ****************网络请求****************
//轮播图
- (void)getBananHttp
{
    NSString *token = [KUserDefaul objectForKey:User_Token];
    NSMutableDictionary *reqDict = [NSMutableDictionary dictionary];
    [reqDict setValue:token forKey:@"token"];
    
    BaseReqApi *LoginApi=[[BaseReqApi alloc]initWithRequestUrl:@"sliderAd.json" andrequestTime:5 andParams:reqDict andRequestMethod:YTKRequestMethodPOST andCache:NO andCacheTime:0 andPostToken:NO];
    [MBProgressHUD showMessage:@"加载中..." afterDeleay:10 WithView:self.view];
    [LoginApi StarRequest:^(TBResponseStatus responseStatus, NSString *message, id responseObject) {
        [MBProgressHUD hideHUD];
        
        if (responseStatus==1) {
            ShopBanaModel *banaModel = [ShopBanaModel mj_objectWithKeyValues:responseObject];
            NSMutableArray *imagesUrl = [NSMutableArray array];
            for(ShopBanaData * model in banaModel.data)
            {
                NSString *imageurl = [NSString stringWithFormat:@"%@%@",ReqUrl,model.ad_code];
                [imagesUrl addObject:imageurl];
            }
            //刷新轮播图
            [self.hometabHeadView refreshBanaImages:imagesUrl];
            NSLog(@"banaModel = %@",banaModel);
        }else if (responseStatus==0||responseStatus==2)
        {
            [MBProgressHUD showError:message toView:self.view];
        }else{
            [MBProgressHUD showError:message toView:self.view];
            
            [self loginSuccess:^{
                
            }];
        }
    }];
}
//固定金额商品
- (void)getNinePointShopHttp
{
    NSString *token = [KUserDefaul objectForKey:User_Token];
    NSMutableDictionary *reqDict = [NSMutableDictionary dictionary];
    [reqDict setValue:token forKey:@"token"];
    [reqDict setValue:@"1" forKey:@"page"];
    [reqDict setValue:@"10" forKey:@"pageSize"];
    [reqDict setValue:@"2" forKey:@"sort"];//排序：1商品名,2销量,3价格
    
    BaseReqApi *LoginApi=[[BaseReqApi alloc]initWithRequestUrl:@"onlyPriceGoods.json" andrequestTime:5 andParams:reqDict andRequestMethod:YTKRequestMethodPOST andCache:NO andCacheTime:0 andPostToken:NO];
    [MBProgressHUD showMessage:@"加载中..." afterDeleay:10 WithView:self.view];
    [LoginApi StarRequest:^(TBResponseStatus responseStatus, NSString *message, id responseObject) {
        [MBProgressHUD hideHUD];
        
        if (responseStatus==1) {
            
        }else if (responseStatus==0||responseStatus==2)
        {
            [MBProgressHUD showError:message toView:self.view];
        }else{
            [MBProgressHUD showError:message toView:self.view];
            [self loginSuccess:^{
                
            }];
        }
    }];
}

//我的清单商品
- (void)getgoodsCollectHttp
{
    NSString *token = [KUserDefaul objectForKey:User_Token];
    NSMutableDictionary *reqDict = [NSMutableDictionary dictionary];
    [reqDict setValue:token forKey:@"token"];
    
    
    BaseReqApi *LoginApi=[[BaseReqApi alloc]initWithRequestUrl:@"collectedGoods.json" andrequestTime:5 andParams:reqDict andRequestMethod:YTKRequestMethodPOST andCache:NO andCacheTime:0 andPostToken:NO];
    [MBProgressHUD showMessage:@"加载中..." afterDeleay:10 WithView:kAppWindow];
    [LoginApi StarRequest:^(TBResponseStatus responseStatus, NSString *message, id responseObject) {
        [MBProgressHUD hideHUDForView:kAppWindow];
        [self.tableView.mj_header endRefreshing];
        
        if (responseStatus==1) {
            
            CartViewModel *model = [CartViewModel mj_objectWithKeyValues:responseObject];
            [self.allDataArr addObjectsFromArray:model.data];
            if(model.data.count == 0)
            {
                self.Type=TBNODateType;
            }
            [self handleData:self.allDataArr];
            
        }else if (responseStatus==0||responseStatus==2)
        {
            [MBProgressHUD showError:message toView:kAppWindow];
        }else{
            [MBProgressHUD showError:message toView:kAppWindow];
            kWeakSelf(self);
            [self loginSuccess:^{
                [weakself getgoodsCollectHttp];
            }];
        }
    }];
}

- (void)handleData:(NSArray*)dataArray
{
    if(dataArray.count==0)
    {
        return;
    }
    
    for(int i =0;i<dataArray.count;i++)
    {
        ShopCartModel *cartModel = dataArray[i];
        
        NSMutableArray *cartlist = [NSMutableArray array];
        for(int j=0;j<cartModel.list.count;j++)
        {
            NSArray *arr = cartModel.list[j];
            for(int k=0;k<arr.count;k++)
            {
                ShopCartData *cartData = arr[k];
                [cartlist addObject:cartData];
            }
        }
        
        cartModel.list = [NSArray arrayWithArray:cartlist];
        [self.tabDataArr addObject:cartModel];
        [self.headeArray addObject:cartModel.cat_name];
    }
    
    [self.tableView reloadData];
}

- (PageClassView*)setPageClassView:(NSArray*)titleArr
{
    PageClassView *pageclassview = [[PageClassView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 40) TitleArr:titleArr];
    pageclassview.backgroundColor = basegreenColor;
    pageclassview.selectBlock = ^(NSInteger index) {
        
        isDragging = NO;
        NSIndexPath * dayOne = [NSIndexPath indexPathForRow:0 inSection:index];
        [self.tableView scrollToRowAtIndexPath:dayOne atScrollPosition:UITableViewScrollPositionTop animated:YES];
    };
    self.pageclassview = pageclassview;
    return self.pageclassview;
}
#pragma mark ***************加入购物车动画*******************
-(void)joinCartAnimationWithRect:(CGRect)rect
{
    self.endPoint_x = KScreenWidth*0.75;
    self.endPoint_y = KScreenHeight;
    
    CGFloat startX = rect.origin.x;
    CGFloat startY = rect.origin.y;
    
    self.path= [UIBezierPath bezierPath];
    [self.path moveToPoint:CGPointMake(startX, startY)];
    
    //三点曲线
    [self.path addCurveToPoint:CGPointMake(self.endPoint_x, self.endPoint_y)
                 controlPoint1:CGPointMake(startX, startY)
                 controlPoint2:CGPointMake(startX - 100, startY - 100)];
    self.dotLayer = [CALayer layer];
    self.dotLayer.backgroundColor = [UIColor redColor].CGColor;
    self.dotLayer.frame = CGRectMake(0, 0, 20, 20);
    self.dotLayer.cornerRadius = 10;
    [self.view.layer addSublayer:_dotLayer];
    [self groupAnimation];
    
}
#pragma mark - 组合动画
-(void)groupAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = _path.CGPath;
    animation.rotationMode = kCAAnimationRotateAuto;
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"alpha"];
    alphaAnimation.duration = 0.5f;
    alphaAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    alphaAnimation.toValue = [NSNumber numberWithFloat:0.1];
    alphaAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup *groups = [CAAnimationGroup animation];
    groups.animations = @[animation,alphaAnimation];
    groups.duration = 0.8f;
    groups.removedOnCompletion = NO;
    groups.fillMode = kCAFillModeForwards;
    groups.delegate = self;
    [groups setValue:@"groupsAnimation" forKey:@"animationName"];
    [_dotLayer addAnimation:groups forKey:nil];
    [self performSelector:@selector(removeFromLayer:) withObject:_dotLayer afterDelay:0.8f];
}
- (void)removeFromLayer:(CALayer *)layerAnimation{
    //加购物车动画完毕刷新tabbar上购物车数量
    [self changeTabbarCartNum];
    
    [layerAnimation removeFromSuperlayer];
}
#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if ([[anim valueForKey:@"animationName"]isEqualToString:@"groupsAnimation"]) {
        
        CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        shakeAnimation.duration = 0.25f;
        shakeAnimation.fromValue = [NSNumber numberWithFloat:0.9];
        shakeAnimation.toValue = [NSNumber numberWithFloat:1];
        shakeAnimation.autoreverses = YES;
    }
}
- (NSMutableArray*)tabDataArr
{
    if(_tabDataArr == nil)
    {
        _tabDataArr = [NSMutableArray array];
    }
    return _tabDataArr;
}
- (NSMutableArray*)allDataArr
{
    if(_allDataArr == nil)
    {
        _allDataArr = [NSMutableArray array];
    }
    return _allDataArr;
}
- (NSMutableArray*)headeArray
{
    if(_headeArray == nil)
    {
        _headeArray = [NSMutableArray array];
    }
    return _headeArray;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
