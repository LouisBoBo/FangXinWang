//
//  DishesShopViewController.m
//  FangXinCai
//
//  Created by ios-1 on 2018/1/29.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "DishesShopViewController.h"
#import "DishesClassTableViewCell.h"
#import "ShopDetailViewController.h"
#import "MultilevelMenu.h"
#import "GoodsCategoryModel.h"
@interface DishesShopViewController ()

@end

@implementation DishesShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self creatMainView];
}
- (void)creatMainView
{
    //适配 ios 7 和ios 8 的 坐标系问题
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    GoodsCategoryData *categoryData = [GoodsCategoryData new];
    if(self.CategoryDataArray.count)
    {
        categoryData = self.CategoryDataArray[0];
    }
    
    self.MultilevelMenu =[[MultilevelMenu alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-50-49) WithData:categoryData withSelectIndex:^(NSInteger left, NSInteger right,rightMeun* info) {
        
        NSLog(@"点击的 菜单%@",info.meunName);
    }];
    
    kWeakSelf(self);
    self.MultilevelMenu.leftTableBlock = ^(GoodsCategoryData *data) {
        
    };
    
    self.MultilevelMenu.rightTableBlock = ^(GoodsShopData *data) {
        ShopDetailViewController *shopdetail = [[ShopDetailViewController alloc]init];
        shopdetail.goods_id = data.goods_id;
        shopdetail.spec_key = data.spec_key;
        [weakself.navigationController pushViewController:shopdetail animated:YES];
    };
    
    self.MultilevelMenu.addAndReduceBlock = ^{
        [weakself changeTabbarCartNum];
    };
    
    self.MultilevelMenu.needToScorllerIndex=0;
    self.MultilevelMenu.isRecordLastScroll=YES;
    
    [self.view addSubview:self.MultilevelMenu];
}
- (void)reloadData:(NSMutableArray*)CategoryDataArray SelectIndex:(NSInteger)SelectIndex;
{
    self.MultilevelMenu.needToScorllerIndex=0;
    self.MultilevelMenu.isRecordLastScroll=YES;
    
    GoodsCategoryData *categoryData = self.CategoryDataArray[SelectIndex];
    [self.MultilevelMenu reloadAllData:categoryData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
