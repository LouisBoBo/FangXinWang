//
//  MyOrderTableViewCell.m
//  FangXinCai
//
//  Created by ios-1 on 2018/1/12.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "MyOrderTableViewCell.h"

@implementation MyOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.firstBtn.layer.cornerRadius = CGRectGetHeight(self.firstBtn.frame)/2;
    self.firstBtn.layer.borderWidth = 1;
    self.firstBtn.layer.borderColor = basegreenColor.CGColor;
    
    self.secondBtn.layer.cornerRadius = CGRectGetHeight(self.secondBtn.frame)/2;
    self.secondBtn.layer.borderWidth = 1;
    self.secondBtn.layer.borderColor = basegreenColor.CGColor;
    
    self.shopScrollview.userInteractionEnabled = YES;
    self.shopScrollview.showsHorizontalScrollIndicator = FALSE;
    [self.shopScrollview removeAllSubviews];
    [self creatShopView];
    
}
- (void)creatShopView
{
    int count = 10;
    for(int i =0; i<count; i++)
    {
        UIView *shopview = [UIView new];
        shopview.backgroundColor = DRandomColor;
        shopview.tag = 10000+i;
        [self.shopScrollview addSubview:shopview];
        
        UITapGestureRecognizer *shoptap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shopClick:)];
        [shopview addGestureRecognizer:shoptap];
        
        [shopview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset((50+5)*i);
            make.top.mas_offset(10);
            make.width.height.mas_offset(50);
        }];
    }
    self.shopScrollview.contentSize = CGSizeMake(50*count+5*(count-1), 0);
}

- (void)shopClick:(UITapGestureRecognizer*)tap
{
    NSInteger tag = tap.view.tag - 10000;
    NSLog(@"商品%zd",tag);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
