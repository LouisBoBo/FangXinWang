//
//  PickShopModel.h
//  FangXinCai
//
//  Created by ios-1 on 2018/1/23.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PickshopData;
@interface PickShopModel : NSObject
@property (nonatomic, copy)   NSString *msg;
@property (nonatomic, strong) NSArray<PickshopData *> *data;
@property (nonatomic, assign) NSInteger code;
@end

/**
 "shops_name":"待轮舒",//商户名称
 "shops_address":"待轮舒",//详细地址
 "shops_contacts":"待轮舒",//负责人
 "shops_phone":"15817323366",//负责人电话
 "shops_id":1,//商户id
 "admin_user_id":1,//商户管理员id:大于0的只能被申请加入，等于0的可以被认领
 "apply_id" 申请id
 */
@interface PickshopData :NSObject
@property (nonatomic , strong) NSString * shops_name;
@property (nonatomic , strong) NSString * shops_address;
@property (nonatomic , strong) NSString * shops_contacts;
@property (nonatomic , strong) NSString * shops_phone;
@property (nonatomic , strong) NSString * shops_id;
@property (nonatomic , strong) NSString * admin_user_id;
@property (nonatomic , strong) NSString * apply_id;
@property (nonatomic , assign) BOOL isSelected;
@end
