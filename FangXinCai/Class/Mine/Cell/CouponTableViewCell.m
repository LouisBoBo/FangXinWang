//
//  CouponTableViewCell.m
//  FangXinCai
//
//  Created by ios-1 on 2018/1/16.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "CouponTableViewCell.h"

@implementation CouponTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.couponMoney.textColor = basegreenColor;
    self.canUse.textColor = KGrayColor;
    self.mustTime.textColor = KGrayColor;
    self.status.textColor = KGrayColor;
    self.linelab.backgroundColor = basegreenColor;
    self.selectImage.hidden = NO;
}
- (void)refreshData:(CouponData*)model;
{
    self.couponMoney.text = [NSString stringWithFormat:@"￥%@",model.money];
    self.canUse.text = [NSString stringWithFormat:@"%@",model.name];
    self.mustTime.text = [NSString stringWithFormat:@"有效期至：%@",[HelpWay timestampChangesStandarTime:model.use_end_time]];
    ;
//    NSString *selectCouponID = [KUserDefaul objectForKey:SelectCoupon];
//    model.is_select = [model.ID isEqualToString:selectCouponID]?YES:NO;
    
    if(model.is_select)
    {
        self.selectImage.hidden = NO;
        self.baseImageView.layer.borderWidth = 2;
        self.baseImageView.layer.borderColor = basegreenColor.CGColor;
    }else{
        self.selectImage.hidden = YES;
        self.baseImageView.layer.borderWidth = 0;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
