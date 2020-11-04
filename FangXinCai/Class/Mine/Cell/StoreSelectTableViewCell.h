//
//  StoreSelectTableViewCell.h
//  FangXinCai
//
//  Created by ios-1 on 2018/1/20.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickShopModel.h"
@interface StoreSelectTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *person;
@property (weak, nonatomic) IBOutlet UIButton *ClaimBtn;
@property (weak, nonatomic) IBOutlet UIImageView *statusImg;
@property (nonatomic , strong) PickshopData *model;
@property (nonatomic , strong) void(^claimStoreBlock)(PickshopData*model);
- (void)refreshData:(PickshopData*)model;

@end
