//
//  UIImage+helper.m
//  YunShangShiJi
//
//  Created by zgl on 16/6/7.
//  Copyright © 2016年 ios-1. All rights reserved.
//

#import "UIImage+helper.h"

@implementation UIImage (helper)

- (UIImage *)scaleImageMaxWidth:(float)width
{
    CGSize temSize = CGSizeZero;
    if (self.size.width <= width)
    {
        temSize = self.size;
    }
    else
    {
        temSize = CGSizeMake(width, self.size.height * width /self.size.width);
    }
    UIGraphicsBeginImageContext(temSize);
    [self drawInRect:CGRectMake(0, 0, temSize.width, temSize.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (UIImage *)scaleImageWidth:(float)width
{
    CGSize temSize = CGSizeZero;
    temSize = CGSizeMake(width, self.size.height * width /self.size.width);
    UIGraphicsBeginImageContext(temSize);
    [self drawInRect:CGRectMake(0, 0, temSize.width, temSize.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

/// 默认图片
+ (UIImage*)createDefaultImageWithSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    UIImage *image =[UIImage imageNamed:@"默认图片"];
    image = [image scaleImageWidth:size.width/3];
    CGRect frame = CGRectMake((size.width - image.size.width)/2, (size.height - image.size.height)/2, image.size.width, image.size.height);
    [image drawInRect:frame];
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetBlendMode(contextRef, kCGBlendModeDifference);
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

@end
