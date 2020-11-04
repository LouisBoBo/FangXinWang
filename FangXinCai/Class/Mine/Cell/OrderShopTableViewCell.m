//
//  OrderShopTableViewCell.m
//  FangXinCai
//
//  Created by ios-1 on 2018/1/15.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "OrderShopTableViewCell.h"

@implementation OrderShopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
- (void)refreshData;
{
    [self.shopImage sd_setImageWithURL:[NSURL URLWithString:@""]];
    self.shopname.text = [NSString stringWithFormat:@"%@",@""];
    self.shopmodel.text = [NSString stringWithFormat:@"%@",@""];
    self.shopprice.text = [NSString stringWithFormat:@"%@",@""];
    self.shopNum.text = [NSString stringWithFormat:@"%@",@""];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
