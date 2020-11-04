//
//  OrderShopDetailTableViewCell.m
//  FangXinCai
//
//  Created by ios-1 on 2018/1/15.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "OrderShopDetailTableViewCell.h"

@implementation OrderShopDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
- (void)refreshOrderData:(NSMutableDictionary*)orderContent;
{
    self.firstlab.text = @"订单编号";
    self.secondlab.text = @"下单时间";
    self.threelab.text = @"支付方式";
    self.fourthlab.text = @"卖家留言";
    
    self.firstcontentlab.text = [NSString stringWithFormat:@"%@",[orderContent objectForKey:@"orderCode"]];
    self.secondcontentlab.text = [NSString stringWithFormat:@"%@",[orderContent objectForKey:@"orderTime"]];
    self.threecontentlab.text = [NSString stringWithFormat:@"%@",[orderContent objectForKey:@"paystyle"]];
    self.fourthcontentlab.text = [NSString stringWithFormat:@"%@",[orderContent objectForKey:@"message"]];
}
- (void)refreshPayData:(NSMutableDictionary*)payContent;
{
    self.firstlab.text = @"商品金额";
    self.secondlab.text = @"优惠";
    self.threelab.text = @"运费";
    self.fourthlab.text = @"积分";
    
    self.firstcontentlab.text = [NSString stringWithFormat:@"￥%@",[payContent objectForKey:@"orderMoney"]];
    self.firstcontentlab.textColor = [UIColor redColor];
    self.secondcontentlab.text = [NSString stringWithFormat:@"-￥%@",[payContent objectForKey:@"Discount"]];
    self.secondcontentlab.textColor = [UIColor redColor];
    self.threecontentlab.text = [NSString stringWithFormat:@"￥%@",[payContent objectForKey:@"freight"]];
    self.threecontentlab.textColor = [UIColor redColor];
    self.fourthcontentlab.text = [NSString stringWithFormat:@"%@",[payContent objectForKey:@"integral"]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
