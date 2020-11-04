//
//  HelpWay.h
//  SafeFoodManagerDemo
//
//  Created by bob on 2017/10/19.
//  Copyright © 2017年 bob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HelpWay : NSObject

//检查手机号
+ (BOOL) isMobileNum:(NSString *)mobNum;

//date转字符串
+(NSString*)dateToStringWith:(NSDate *)date;
//字符串转date
+(NSDate*)stringToDateWithString:(NSString*)string;

//数组转son
+(NSString*)arrToJSON:(NSArray*)arr;

//字典转json
+ (NSString *)dictionaryToJSON:(NSDictionary * )dictionary;

//将图片字符串转为数组

+(NSArray*)imageStrToArr:(NSString*)imageValue;

//时间戳转换为时间的方法
+ (NSString *)timestampChangesStandarTime:(NSString *)timestam;

//日期转时间戳

+(NSString*)DateTotimestampWithTime:(NSString*)date;
@end
