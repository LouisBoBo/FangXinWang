//
//  BaseViewController.m
//  FangXinCai
//
//  Created by ios-1 on 2018/1/8.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "BaseViewController.h"
#import "MWPhoto.h"
#import "TB_Permiss.h"
@interface BaseViewController ()<TZImagePickerControllerDelegate,UIActionSheetDelegate>
/** MJ头部刷新 */
@property (nonatomic, strong) MJRefreshNormalHeader *bsMJRefreshHeader;
/** MJ底部刷新(底部自动刷新) */
@property (nonatomic, strong) MJRefreshAutoNormalFooter *bsMJRefreshFooter;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =KWhiteColor;
    //是否显示返回按钮
    self.isShowLiftBack = YES;
    //默认导航栏样式：黑字
    self.StatusBarStyle = UIStatusBarStyleDefault;
    self.automaticallyAdjustsScrollViewInsets = NO;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

-(void)showNoDataImage
{
    _noDataView=[[UIImageView alloc] init];
    [_noDataView setImage:[UIImage imageNamed:@"generl_nodata"]];
    [self.view.subviews enumerateObjectsUsingBlock:^(UITableView* obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UITableView class]]) {
            [_noDataView setFrame:CGRectMake(0, 0,obj.frame.size.width, obj.frame.size.height)];
            [obj addSubview:_noDataView];
        }
    }];
}

-(void)removeNoDataImage{
    if (_noDataView) {
        [_noDataView removeFromSuperview];
        _noDataView = nil;
    }
}
#pragma mark-加载视图

/**
 *  加载视图
 */
- (void)showLoadingAnimation
{
//    [MBProgressHUD showActivityMessageInView:@"加载中..." timer:10.0];
    [MBProgressHUD showMessage:@"加载中..." afterDeleay:10 WithView:self.view];
}
/**
 *  停止加载
 */
- (void)stopLoadingAnimation
{
    [MBProgressHUD hideHUD];
}
#pragma mark *******************列表及上下拉刷新******************
/**
 *  懒加载UITableView
 *
 *  @return UITableView
 */
- (UITableView *)tableView
{
    if (_tableView == nil) {
        
        self.tableviewstyle = !self.tableviewstyle?UITableViewStylePlain:self.tableviewstyle;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - kTopHeight -kTabBarHeight) style:self.tableviewstyle];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        
        //头部刷新
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(actionMJHeaderRefresh)];
        header.automaticallyChangeAlpha = YES;
        header.lastUpdatedTimeLabel.hidden = YES;
        _tableView.mj_header = header;
        
        //底部刷新
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(actionMJFooterLoadMore)];
        
        _tableView.backgroundColor=CViewBgColor;
        _tableView.scrollsToTop = YES;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

/**
 *  懒加载collectionView
 *
 *  @return collectionView
 */
- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth , KScreenHeight - kTopHeight - kTabBarHeight) collectionViewLayout:flow];
        
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(actionMJHeaderRefresh)];
        header.automaticallyChangeAlpha = YES;
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        _collectionView.mj_header = header;
        
        //底部刷新
        _collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(actionMJFooterLoadMore)];
    
        _collectionView.backgroundColor=CViewBgColor;
        _collectionView.scrollsToTop = YES;
    }
    return _collectionView;
}
//上拉刷新
-(void)actionMJHeaderRefresh{
    
}
//下拉加载
-(void)actionMJFooterLoadMore{
    
}
// 结束header 和 footer 的刷新
- (void)mjEndRefreshing:(UIScrollView *)scrollView
{
    if ([scrollView.mj_header isRefreshing]) {
        [scrollView.mj_header endRefreshing];
    }
    if ([scrollView.mj_footer isRefreshing]) {
        [scrollView.mj_footer endRefreshing];
    }
}

/**
 配置滚动视图头部刷新 控件
 
 @param scrollView  滚动视图
 @param autoRefresh 是否进入页面就开始刷新
 */
- (void)configScrollViewHeaderRefresh:(UIScrollView *)scrollView autoRefresh:(BOOL)autoRefresh
{
    scrollView.mj_header = self.bsMJRefreshHeader;
    
    if (autoRefresh) {
        
        [scrollView.mj_header beginRefreshing];
    }
}

/**
 配置滚动视图底部加载 控件
 
 @param scrollView 滚动视图
 */
- (void)configScrollViewFooterLoadMore:(UIScrollView *)scrollView
{
    scrollView.mj_footer = self.bsMJRefreshFooter;
    
}

- (MJRefreshNormalHeader *)bsMJRefreshHeader
{
    if (!_bsMJRefreshHeader) {
        _bsMJRefreshHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(actionMJHeaderRefresh)];
        _bsMJRefreshHeader.automaticallyChangeAlpha = YES;
        // 隐藏时间
        _bsMJRefreshHeader.lastUpdatedTimeLabel.hidden = YES;
    }
    return _bsMJRefreshHeader;
}

