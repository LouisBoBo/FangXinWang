//
//  SpecTagHeadView.h
//  FangXinCai
//
//  Created by ios-1 on 2018/2/6.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FJWaterfallFlowLayout.h"
#import "GoodsShopDetailModel.h"
@interface SpecTagHeadView : UIView<UICollectionViewDelegate,UICollectionViewDataSource,FJWaterfallFlowLayoutDelegate>

@property (nonatomic , strong) FJWaterfallFlowLayout *WaterfallFlowLayout;
@property (nonatomic , strong) UICollectionView *collectionView;
@property (nonatomic , strong) NSMutableArray *dataArray;
@property (strong , nonatomic) void (^selectBlock)(GoodsspecData *model);
- (instancetype)initWithFrame:(CGRect)frame;
- (void)reloadData:(NSArray*)dataArray;
@end
