//
//  UploadStoreViewController.m
//  FangXinCai
//
//  Created by ios-1 on 2018/1/24.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "UploadStoreViewController.h"

@interface UploadStoreViewController ()

@end

@implementation UploadStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"营业执照上传";
    [self creatMainView];
}

- (void)creatMainView
{
    self.backView.layer.cornerRadius = 5;
    
    [self.uploadImg sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:DefaultImg(self.uploadImg.frame.size)];
    
    self.uploadBtn.layer.cornerRadius = 5;
    self.uploadBtn.layer.borderColor = basegreenColor.CGColor;
    self.uploadBtn.layer.borderWidth = 1;
    [self.uploadBtn setTitleColor:basegreenColor forState:UIControlStateNormal];
    [self.uploadBtn addTarget:self action:@selector(uploadClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.saveBtn.layer.cornerRadius = 5;
    self.saveBtn.backgroundColor = basegreenColor;
    [self.saveBtn setTitleColor:KWhiteColor forState:UIControlStateNormal];
    [self.saveBtn addTarget:self action:@selector(saveClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)uploadClick:(UIButton*)sender
{
    NSLog(@"上传");
    [self.imageArr removeAllObjects];
    [self GotoLibaraySelectPhotoNum:2 andIsCantainScan:NO andBlock:^(NSString * armStr) {
        self.uploadImg.image = self.imageArr[0];
    }];
}
- (void)saveClick:(UIButton*)sender
{
    NSLog(@"保存");
    [self UploadPhotosWithImage:self.uploadImg.image anblock:^(NSString * imageStr) {
        if(self.uploadSuccess)
        {
            self.uploadSuccess(imageStr);
        }
    }];
    
    [self performSelector:@selector(uploadSuccessGoback) withObject:nil afterDelay:1.0];
}
//图片上传成功返回上级页面
- (void)uploadSuccessGoback
{
    [self.navigationController popViewControllerAnimated:YES];
}
//将图片上传到服务器
-(void)UploadPhotosWithImage:(UIImage*)upimage anblock:(PhotoLoadSuccBlock)UploadImgaeblock
{
    NSData *data = UIImageJPEGRepresentation(upimage, 1.0f);
    
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    [MBProgressHUD showMessage:@"正在上传图片" afterDeleay:20 WithView:self.view];
    BaseReqApi *api=[[BaseReqApi alloc]initWithRequestUrl:@"uploadPicture.json" andrequestTime:20 andParams:@{@"pic":encodedImageStr} andRequestMethod:YTKRequestMethodPOST andCache:NO andCacheTime:0 andPostToken:NO];
    
    [api StarRequest:^(TBResponseStatus responseStatus, NSString *message, id responseObject) {
        
        [self stopLoadingAnimation];
        
        if (responseStatus==1) {
            [MBProgressHUD show:@"上传成功" icon:nil view:self.view];
            UploadImgaeblock(responseObject[@"data"]);
            
        }else{
            [MBProgressHUD show:message icon:nil view:self.view];
        }
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
