//
//  ConfirmOrderFootViewController.m
//  FangXinCai
//
//  Created by ios-1 on 2018/2/27.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "ConfirmOrderFootViewController.h"

@interface ConfirmOrderFootViewController ()

@end

@implementation ConfirmOrderFootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)refreshUI:(NSDictionary*)data;
{
    self.goodPriceLab.text = [NSString stringWithFormat:@"￥%.2f",[data[@"goods_total_price"] floatValue]];
    self.promoPriceLab.text = [NSString stringWithFormat:@"￥%.2f",[data[@"promotion_price"] floatValue]];
    self.shippingFeeLab.text = [NSString stringWithFormat:@"￥%.2f",[data[@"shipping_fee"] floatValue]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(joinSingle:)];
    self.joinSingleView.userInteractionEnabled = YES;
    [self.joinSingleView addGestureRecognizer:tap];
}
- (void)joinSingle:(UITapGestureRecognizer*)tap
{
    if(self.joinSingleBlock)
    {
        self.joinSingleBlock();
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
