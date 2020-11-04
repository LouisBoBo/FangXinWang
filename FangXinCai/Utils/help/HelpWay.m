//
//  HelpWay.m
//  SafeFoodManagerDemo
//
//  Created by bob on 2017/10/19.
//  Copyright © 2017年 bob. All rights reserved.
//

#import "HelpWay.h"

@implementation HelpWay

+ (BOOL) isMobileNum:(NSString *)mobNum {
    //    电信号段:133/149/153/173/177/180/181/189
    //    联通号段:130/131/132/145/155/156/171/175/176/185/186
    //    移动号段:134/135/136/137/138/139/147/150/151/152/157/158/159/178/182/183/184/187/188
    //    虚拟运营商:170
    
    NSString *MOBILE = @"^1(3[0-9]|4[579]|5[0-35-9]|7[0135-8]|8[0-9])\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    return [regextestmobile evaluateWithObject:mobNum];
}

+(NSString*)dateToStringWith:(NSDate *)date
{
    NSLog(@"%@",date);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    
    return strDate;
}

+(NSDate*)stringToDateWithString:(NSString*)string
{
    
    //设置转换格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    //NSString转NSDate
    NSDate *date=[formatter dateFromString:string];
    
    return date;
    
}

//时间戳转时间
+ (NSString *)getTimeToShowWithTimestampHour:(NSString *)timestamp
{
    if (![timestamp isEqual:[NSNull null]] ) {
        double publishLong = [timestamp doubleValue];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        [formatter setDateFormat:@"yyyy.MM.dd"];
        
        NSDate *publishDate = [NSDate dateWithTimeIntervalSince1970:publishLong/1000];
        
        NSDate *date = [NSDate date];
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMTForDate:date];
        publishDate = [publishDate  dateByAddingTimeInterval: interval];
        
        NSString* publishString = [formatter stringFromDate:publishDate];
        return publishString;
    } else
        return timestamp;
    
}

//数组转son
+(NSString*)arrToJSON:(NSArray*)arr
{
    
    NSString *json = nil;
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr options:0 error:&error];
    
    if (!jsonData) {
        return @"[]";
    } else if (!error) {
        json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return json;
    } else {
        return error.localizedDescription;
    }
    
}

//字典转json
+ (NSString * _Nonnull)dictionaryToJSON:(NSDictionary * _Nonnull)dictionary {
    NSString *json = nil;
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
    
    if (!jsonData) {
        return @"{}";
    } else if (!error) {
        json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return json;
    } else {
        return error.localizedDescription;
    }
}

//将图片字符串转为数组

+(NSArray*)imageStrToArr:(NSString*)imageValue
{
    NSMutableArray *Rarr=[NSMutableArray array];
    
    if (imageValue.length==0) {
        
        return Rarr;
        
    }else{
        
        if ([imageValue rangeOfString:@"|"].location!=NSNotFound) {
            
            NSArray *arr=[imageValue componentsSeparatedByString:@"|"];
            
            [Rarr addObjectsFromArray:arr];
            
        }else{
            
            [Rarr addObject:imageValue];
            
        }
        
        
    }

    return Rarr;
}

/**
 *  时间戳转换为时间的方法
 *
 *  @param timestamp 时间戳
 *
 *  @return 标准时间字符串
 */
+ (NSString *)timestampChangesStandarTime:(NSString *)timestamp
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue]];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
    
}


//日期转时间戳

+(NSString*)DateTotimestampWithTime:(NSString*)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //指定时间显示样式: HH表示24小时制 hh表示12小时制
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *lastTime = date;
    NSDate *lastDate = [formatter dateFromString:lastTime];
    //以 1970/01/01 GMT为基准，得到lastDate的时间戳
    long firstStamp = [lastDate timeIntervalSince1970];
    NSLog(@"firstStamp:%ld",firstStamp);
    return [NSString stringWithFormat:@"%ld",firstStamp];

}
@end
