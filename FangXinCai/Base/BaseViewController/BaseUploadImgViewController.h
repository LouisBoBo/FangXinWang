//
//  BaseUploadImgViewController.h
//  FangXinCai
//
//  Created by ios-1 on 2018/1/24.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^PhotoLoadSuccBlock)(NSString*_Nonnull);
typedef void(^PhotoShowBlock)(NSString*_Nonnull);

@interface BaseUploadImgViewController : BaseViewController<MWPhotoBrowserDelegate,TZImagePickerControllerDelegate,UIImagePickerControllerDelegate>

@property(nonatomic,copy)PhotoShowBlock _Nonnull ImageUrlBlock;
@property (nonatomic, strong) NSMutableArray *imageArr;
/**
 相册选择相关
 */
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
/**
 去相册浏览图片／或者拍照并上传
 */
-(void)GotoLibaraySelectPhotoNum:(NSInteger)num andIsCantainScan:(BOOL)scan andBlock:(PhotoShowBlock _Nullable )showImageBlock;


/**
 去相处选择上传
 */
-(void)pushTZImagePickerController;


/**
 去拍照
 */
-(void)takePhoto;

/**
 *  去上传图片
 */

-(void)UploadPhotosWithImage:(UIImage*_Nullable)upimage anblock:(PhotoLoadSuccBlock _Nonnull )UploadImgaeblock;

//上传多张图片
-(void)UploadPhotosMoreImage:(NSArray*_Nullable)upimage anblock:(PhotoLoadSuccBlock _Nonnull )UploadImgaeblock;
@end
