//
//  ChangeUserInfoManager.h
//  FangXinCai
//
//  Created by ios-1 on 2018/2/23.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChangeUserInfoManager : NSObject
+(instancetype)changeUserInfoManarer;
- (void)changeUserInfoHttp:(NSString*)head_pic NickName:(NSString*)nickname Sex:(NSString*)sex Email:(NSString*)email Success:(void(^)(id data))success;
@end
