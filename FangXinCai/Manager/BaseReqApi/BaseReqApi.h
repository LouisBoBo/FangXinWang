//
//  BaseReqApi.h
//  SafeEatDemo
//
//  Created by bob on 2017/9/4.
//  Copyright © 2017年 bob. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

typedef NS_ENUM(NSInteger, TBResponseStatus) {
    /** 网络请求 成功 */
    TBResponseStatus_Success = 1,
    /** 网络请求 失败 */
    TBResponseStatus_Failure = 0,
      /** 网络出现问题 */
    TBResponseStatus_NetError =2,
    
    TBResponseStatus_abnormality=404
    
};


typedef void(^TBRequestBlock)(TBResponseStatus responseStatus, NSString *message, id responseObject);

@interface BaseReqApi : YTKRequest

/**
 基本网络请求

 @param Requrl 请求url
 @param Outtime 超时时间
 @param dict 参数
 @param ReqMethod 请求方法
 @param ignoreCache 是否缓存
 @param CacheTime 缓存时间
 @return 返回值
 */
- (id)initWithRequestUrl:(NSString*)Requrl andrequestTime:(NSTimeInterval)Outtime andParams:(NSDictionary*)dict andRequestMethod:(YTKRequestMethod)ReqMethod andCache:(BOOL)ignoreCache andCacheTime:(NSInteger)CacheTime andPostToken:(BOOL)token;


/**
 网络请求封装,需要创建实体类再掉用

 @param requestBlock 传递结果
 */
-(void)StarRequest:(TBRequestBlock)requestBlock;

@end
