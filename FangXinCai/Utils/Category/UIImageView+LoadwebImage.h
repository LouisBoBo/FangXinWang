//
//  UIImageView+LoadwebImage.h
//  SafeFoodManagerDemo
//
//  Created by bob on 2017/9/19.
//  Copyright © 2017年 bob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (LoadwebImage)

-(void)LoadWebImageWithName:(NSString*)name andIsOrgin:(BOOL)isOrrgin;

-(void)LoadWebImageWithName:(NSString*)name andIsOrgin:(BOOL)isOrrgin andPlaceImage:(NSString*)imageName;

@end
