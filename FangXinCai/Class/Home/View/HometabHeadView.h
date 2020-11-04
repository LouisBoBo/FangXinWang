//
//  HometabHeadView.h
//  FangXinCai
//
//  Created by ios-1 on 2018/1/18.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"
@interface HometabHeadView : UIView<SDCycleScrollViewDelegate>
@property (nonatomic , strong) UIView *hometabHeadView;
@property (nonatomic , strong) SDCycleScrollView *SDCycleScrollView;      //轮播图片
@property (nonatomic , strong) UIView *myClassView;                       //分类
@property (nonatomic , strong) UIView *myAreaView;                        //特价专区
@property (nonatomic , strong) UIView *nineAreaView;                      //9.9专区
@property (nonatomic , strong) dispatch_block_t moreNinePointBlock;
@property (nonatomic , strong) void(^myclassIndexBlock)(NSInteger selectIndex);
@property (nonatomic , strong) void(^specialAreaBlock)(NSInteger selectIndex);
@property (nonatomic , strong) void(^ninePointBlock)(NSInteger selectIndex);
- (instancetype)initWithFrame:(CGRect)frame;

//刷新轮播图片
- (void)refreshBanaImages:(NSArray*)imagesURLStrings;
@end
