//
//  WaletTableHeadView.h
//  FangXinCai
//
//  Created by ios-1 on 2018/1/10.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaletTableHeadView : UIView
@property (nonatomic , strong) UIView * tabheadView;
@property (nonatomic , strong) UIImageView * moneyHeadview;//金额相关
@property (nonatomic , strong) UIView *      operationview;//操作相关

@property (nonatomic , strong) dispatch_block_t moneyBlock;
@property (nonatomic , strong) dispatch_block_t operaBlock;
- (instancetype)initWithFrame:(CGRect)frame;

@end
