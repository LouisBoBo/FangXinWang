//
//  PayStyleModel.h
//  FangXinCai
//
//  Created by ios-1 on 2018/3/1.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PayStyleData;
@interface PayStyleModel : NSObject
@property (nonatomic , strong) NSString* order_id;
@property (nonatomic , strong) NSString* order_price;
@property (nonatomic , strong) NSArray <PayStyleData *> *payment_list;
@end

@interface PayStyleData : NSObject
@property (nonatomic , strong) NSString* code;
@property (nonatomic , strong) NSString* icon;
@property (nonatomic , strong) NSString* name;
@property (nonatomic , strong) NSString* scene;
@property (nonatomic , strong) NSString* type;
@property (nonatomic , assign) BOOL is_select;
@end
