//
//  UploadStoreViewController.h
//  FangXinCai
//
//  Created by ios-1 on 2018/1/24.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "BaseUploadImgViewController.h"

@interface UploadStoreViewController : BaseUploadImgViewController
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *titlelab;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIImageView *uploadImg;
@property (weak, nonatomic) IBOutlet UIButton *uploadBtn;

@property (nonatomic , strong) void (^uploadSuccess)(NSString*imagesta);
@end
