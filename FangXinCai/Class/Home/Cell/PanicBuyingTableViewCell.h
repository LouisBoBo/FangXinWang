//
//  PanicBuyingTableViewCell.h
//  FangXinCai
//
//  Created by ios-1 on 2018/1/22.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PanicBuyingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UILabel *shopStyle;
@property (weak, nonatomic) IBOutlet UILabel *shopMoney;
@property (weak, nonatomic) IBOutlet UIButton *panicBuying;

@end
