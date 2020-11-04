//
//  DefaultImgManager.m
//  YunShangShiJi
//
//  Created by zgl on 16/6/23.
//  Copyright © 2016年 ios-1. All rights reserved.
//

#import "DefaultImgManager.h"
#import "UIImage+helper.h"
#import <math.h>

@interface DefaultImgManager ()
{
    NSMutableDictionary *_imageDic;
}
@end

@implementation DefaultImgManager

+ (instancetype)sharedManager {
    static DefaultImgManager *sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
        sharedManager -> _imageDic = [NSMutableDictionary dictionary];
        assert(sharedManager != nil);
    });
    return sharedManager;
}

- (UIImage *)defaultImgWithSize:(CGSize)size {
    NSString *key = [NSString stringWithFormat:@"%.0fx%.0f",size.width, size.height];
    UIImage *img = [_imageDic objectForKey:key];
    if (img == nil) {
        img = [UIImage createDefaultImageWithSize:size];
        img !=nil?[_imageDic setObject:img forKey:key]:0;
    }
    return img;
}

@end
