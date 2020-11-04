//
//  HBGlobal.h
//  IOVehicles
//
//  Created by LeePing on 15/7/16.
//  Copyright (c) 2015年 Lip. All rights reserved.
//

//********************用户信息********************
#define KUserDefaul [NSUserDefaults standardUserDefaults]
//当前大致位置
#define SetuserNowadress(value)     [KUserDefaul setObject:value forKey:@"adress"]
//当前详细地址
#define Setuserdetialadress(value)  [KUserDefaul setObject:value forKey:@"detialadress"]

#define User_Token @"token"
//用户手机
#define User_Phone @"phone"
//用户id
#define User_ID    @"shopid"
//用户姓名
#define User_Name  @"name"
//用户当前选择的优惠券
#define SelectCoupon @"selectCoupon"