- (MJRefreshAutoNormalFooter *)bsMJRefreshFooter
{
    if (!_bsMJRefreshFooter) {
        _bsMJRefreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(actionMJFooterLoadMore)];
        
        _bsMJRefreshFooter.automaticallyHidden = YES;
    }
    return _bsMJRefreshFooter;
}
#pragma MARK *******************导航栏******************
/**
 *  是否显示返回按钮
 */
- (void) setIsShowLiftBack:(BOOL)isShowLiftBack
{
    _isShowLiftBack = isShowLiftBack;
    NSInteger VCCount = self.navigationController.viewControllers.count;
    //下面判断的意义是 当VC所在的导航控制器中的VC个数大于1 或者 是present出来的VC时，才展示返回按钮，其他情况不展示
    if (isShowLiftBack && ( VCCount > 1 || self.navigationController.presentingViewController != nil)) {
        [self addNavigationItemWithImageNames:@[@"返回按钮"] isLeft:YES target:self action:@selector(backBtnClicked) tags:nil];
        
    } else {
        self.navigationItem.hidesBackButton = YES;
        UIBarButtonItem * NULLBar=[[UIBarButtonItem alloc]initWithCustomView:[UIView new]];
        self.navigationItem.leftBarButtonItem = NULLBar;
    }
}
- (void)backBtnClicked
{
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/**
 导航栏添加图标按钮
 @param imageNames 图标数组
 @param isLeft 是否是左边 非左即右
 @param target 目标
 @param action 点击方法
 @param tags tags数组 回调区分用
 */
- (void)addNavigationItemWithImageNames:(NSArray *)imageNames isLeft:(BOOL)isLeft target:(id)target action:(SEL)action tags:(NSArray *)tags
{
    NSMutableArray * items = [[NSMutableArray alloc] init];

    NSInteger i = 0;
    for (NSString * imageName in imageNames) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        btn.frame = CGRectMake(0, 0, 30, 30);
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        
        if (isLeft) {
            [btn setContentEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
        }else{
            [btn setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
        }
        
        btn.tag = [tags[i++] integerValue];
        UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:btn];
        [items addObject:item];
        
    }
    if (isLeft) {
        self.navigationItem.leftBarButtonItems = items;
    } else {
        self.navigationItem.rightBarButtonItems = items;
    }
}

//导航栏 添加文字按钮
- (NSMutableArray<UIButton *> *)addNavigationItemWithTitles:(NSArray *)titles isLeft:(BOOL)isLeft target:(id)target action:(SEL)action tags:(NSArray *)tags
{
    NSMutableArray * items = [[NSMutableArray alloc] init];
    NSMutableArray * buttonArray = [NSMutableArray array];
    NSInteger i = 0;
    for (NSString * title in titles) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 30, 30);
        [btn setTitle:title forState:UIControlStateNormal];
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = SYSTEMFONT(16);
        [btn setTitleColor:KGrayColor forState:UIControlStateNormal];
        btn.tag = [tags[i++] integerValue];
        [btn sizeToFit];
        
        //设置偏移
        if (isLeft) {
            [btn setContentEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
        }else{
            [btn setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
        }
        
        UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:btn];
        [items addObject:item];
        [buttonArray addObject:btn];
    }
    if (isLeft) {
        self.navigationItem.leftBarButtonItems = items;
    } else {
        self.navigationItem.rightBarButtonItems = items;
    }
    return buttonArray;
}

#pragma mark ************网络请求页面显示******************

/**
 网络请求成功配置
 
 @param vc 当前vc
 @param scrollView 当前tableView
 */
-(void)NetRequestSuccess:(BaseViewController *)vc scrollView:(UIScrollView *)scrollView
{
    [vc mjEndRefreshing:scrollView];
    
    [MBProgressHUD hideHUD];
}

/**
 网络请求失败配置
 
 @param vc 当前VC
 @param scrollView 当前tableView
 */
-(void)NetRequestFail:(BaseViewController *)vc scrollView:(UIScrollView *)scrollView msg:(NSString *)msg
{
    [vc mjEndRefreshing:scrollView];
    
    [MBProgressHUD hideHUD];
    
    if (msg) {
        
        [MBProgressHUD showErrorMessage:msg];
    }
    
    if ([scrollView isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)scrollView;
        [tableView reloadData];
    }
    if ([scrollView isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)scrollView;
        [collectionView reloadData];
    }
}

#pragma mark  ***************没有数据时的提示***************

/** 配置显示EmptyDataSet的控件 */
- (void)configureNeedShowEmptyDataSetScrollView:(UIScrollView *)scrollView
{
    self.TBScrollViewEmptyDataSet=scrollView;
    
    self.Type=TBNormal;
    
    self.TBScrollViewEmptyDataSet.emptyDataSetSource=self;
    
    self.TBScrollViewEmptyDataSet.emptyDataSetDelegate=self;
    
}

#pragma mark-DZNEmptyDataSetSource
//空白页内容
-(void)setType:(TBBlanckType)Type
{
    _Type=Type;
    
    [self.TBScrollViewEmptyDataSet reloadEmptyDataSet];
}
- (void)emptyDataSetWillAppear:(UIScrollView *)scrollView {
    scrollView.contentOffset = CGPointZero;
}

