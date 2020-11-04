//
//  BaseUploadImgViewController.m
//  FangXinCai
//
//  Created by ios-1 on 2018/1/24.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "BaseUploadImgViewController.h"
#import "MWPhoto.h"
#import "TB_Permiss.h"
@interface BaseUploadImgViewController ()

@end

@implementation BaseUploadImgViewController
{
    NSInteger maxPhotoNum;
    
    BOOL isScanModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    
    return self.ScanPhotoArr.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    
    if (index < self.ScanPhotoArr.count)
        return [self.ScanPhotoArr objectAtIndex:index];
    return nil;
}
//自定义标题
- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser
      titleForPhotoAtIndex:(NSUInteger)index {
    return [NSString stringWithFormat:@"%lu/%lu", (unsigned long)index+1,
            (unsigned long)self.ScanPhotoArr.count];
}

/**
 去相册浏览图片
 */
-(void)GotoLibaraySelectPhotoNum:(NSInteger)num andIsCantainScan:(BOOL)scan andBlock:(PhotoShowBlock _Nullable )showImageBlock
{
    self.ImageUrlBlock=showImageBlock;
    
    isScanModel=scan;
    
    maxPhotoNum=num;
    
    if (scan) {
        
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"去相册选择",@"扫一扫", nil];
        [sheet showInView:self.view];
        
    }else{
        
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"去相册选择", nil];
        [sheet showInView:self.view];
        
    }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) { // take photo / 去拍照
        if ([[TB_Permiss sharePermiss] CameraAuthority]) {
            
            [self takePhoto];
            
        }
    } else if (buttonIndex == 1) {
        if ([[TB_Permiss sharePermiss] PhotoLibraryAuthority]) {
            
            [self pushTZImagePickerController];
        }
        
    }
}

#pragma mark-去相册选择
-(void)pushTZImagePickerController{
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:maxPhotoNum columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    
    imagePickerVc.allowPickingVideo=NO;
    
    imagePickerVc.allowTakePicture=NO;
    
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
        if (maxPhotoNum==1) {
            
            UIImage *image=photos[0];
            
            if (isSelectOriginalPhoto) {
                
                if (image.size.width>500) {
                    
                    image=[image thumbnailWithImageWithoutScale:image size:CGSizeMake(500, 500*image.size.height/image.size.width)];
                }
                
            }
            
            [self.imageArr addObject:image];
            self.ImageUrlBlock(@"ok");
            
        }else{
            
            [self.imageArr addObjectsFromArray:photos];
            self.ImageUrlBlock(@"ok");
        }
        
    }];
    
    self.tabBarController.tabBar.hidden = YES;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark-去拍照
-(void)takePhoto
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
        // 无相机权限 做一个友好的提示
        if (iOS8Later) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
            [alert show];
        } else {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        if (iOS7Later) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self takePhoto];
                    });
                }
            }];
        } else {
            [self takePhoto];
        }
        // 拍照之前还需要检查相册权限
    } else if ([TZImageManager authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        if (iOS8Later) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
            [alert show];
        } else {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    } else if ([TZImageManager authorizationStatus] == 0) { // 未请求过相册权限
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self takePhoto];
        }];
    } else {
        [self pushImagePickerController];
    }
    
    
}

#pragma mark-拍照
-(void)pushImagePickerController
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVc.sourceType = sourceType;
        if(iOS8Later) {
            _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        }
        [self presentViewController:_imagePickerVc animated:YES completion:nil];
    } else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
    
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        tzImagePickerVc.sortAscendingByModificationDate = YES;
        [tzImagePickerVc showProgressHUD];
        
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        if (image.size.width>500) {
            
            image=[image thumbnailWithImageWithoutScale:image size:CGSizeMake(500, 500*image.size.height/image.size.width)];
        }
        
        [self.imageArr addObject:image];
        self.ImageUrlBlock(@"ok");
        
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image location:nil completion:^(NSError *error){
            if (error) {
                [tzImagePickerVc hideProgressHUD];
                NSLog(@"图片保存失败 %@",error);
            }
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

/**
 拍照懒加载
 
 @return pic
 */
- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
        
    }
    return _imagePickerVc;
}

///**
// *  去上传图片
// */
//
//-(void)UploadPhotosWithImage:(UIImage*)upimage anblock:(PhotoLoadSuccBlock)UploadImgaeblock
//{
//    NSData *data = UIImageJPEGRepresentation(upimage, 1.0f);
//
//    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
//
//    [MBProgressHUD showActivityMessageInView:@"正在上传..." timer:20];
//
//    BaseReqApi *api=[[BaseReqApi alloc]initWithRequestUrl:@"/index.php/FoodCheckApi/uploadImg.json" andrequestTime:20 andParams:@{@"pic":encodedImageStr} andRequestMethod:YTKRequestMethodPOST andCache:NO andCacheTime:0 andPostToken:NO];
//
//    [api StarRequest:^(TBResponseStatus responseStatus, NSString *message, id responseObject) {
//
//        [self stopLoadingAnimation];
//
//        if (responseStatus==1) {
//
//            [MBProgressHUD showSuccessMessage:@"上传成功"];
//
//            UploadImgaeblock(responseObject[@"data"]);
//        }else{
//
//            [MBProgressHUD showErrorMessage:message];
//
//        }
//    }];
//
//}
//
////上传多张图片
//-(void)UploadPhotosMoreImage:(NSArray*)upimage anblock:(PhotoLoadSuccBlock)UploadImgaeblock
//{
//    NSMutableArray *uploadArr=[NSMutableArray array];
//
//    [MBProgressHUD showActivityMessageInView:@"正在上传..." timer:20];
//
//    for (UIImage *uploadimage in upimage) {
//
//        NSData *data = UIImageJPEGRepresentation(uploadimage, 1.0f);
//
//        NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
//        BaseReqApi *api=[[BaseReqApi alloc]initWithRequestUrl:@"/index.php/FoodCheckApi/uploadImg.json" andrequestTime:20 andParams:@{@"pic":encodedImageStr} andRequestMethod:YTKRequestMethodPOST andCache:NO andCacheTime:0 andPostToken:NO];
//
//        [uploadArr addObject:api];
//    }
//
//    YTKBatchRequest *batReq=[[YTKBatchRequest alloc]initWithRequestArray:uploadArr];
//
//    [batReq startWithCompletionBlockWithSuccess:^(YTKBatchRequest * _Nonnull batchRequest) {
//
//        [self stopLoadingAnimation];
//
//        NSArray *requests = batchRequest.requestArray;
//
//        NSString*ResultStr=@"";
//
//        for (BaseReqApi *Rapi in requests) {
//
//            NSLog(@"%@",Rapi.responseObject);
//
//            if (ResultStr.length==0) {
//
//                ResultStr=Rapi.responseObject[@"data"];
//
//            }else{
//
//                ResultStr=[NSString stringWithFormat:@"%@|%@",ResultStr,Rapi.responseObject[@"data"]];
//            }
//
//        }
//
//        UploadImgaeblock(ResultStr);
//
//        [MBProgressHUD showSuccessMessage:@"上传成功"];
//
//    } failure:^(YTKBatchRequest * _Nonnull batchRequest) {
//
//        [MBProgressHUD showErrorMessage:@"上传失败"];
//
//    }];
//
//
//}
- (NSMutableArray*)imageArr
{
    if(_imageArr == nil)
    {
        _imageArr = [NSMutableArray array];
    }
    return _imageArr;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
