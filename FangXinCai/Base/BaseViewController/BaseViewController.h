//
//  BaseViewController.h
//  FangXinCai
//
//  Created by ios-1 on 2018/1/8.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootNavigationController.h"
typedef NS_ENUM(NSUInteger,TBBlanckType){
    
    //没数据列表
    TBNODateType=0,
    
    //搜索无数据
    TBSearchNoType=1,
    
    //网络出错页面,可点击
    TBReqFalie=2,
    
    //加载中...
    TBReqLoading=3,
    
    //正常的...
    TBNormal=4
    
};
@interface BaseViewController : UIViewController<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

/**
 *  修改状态栏颜色
 */
@property (nonatomic, assign) UIStatusBarStyle StatusBarStyle;

@property (nonatomic, assign) UITableViewStyle tableviewstyle;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) UIImageView* noDataView;

/**
 图片流浪数组
 */
@property(nonatomic,strong)NSMutableArray * _Nullable ScanPhotoArr;

/**
 *  显示没有数据页面
 */
#pragma mark - 没有数据时的提示
//UI控件
@property (nonatomic, strong) UIScrollView *TBScrollViewEmptyDataSet;
@property(nonatomic,assign)TBBlanckType Type;//空白页类型

/** 配置显示EmptyDataSet的控件 */
- (void)configureNeedShowEmptyDataSetScrollView:(UIScrollView *_Nullable)scrollView;

/** 点击EmptyDataSet NoDataView(封装层, 需要子类重写) */
- (void)actionTapEmptyDataSetNodataView;

-(void)showNoDataImage;

/**
 *  移除无数据页面
 */
-(void)removeNoDataImage;

/**
 *  加载视图
 */
- (void)showLoadingAnimation;

/**
 *  停止加载
 */
- (void)stopLoadingAnimation;

/**
 是否隐藏键盘的toolBar
 */
@property(nonatomic,assign)BOOL isHidenKeyToolBar;

/**
 *  是否显示返回按钮,默认情况是YES
 */
@property (nonatomic, assign) BOOL isShowLiftBack;

/**
 是否隐藏导航栏
 */
@property (nonatomic, assign) BOOL isHidenNaviBar;

/**
 导航栏添加文本按钮
 
 @param titles 文本数组
 @param isLeft 是否是左边 非左即右
 @param target 目标
 @param action 点击方法
 @param tags tags数组 回调区分用
 */
- (void)addNavigationItemWithTitles:(NSArray *)titles isLeft:(BOOL)isLeft target:(id)target action:(SEL)action tags:(NSArray *)tags;

/**
 导航栏添加图标按钮
 
 @param imageNames 图标数组
 @param isLeft 是否是左边 非左即右
 @param target 目标
 @param action 点击方法
 @param tags tags数组 回调区分用
 */
- (void)addNavigationItemWithImageNames:(NSArray *)imageNames isLeft:(BOOL)isLeft target:(id)target action:(SEL)action tags:(NSArray *)tags;

/**
 *  默认返回按钮的点击事件，默认是返回，子类可重写
 */
- (void)backBtnClicked;

//取消网络请求
- (void)cancelRequest;

#pragma mark - MJ刷新和加载
/**
 配置滚动视图头部刷新 控件
 
 @param scrollView  滚动视图
 @param autoRefresh 是否进入页面就开始刷新
 */
- (void)configScrollViewHeaderRefresh:(UIScrollView *_Nullable)scrollView autoRefresh:(BOOL)autoRefresh;

/**
 配置滚动视图底部加载 控件
 
 @param scrollView 滚动视图
 */
- (void)configScrollViewFooterLoadMore:(UIScrollView *_Nullable)scrollView;
/**
 *  MJ头部刷新(封装层方法, 需要子类继承或者重写)
 */
- (void)actionMJHeaderRefresh;

/**
 *  MJ底部加载(封装方法, 需要子类继承或者重写)
 */
- (void)actionMJFooterLoadMore;

/**
 *  MJ 结束header 和 footer 的刷新
 *
 *  @param scrollView 要停止刷新的 scrollView
 */
- (void)mjEndRefreshing:(UIScrollView *_Nullable)scrollView;

#pragma mark-网络请求页面显示

/**
 网络请求成功配置
 
 @param vc 当前vc
 @param scrollView 当前tableView
 */
-(void)NetRequestSuccess:(BaseViewController *_Nullable)vc scrollView:(UIScrollView *_Nullable)scrollView;

/**
 网络请求失败配置
 
 @param vc 当前VC
 @param scrollView 当前tableView
 */
-(void)NetRequestFail:(BaseViewController *_Nullable)vc scrollView:(UIScrollView *_Nullable)scrollView msg:(NSString *_Nullable)msg;
/**
 提示弹框
 */
- (void)creatAltViewTitle:(NSString*)title Message:(NSString*)message Sure:(NSString*)suretitle Cancle:(NSString*)cancletitle SureBlock:(void(^)(id data))sureBlock CaccleBlock:(void(^)(id data))cancleBlock;
@end
