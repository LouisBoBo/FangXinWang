//
//  OrderShopFootView.h
//  FangXinCai
//
//  Created by ios-1 on 2018/1/15.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderShopFootView : UIView
@property (nonatomic , strong) UIView *footView;
@property (nonatomic , strong) UIView *orderHandleView;
@property (nonatomic , strong) void(^orderHandleBlock)(NSString *text);
- (instancetype)initWithFrame:(CGRect)frame;

@end
