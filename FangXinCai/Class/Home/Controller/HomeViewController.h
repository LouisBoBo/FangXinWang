//
//  HomeViewController.h
//  FangXinCai
//
//  Created by ios-1 on 2018/1/8.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "BaseViewController.h"
#import "HometabHeadView.h"
@interface HomeViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) NSMutableArray *tabDataArr;
@property (nonatomic , strong) NSMutableArray *allDataArr; //清单商品
@property (nonatomic , strong) NSMutableArray *headeArray;
@property (nonatomic , strong) HometabHeadView *hometabHeadView;          //tableHead
@property (nonatomic , assign) NSInteger selectHeadIndex;

@property (nonatomic, assign) CGFloat endPoint_x;
@property (nonatomic, assign) CGFloat endPoint_y;
@property (nonatomic, strong) CALayer *dotLayer;
@property (nonatomic, strong) UIBezierPath *path;
@end
