//
//  BasePanicViewController.h
//  FangXinCai
//
//  Created by ios-1 on 2018/1/22.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "BaseViewController.h"

@interface BasePanicViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) NSMutableArray *tabDataArr;
@property (nonatomic , strong) NSMutableArray *httpDataArr;
@property (nonatomic , assign) NSInteger index;
- (void)loadDatas;
@end
