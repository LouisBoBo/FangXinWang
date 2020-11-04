//
//  BaseSearchViewController.h
//  FangXinCai
//
//  Created by ios-1 on 2018/1/21.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseSearchViewController : BaseViewController<UISearchBarDelegate>
@property (nonatomic , strong) NSMutableArray *tabDataArr;
@property (nonatomic , strong) NSMutableArray *originalArray;
@property (nonatomic , strong) UISearchBar * searchBar;       //搜索框
@property (nonatomic , strong) UIBarButtonItem * searchButton;
@property (nonatomic , strong) UIView *tableHeadView;         //列表头
@property (nonatomic , strong) UIView *noresultHeadView;      //没结果
@property (nonatomic , assign) BOOL isSelectStore;    //是否是选择门店
@end
