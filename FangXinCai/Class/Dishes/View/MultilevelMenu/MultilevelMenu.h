//
//  MultilevelMenu.h
//  MultilevelMenu
//
//  Created by gitBurning on 15/3/13.
//  Copyright (c) 2015年 BR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsCategoryModel.h"
#import "GoodsShopModel.h"
#import "MultilHeadView.h"
#define kLeftWidth 100

@interface MultilevelMenu : UIView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, assign) CGFloat endPoint_x;
@property (nonatomic, assign) CGFloat endPoint_y;
@property (nonatomic, strong) CALayer *dotLayer;
@property (nonatomic, strong) UIBezierPath *path;

@property(strong,nonatomic,readonly) NSArray * allData;
@property (nonatomic , strong) NSMutableArray *rightData;
@property (nonatomic , strong) NSMutableArray *rightAllData;
@property(copy,nonatomic,readonly) id block;
@property (nonatomic , strong) MultilHeadView *HeadView;
/**
 *  是否 记录滑动位置
 */
@property(assign,nonatomic) BOOL isRecordLastScroll;
/**
 *   记录滑动位置 是否需要 动画
 */
@property(assign,nonatomic) BOOL isRecordLastScrollAnimated;

@property(assign,nonatomic,readonly) NSInteger selectIndex;

/**
 *  为了 不修改原来的，因此增加了一个属性，选中指定 行数
 */
@property(assign,nonatomic) NSInteger needToScorllerIndex;  //临时左右tableView共享
/**
 *  颜色属性配置
 */

/**
 *  左边背景颜色
 */
@property(strong,nonatomic) UIColor * leftBgColor;
/**
 *  左边点中文字颜色
 */
@property(strong,nonatomic) UIColor * leftSelectColor;
/**
 *  左边点中背景颜色
 */
@property(strong,nonatomic) UIColor * leftSelectBgColor;

/**
 *  左边未点中文字颜色
 */

@property(strong,nonatomic) UIColor * leftUnSelectColor;
/**
 *  左边未点中背景颜色
 */
@property(strong,nonatomic) UIColor * leftUnSelectBgColor;
/**
 *  tablew 的分割线
 */
@property(strong,nonatomic) UIColor * leftSeparatorColor;

/**
 *  左边tablew block回调
 */
@property (nonatomic , strong) void(^leftTableBlock)(GoodsCategoryData*data);
/**
 *  右边tablew block回调
 */
@property (nonatomic , strong) void(^rightTableBlock)(GoodsShopData*data);
/**
 *  加减购物车数量
 */
@property (nonatomic , strong) dispatch_block_t addAndReduceBlock;

- (void)reloadAllData:(GoodsCategoryData*)allData;
-(instancetype)initWithFrame:(CGRect)frame WithData:(GoodsCategoryData*)data withSelectIndex:(void(^)(NSInteger left,NSInteger right,id info))selectIndex;

@end


@interface rightMeun : NSObject

/**
 *  菜单图片名
 */
@property(copy,nonatomic) NSString * urlName;
/**
 *  菜单名
 */
@property(copy,nonatomic) NSString * meunName;
/**
 *  菜单ID
 */
@property(copy,nonatomic) NSString * ID;

/**
 *  下一级菜单
 */
@property(strong,nonatomic) NSArray * nextArray;

/**
 *  菜单层数
 */
@property(assign,nonatomic) NSInteger meunNumber;

@property(assign,nonatomic) float offsetScorller;

@end
