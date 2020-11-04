//
//  MineTableHeadView.h
//  FangXinCai
//
//  Created by ios-1 on 2018/1/9.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineTableHeadView : UIView
@property (nonatomic , strong) UIView * tabheadView;
@property (nonatomic , strong) UIImageView * userHeadview;//用户相关
@property (nonatomic , strong) UIImageView * headimage;   //用户头像
@property (nonatomic , strong) UILabel * accountslab;     //用户帐号
@property (nonatomic , strong) UILabel * nicknamelab;     //用户昵称

@property (nonatomic , strong) UIView * userOrderview;    //订单相关
@property (nonatomic , strong) UIView * userWaletview;    //钱包相关

@property (nonatomic , strong) void(^orderWaletBlock)(NSInteger tag);
@property (nonatomic , strong) dispatch_block_t settingBlock;
@property (nonatomic , strong) dispatch_block_t waletBlock;
@property (nonatomic , strong) dispatch_block_t orderBlock;
- (instancetype)initWithFrame:(CGRect)frame;
- (void)refreshUI:(NSDictionary*)data;
@end
