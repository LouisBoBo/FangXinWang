//
//  GoodsCategoryModel.h
//  FangXinCai
//
//  Created by ios-1 on 2018/1/29.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GoodsCategoryData;//一级分类
@interface GoodsCategoryModel : NSObject
@property (nonatomic, copy)   NSString *msg;
@property (nonatomic, strong) NSArray<GoodsCategoryData *> *data;
@property (nonatomic, assign) NSInteger code;
@end

//@class CategoryChildData;//二级分类
@interface GoodsCategoryData : NSObject
@property (nonatomic , copy) NSString *ID;
@property (nonatomic , copy) NSString *name;
@property (nonatomic , copy) NSString *parent_id;
@property (nonatomic , copy) NSString *sort_order;
@property (assign,nonatomic) float offsetScorller;
@property (nonatomic , copy) NSArray<GoodsCategoryData *> *child;
@end


