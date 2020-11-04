//
//  TBReqApi.h
//  SafeFoodManagerDemo
//
//  Created by bob on 2017/9/15.
//  Copyright © 2017年 bob. All rights reserved.
//请求的url

#ifndef TBReqApi_h
#define TBReqApi_h
//=================来自服务端定义=============
#define TBJsonCodeStatus           @"code"
#define TBJsonMessage              @"msg"
#define TBJsonDataBody             @"data"
#define TBSuccess              @"上传成功"    // 头像上传成功时使用
#define TBFaile                @"上传失败"    //头像上传失败时使用
#define PageNo_Start     1
#define ReqOutime        30                 //超时时间

//登录通知
#define KNotificationLoginStateChange @"loginStateChange"

//下线通知
#define KNotificationOnKick @"KNotificationOnKick"

//网络状态变化
#define KNotificationNetWorkStateChange @"KNotificationNetWorkStateChange"

//选择图片最大数

#define UploadMAXImage 1
//发送通知
#define KPostNotification(name,obj) [[NSNotificationCenter defaultCenter] postNotificationName:name object:obj];

//=================来自服务端定义=============

//=================url切换=============
#ifdef DEBUG

#define ReqUrl  @"http://www.zgfangxin.com"

#define DebugLog(s, ...) NSLog(@"%s(%d): %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])

#else

#define ReqUrl  @"http://www.zgfangxin.com"

#define DebugLog(...)

#endif

//=================url切换=============

//=================具体url=============



//=================具体url=============


#endif /* TBReqApi_h */
