//
//  BaseOrderViewController.h
//  FangXinCai
//
//  Created by ios-1 on 2018/1/12.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseOrderViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) NSMutableArray *tabDataArr;
@property (nonatomic , strong) NSMutableArray *httpDataArr;
- (void)loadDatas;
@end
