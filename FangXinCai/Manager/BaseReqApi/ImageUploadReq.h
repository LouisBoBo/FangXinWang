//
//  ImageUploadReq.h
//  SafeFoodManagerDemo
//
//  Created by bob on 2017/9/19.
//  Copyright © 2017年 bob. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>
#import <UIKit/UIKit.h>
@interface ImageUploadReq : YTKRequest

-(id)initWithImage:(UIImage*)image;

- (NSString *)responseImageId;

@end
