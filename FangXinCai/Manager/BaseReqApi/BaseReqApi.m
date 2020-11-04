//
//  BaseReqApi.m
//  SafeEatDemo
//
//  Created by bob on 2017/9/4.
//  Copyright © 2017年 bob. All rights reserved.
//

#import "BaseReqApi.h"
//#import "TBSafeKey.h"
#import "TBReqApi.h"
//#import "LoginStatuesModel.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "RootNavigationController.h"
@interface BaseReqApi ()
{
    NSString*_reqUrl;
    NSTimeInterval _outtime;
    NSMutableDictionary *_paradict;
    YTKRequestMethod _method;
    BOOL _isCache;
    NSInteger _CacheTime;
    
}

@end

@implementation BaseReqApi


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
- (id)initWithRequestUrl:(NSString*)Requrl andrequestTime:(NSTimeInterval)Outtime andParams:(NSDictionary*)dict andRequestMethod:(YTKRequestMethod)ReqMethod andCache:(BOOL)ignoreCache andCacheTime:(NSInteger)CacheTime andPostToken:(BOOL)token
{
    if (self=[super init]) {
   
        _paradict=[[NSMutableDictionary alloc]initWithDictionary:dict];
        
        if (token) {
            
//             [_paradict setValue:[LoginStatuesModel getUserToken] forKey:@"token"];
        }
     
        _reqUrl=Requrl;
        _outtime=Outtime;
        _method=ReqMethod;
        _isCache=ignoreCache;
        _CacheTime=CacheTime;
        
    }
    return self;
}

//请求url
-(NSString*)requestUrl
{
    
    return _reqUrl;
    
}

//请求方式
-(YTKRequestMethod)requestMethod
{
    
    return _method;
}
//请求参数
-(id)requestArgument
{
    
    return _paradict;
    
}

//是否忽略缓存
-(BOOL)ignoreCache
{
    
    return _isCache;
    
}

//缓存时间
-(NSInteger)cacheTimeInSeconds
{
    if (_CacheTime==0) {
        
        return 2;
    }
    return _CacheTime;
    
}

- (NSTimeInterval)requestTimeoutInterval
{
    return _outtime;
}

/**
 网络请求封装,需要创建实体类再掉用
 
 @param requestBlock 传递结果
 */
-(void)StarRequest:(TBRequestBlock)requestBlock
{
    NSLog(@"\n%@\n%@\n%@\n",[[YTKNetworkAgent sharedAgent] buildRequestUrl:self],
          self.requestHeaderFieldValueDictionary,
          self.requestArgument);
    
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;//状态栏网络状态 隐藏
        NSLog(@"网络请求成功");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([request.responseJSONObject isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *responseDict=request.responseJSONObject;
                
                TBResponseStatus statues=[[responseDict objectForKey:TBJsonCodeStatus]integerValue];
                
                if (statues==TBResponseStatus_Success) {
            
                    requestBlock(statues,[responseDict objectForKey:TBJsonMessage],request.responseJSONObject);
                    
                }else if (statues==TBResponseStatus_Failure)
                {
                      requestBlock(statues,[responseDict objectForKey:TBJsonMessage],request.responseJSONObject);
                    
                }else if (statues==TBResponseStatus_abnormality){
                    
                     requestBlock(statues,[responseDict objectForKey:TBJsonMessage],request.responseJSONObject);

                }else{
                    
                    NSLog(@"未知状态");
                    
                }
                
            }else{
                
                NSLog(@"json错误");
                
            }
    
        });

    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;//状态栏网络
        NSLog(@"网络请求失败");
        
        NSLog(@"%@",request.error);
        dispatch_async(dispatch_get_main_queue(), ^{
            
             requestBlock(2,@"网络错误",request.responseJSONObject);
   
        });
        
    }];

}

@end
