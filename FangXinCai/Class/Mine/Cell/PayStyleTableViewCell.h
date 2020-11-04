//
//  PayStyleTableViewCell.h
//  FangXinCai
//
//  Created by ios-1 on 2018/3/1.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayStyleModel.h"
@interface PayStyleTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (nonatomic , strong) PayStyleData *model;
@property (nonatomic , strong) void(^selectPayStyleBlock)(PayStyleData *data);
- (void)refreshData:(PayStyleData*)data;
@end
