//
//  ImageUploadReq.m
//  SafeFoodManagerDemo
//
//  Created by bob on 2017/9/19.
//  Copyright © 2017年 bob. All rights reserved.
//

#import "ImageUploadReq.h"
#import <AFNetworking/AFNetworking.h>
@implementation ImageUploadReq{

     UIImage *_image;
 
}

-(id)initWithImage:(UIImage*)image{
    self = [super init];
    if (self) {
        _image = image;
       
    }
    return self;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSString *)requestUrl {
    return @"/index.php/FoodCheckApi/uploadImg.json";
}

- (AFConstructingBlock)constructingBodyBlock {

    return ^(id<AFMultipartFormData> formData) {
        NSData *data = UIImageJPEGRepresentation(_image, 0.9);
        NSString *name = @"pic";
        NSString *formKey = @"pic";
        NSString *type = @"image/jpeg";
        [formData appendPartWithFileData:data name:formKey fileName:name mimeType:type];
 
    };
}

- (id)jsonValidator {
    return @{ @"data": [NSString class] };
}

- (NSString *)responseImageId {
    NSDictionary *dict = self.responseJSONObject;
    return dict[@"data"];
}

@end
