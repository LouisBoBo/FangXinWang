//
//  MBProgressHUD+XJ.m
//  dreamer
//
//  Created by 晓杰 on 15-1-13.
//  Copyright (c) 2015年 PA. All rights reserved.
//

#import "MBProgressHUD+XJ.h"



@implementation MBProgressHUD (XJ)

+ (void)showMessage:(NSString *)text afterDeleay:(CGFloat)delay WithView:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;

    hud.removeFromSuperViewOnHide = YES;

    [hud show:YES];
    if (delay) {
        NSTimeInterval time = delay;
        [hud hide:YES afterDelay:time];
    }
 
}
+ (void)showafterDeleay:(CGFloat)delay WithView:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddTo:view animated:YES];
    
    hud.removeFromSuperViewOnHide = YES;
    
    [hud show:YES];
    if (delay) {
        NSTimeInterval time = delay;
        [hud hide:YES afterDelay:time];
    }
    
    
}

+ (void)hideHudForView:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
     [MBProgressHUD hideAllHUDsForView:view animated:YES];
    

}



@end
