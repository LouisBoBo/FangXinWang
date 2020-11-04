//
//  ChangeUserInfoManager.m
//  FangXinCai
//
//  Created by ios-1 on 2018/2/23.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "ChangeUserInfoManager.h"

@implementation ChangeUserInfoManager
+(instancetype)changeUserInfoManarer;
{
    static ChangeUserInfoManager *infoManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        infoManager = [[self alloc] init];
        assert(infoManager != nil);
    });
    return infoManager;
}

- (void)changeUserInfoHttp:(NSString*)head_pic NickName:(NSString*)nickname Sex:(NSString*)sex Email:(NSString*)email Success:(void(^)(id data))success;
{
    NSString *token = [KUserDefaul objectForKey:User_Token];
    NSMutableDictionary *reqDict = [NSMutableDictionary dictionary];
    [reqDict setValue:token forKey:@"token"];
    [reqDict setValue:head_pic forKey:@"head_pic"];
    [reqDict setValue:nickname forKey:@"nickname"];
    [reqDict setValue:sex forKey:@"sex"];
    [reqDict setValue:email forKey:@"email"];
    
    BaseReqApi *LoginApi=[[BaseReqApi alloc]initWithRequestUrl:@"editUserInfo.json" andrequestTime:5 andParams:reqDict andRequestMethod:YTKRequestMethodPOST andCache:NO andCacheTime:0 andPostToken:NO];
    [MBProgressHUD showMessage:@"加载中..." afterDeleay:10 WithView:kAppWindow];
    [LoginApi StarRequest:^(TBResponseStatus responseStatus, NSString *message, id responseObject) {
        [MBProgressHUD hideHUDForView:kAppWindow];
        
        if (responseStatus==1) {
            if(success)
            {
                success(responseObject);
            }
        }else if (responseStatus==0||responseStatus==2)
        {
            [MBProgressHUD showError:message toView:kAppWindow];
        }else{
            [MBProgressHUD showError:message toView:kAppWindow];
        }
    }];
}
@end
