//
//  CartShopTableViewCell.h
//  FangXinCai
//
//  Created by ios-1 on 2018/1/25.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartViewModel.h"
#import "CartCountModel.h"
@interface CartShopTableViewCell : UITableViewCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIImageView *shopImg;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UILabel *shopPrice;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIButton *reduceBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;

@property (nonatomic , strong) ShopCartData *model;
@property (nonatomic , strong) void(^selectBlock) (ShopCartData*model,CartCountModel*countmodel);
@property (nonatomic , strong) void(^deleteBlock) (ShopCartData*model);
@property (nonatomic , strong) void(^reduceAndAddBlock)(ShopCartData*model,CartCountModel*countmodel);
- (void)refreshData:(ShopCartData*)model;
@end
