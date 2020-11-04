//
//  ConfirmOrderFootViewController.h
//  FangXinCai
//
//  Created by ios-1 on 2018/2/27.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmOrderFootViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *goodPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *promoPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *shippingFeeLab;
@property (weak, nonatomic) IBOutlet UIView *joinSingleView;

@property (nonatomic , strong) dispatch_block_t joinSingleBlock;
- (void)refreshUI:(NSDictionary*)data;
@end
