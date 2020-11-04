//
//  BigImageTableViewCell.m
//  FangXinCai
//
//  Created by ios-1 on 2018/2/3.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "BigImageTableViewCell.h"

@implementation BigImageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)refreshData:(GoodsImageModel*)imagedata;
{
    if(imagedata != nil)
    {
        [self.BigImage sd_setImageWithURL:[NSURL URLWithString:imagedata.imageStr] placeholderImage:DefaultImg(self.BigImage.frame.size)];
        self.BigImage.contentMode = UIViewContentModeScaleAspectFit;
        
        [self.BigImage mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(self.contentView.mas_left);
            make.top.equalTo(self.contentView.mas_top);
            make.width.mas_equalTo(KScreenWidth);
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.height.mas_equalTo(self.BigImage.width).multipliedBy(0.5);// 高/宽 == 0.5
        }];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
