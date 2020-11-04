//
//  JoinShopTableViewCell.m
//  FangXinCai
//
//  Created by ios-1 on 2018/1/26.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "JoinShopTableViewCell.h"

@implementation JoinShopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.joinBtn.titleLabel.font = [UIFont systemFontOfSize:KZOOM6pt(28)];
    [self.joinBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.joinBtn setTitle:@"去凑单" forState:UIControlStateNormal];
    [self.joinBtn setImage:[UIImage imageNamed:@"红色右"] forState:UIControlStateNormal];
    [self.joinBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, KZOOM6pt(40))];
    [self.joinBtn setImageEdgeInsets:UIEdgeInsetsMake(KZOOM6pt(15), KZOOM6pt(150), KZOOM6pt(15), 0)];
   
    [self.joinBtn addTarget:self action:@selector(joinShopClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)joinShopClick:(UIButton*)sender
{
    NSLog(@"去凑单");
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
