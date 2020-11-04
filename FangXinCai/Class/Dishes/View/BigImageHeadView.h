//
//  BigImageHeadView.h
//  FangXinCai
//
//  Created by ios-1 on 2018/2/3.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"
#import "GoodsShopDetailModel.h"
#import "GoodsShopInfoModel.h"
#import "FullScreenScrollView.h"
@interface BigImageHeadView : UIView<SDCycleScrollViewDelegate>
@property (nonatomic , strong) FullScreenScrollView *imgFullScrollView;
@property (nonatomic , strong) SDCycleScrollView *SDCycleScrollView;      //轮播图片
@property (nonatomic , strong) dispatch_block_t  collectBlock;            //加入清单
@property (nonatomic , strong) NSString *goods_id;                        //商品id
@property (nonatomic , strong) UILabel *pagelab;
@property (nonatomic , strong) UILabel *discriptionlab;
@property (nonatomic , strong) UIButton *collectBtn;

@property (nonatomic , strong) NSArray *imagesURLStrings;
- (instancetype)initWithFrame:(CGRect)frame Goodsid:(NSString*)goods_id;
- (void)refreshBanaImages:(NSArray*)imagesURLStrings GoodsInfo:(GoodsShopInfoModel*)goodsinfo;
@end
