//
//  OrderShopDetailTableViewCell.h
//  FangXinCai
//
//  Created by ios-1 on 2018/1/15.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderShopDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *firstlab;
@property (weak, nonatomic) IBOutlet UILabel *secondlab;
@property (weak, nonatomic) IBOutlet UILabel *threelab;
@property (weak, nonatomic) IBOutlet UILabel *fourthlab;
@property (weak, nonatomic) IBOutlet UILabel *firstcontentlab;
@property (weak, nonatomic) IBOutlet UILabel *secondcontentlab;
@property (weak, nonatomic) IBOutlet UILabel *threecontentlab;
@property (weak, nonatomic) IBOutlet UILabel *fourthcontentlab;

- (void)refreshOrderData:(NSMutableDictionary*)orderContent;
- (void)refreshPayData:(NSMutableDictionary*)payContent;
@end
