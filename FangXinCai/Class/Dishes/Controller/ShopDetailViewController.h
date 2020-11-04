//
//  ShopDetailViewController.h
//  FangXinCai
//
//  Created by ios-1 on 2018/2/3.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "BaseViewController.h"
#import "FJWaterfallFlowLayout.h"
#import "BigImageHeadView.h"
#import "SpecTagHeadView.h"
#import "HXTagsView.h"
@interface ShopDetailViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , assign) NSInteger selectHeadIndex;
@property (nonatomic , strong) BigImageHeadView *tabHeadView;
@property (nonatomic , strong) SpecTagHeadView  *speckHeadView;
@property (nonatomic , strong) HXTagsView *tagsView;
@property (nonatomic , strong) UILabel *titlelable;
@property (nonatomic , strong) UIView *headNavView;

@property (nonatomic , strong) NSMutableArray   *dataArray;
@property (nonatomic , strong) NSMutableArray   *allDataArr;
@property (nonatomic , strong) NSMutableArray   *headArray;
@property (nonatomic , strong) NSMutableArray   *serviceArr;          //服务保障
@property (nonatomic , strong) NSMutableArray   *bigImageArr;         //商品细节
@property (nonatomic , strong) NSArray *sectionTitleArray;            //分类
@property (nonatomic , strong) NSString * goods_id;
@property (nonatomic , strong) NSString * spec_key;
@end
