//
//  DishesShopViewController.h
//  FangXinCai
//
//  Created by ios-1 on 2018/1/29.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "BaseViewController.h"
#import "MultilevelMenu.h"
@interface DishesShopViewController : BaseViewController

@property (nonatomic , strong) NSMutableArray *CategoryDataArray;
@property (nonatomic , strong) MultilevelMenu *MultilevelMenu;
- (void)reloadData:(NSMutableArray*)CategoryDataArray SelectIndex:(NSInteger)SelectIndex;
@end
