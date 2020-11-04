//
//  ServiceTableViewCell.m
//  FangXinCai
//
//  Created by ios-1 on 2018/2/3.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "ServiceTableViewCell.h"

@implementation ServiceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titlelab.textColor = KGrayColor;
    self.titlelab.font = HBFont15;
    self.titlelab.numberOfLines = 0;
    
    self.discriptionlab.textColor = KGray2Color;
    self.discriptionlab.font = HBFont12;
    self.discriptionlab.numberOfLines = 0;
}
- (void)refreshData:(GoodsserviceData*)model;
{
    self.headImage.image = [UIImage imageNamed:model.headImage];
    self.titlelab.text = [NSString stringWithFormat:@"%@",model.title];
    self.discriptionlab.text = [NSString stringWithFormat:@"%@",model.value];
    
    [self.titlelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(40);
        make.top.equalTo(self.contentView.mas_top).offset(0);
        make.width.mas_equalTo(KScreenWidth-50);
        make.height.mas_equalTo(40);
    }];
    
    [self.discriptionlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(40);
        make.top.equalTo(self.titlelab.mas_bottom).offset(0);
        make.width.mas_equalTo(KScreenWidth-50);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
