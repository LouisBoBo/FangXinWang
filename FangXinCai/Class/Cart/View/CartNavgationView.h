//
//  CartNavgationView.h
//  FangXinCai
//
//  Created by ios-1 on 2018/1/25.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartNavgationView : UIView
- (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic , strong) dispatch_block_t customerBlock;
@property (nonatomic , strong) void(^editBlock)(BOOL edit);
@end
