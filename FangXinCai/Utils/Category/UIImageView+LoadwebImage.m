//
//  UIImageView+LoadwebImage.m
//  SafeFoodManagerDemo
//
//  Created by bob on 2017/9/19.
//  Copyright © 2017年 bob. All rights reserved.
//

#import "UIImageView+LoadwebImage.h"
#import "TBReqApi.h"
#import <SDWebImage/UIImageView+WebCache.h>
@implementation UIImageView (LoadwebImage)

-(void)LoadWebImageWithName:(NSString*)name andIsOrgin:(BOOL)isOrrgin
{
    
     NSString *URLStr=[NSString stringWithFormat:@"%@/%@",ReqUrl,name];
    
    if (!isOrrgin) {

         [URLStr stringByReplacingOccurrencesOfString:@"." withString:@"_thumb."];
    }
    
    [self sd_setImageWithURL:[NSURL URLWithString:URLStr] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    
}

-(void)LoadWebImageWithName:(NSString*)name andIsOrgin:(BOOL)isOrrgin andPlaceImage:(NSString*)imageName
{
    

    NSString *URLStr=[NSString stringWithFormat:@"%@/%@",ReqUrl,name];
    
    if (!isOrrgin) {
        
        [URLStr stringByReplacingOccurrencesOfString:@"." withString:@"_thumb."];
    }
    
    [self sd_setImageWithURL:[NSURL URLWithString:URLStr] placeholderImage:[UIImage imageNamed:imageName]];
 
}

@end
