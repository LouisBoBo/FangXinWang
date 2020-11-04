//
//  SearchResultViewController.h
//  FangXinCai
//
//  Created by ios-1 on 2018/1/13.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "BaseViewController.h"
#import "MultilHeadView.h"
@interface SearchResultViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) NSMutableArray *tabDataArr;
@property (nonatomic , strong) NSString *searchText;
@property (nonatomic , assign) NSInteger currentPage;
@property (nonatomic , assign) NSInteger sort;
@property (nonatomic , strong) MultilHeadView *HeadView;
@end
