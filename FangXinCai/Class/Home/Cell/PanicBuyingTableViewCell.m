//
//  PanicBuyingTableViewCell.m
//  FangXinCai
//
//  Created by ios-1 on 2018/1/22.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "PanicBuyingTableViewCell.h"

@implementation PanicBuyingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.headImage sd_setImageWithURL:@"" placeholderImage:DefaultImg(self.headImage.frame.size)];
    
    self.panicBuying.backgroundColor = basegreenColor;
    self.panicBuying.layer.cornerRadius = CGRectGetHeight(self.panicBuying.frame)/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