//空白页图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    if (self.Type==TBReqLoading) {
        
        return [UIImage imageNamed:@"loading_imgBlue_78x78"];
        
    }else if (self.Type==TBNODateType){
        
        return [UIImage imageNamed:@"emptynoData"];
        
    }else if (self.Type==TBSearchNoType){
        
        return [UIImage imageNamed:@"placeholder_appstore"];
        
    }else if (self.Type==TBNormal){
        
        return nil;
        
    } else {
        
        return [UIImage imageNamed:@"placeholder_remote"];
    }
    
}

//空白页动画效果
- (CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *)scrollView {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath: @"transform"];
    
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0)];
    
    animation.duration = 0.25;
    animation.cumulative = YES;
    animation.repeatCount = MAXFLOAT;
    
    return animation;
}
//标题文本，详细描述，富文本样式
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSString *text = @"";
    
    if (self.Type==TBNODateType) {
        
        text=@"没有任何数据";
        
    }else if (self.Type==TBSearchNoType){
        
        text=@"没有搜到你要的内容，换个词语试试吧";
        
    }else if(self.Type==TBReqFalie) {
        
        text=@"网络开小差了!";
    }
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:28.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

//按钮文本
- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    
    if (self.Type==TBReqFalie||self.Type==TBReqLoading) {
        
        NSString *showtip=nil;
        
        if (self.Type==TBReqLoading) {
            
            showtip=@"正在重试";
            
        }else{
            
            showtip=@"点击重试";
            
        }
        
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:26.0f],NSForegroundColorAttributeName:@""};
        
        return [[NSAttributedString alloc] initWithString:showtip attributes:attributes];
        
    }else{
        
        return nil;
        
    }
    
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView
{
    return 40;
}

//空白页背景色
- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIColor whiteColor];
}

#pragma mark-DZNEmptyDataSetDelegate

//是否显示空白页，默认YES
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return YES;
}

//是否允许点击，默认YES
- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
    return YES;
}

//是否允许滚动，默认NO
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

//图片是否要动画效果，默认NO
- (BOOL)emptyDataSetShouldAnimateImageView:(UIScrollView *)scrollView {
    
    if (self.Type==TBReqLoading) {
        
        return YES;
    }
    
    return NO;
}

//空白页点击事件
- (void)emptyDataSetDidTapView:(UIScrollView *)scrollView {
    
    if (self.Type==TBReqFalie) {
        
        self.Type=TBReqLoading;
        
        [self actionTapEmptyDataSetNodataView];
    }
    
}

//空白页按钮点击事件
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button{
    
    if (self.Type==TBReqFalie) {
        
        self.Type=TBReqLoading;
        
        [self actionTapEmptyDataSetNodataView];
    }
}

/** 点击EmptyDataSet NoDataView(封装层, 需要子类重写) */
- (void)actionTapEmptyDataSetNodataView
{

}

#pragma mark ******************状态栏********************
- (UIStatusBarStyle)preferredStatusBarStyle{
    return _StatusBarStyle;
}

//动态更新状态栏颜色
-(void)setStatusBarStyle:(UIStatusBarStyle)StatusBarStyle{
    _StatusBarStyle=StatusBarStyle;
    [self setNeedsStatusBarAppearanceUpdate];
}

#pragma mark ******************键盘********************
/**
 动态修改键盘toolbar
 */
-(void)setIsHidenKeyToolBar:(BOOL)isHidenKeyToolBar
{
    _isHidenKeyToolBar=isHidenKeyToolBar;
    [IQKeyboardManager sharedManager].enableAutoToolbar = !isHidenKeyToolBar;
}
#pragma mark *******************提示弹框******************
//添加优惠券的输入框
- (void)creatAltViewTitle:(NSString*)title Message:(NSString*)message Sure:(NSString*)suretitle Cancle:(NSString*)cancletitle SureBlock:(void(^)(id data))sureBlock CaccleBlock:(void(^)(id data))cancleBlock;
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    //以下方法就可以实现在提示框中输入文本；
    
//    //在AlertView中添加一个输入框
//    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//
//        textField.placeholder = @"请输入优惠券密码";
//    }];
    
    
    UIAlertAction *sure = [UIAlertAction actionWithTitle:suretitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        UITextField *envirnmentNameTextField = alertController.textFields.firstObject;
        
        if(sureBlock)
        {
            sureBlock(nil);
        }
    }];
    
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:cancletitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
        if(cancleBlock)
        {
            cancleBlock(nil);
        }
    }];
    
    [sure setValue:basegreenColor forKey:@"_titleTextColor"];
    [cancle setValue:KGrayColor forKey:@"_titleTextColor"];
    [alertController addAction:sure];
    [alertController addAction:cancle];
    
    //present出AlertView
    [self presentViewController:alertController animated:true completion:nil];
}
#pragma mark ******************屏幕旋转********************
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    //当前支持的旋转类型
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    // 是否支持旋转
    return NO;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    // 默认进去类型
    return   UIInterfaceOrientationPortrait;
}

//取消请求
- (void)cancelRequest
{
    
}

- (void)dealloc
{
    [self cancelRequest];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
