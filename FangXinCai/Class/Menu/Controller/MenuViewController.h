//
//  MenuViewController.h
//  FangXinCai
//
//  Created by ios-1 on 2018/1/8.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "BaseViewController.h"

@interface MenuViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource, SGPageContentViewDelegate,CAAnimationDelegate>

@property (nonatomic , strong) NSMutableArray*tabDataArr;
@property (nonatomic , strong) NSMutableArray*allDataArr;
@property (nonatomic , strong) NSMutableArray*headeArray;
@property (nonatomic , assign) NSInteger currentPage;
@property (nonatomic , assign) NSInteger selectHeadIndex;
@property (nonatomic , strong) SGPageContentView *pageContentView;

@property (nonatomic, assign) CGFloat endPoint_x;
@property (nonatomic, assign) CGFloat endPoint_y;
@property (nonatomic, strong) CALayer *dotLayer;
@property (nonatomic, strong) UIBezierPath *path;
@end
