//
//  SettingViewController.m
//  FangXinCai
//
//  Created by ios-1 on 2018/1/10.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "SettingViewController.h"
#import "InvoiceViewController.h"
#import "ChangeUserInfoManager.h"
#import "ChangePassWordViewController.h"
#import "ChangePayPasswordViewController.h"
#import "XZPickView.h"
@interface SettingViewController ()<XZPickViewDelegate,XZPickViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,strong) XZPickView *emitterPickView;
@property (nonatomic,copy)   NSArray * emitterArray;
@end

@implementation SettingViewController
{
    UIImagePickerController *pickerController;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CViewBgColor;
    self.title = @"设置";
    self.emitterArray = @[@"保密",@"男",@"女"];
    
    [self creatMainView];
    [self getUserInfoHttp];
}

- (void)creatMainView
{
    UITapGestureRecognizer *headtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headClick:)];
    UITapGestureRecognizer *nicknametap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(nicknameClick:)];
    UITapGestureRecognizer *gendertap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(genderClick:)];
    UITapGestureRecognizer *phonetap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(phoneClick:)];
    UITapGestureRecognizer *emailtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(emailClick:)];
    UITapGestureRecognizer *logintap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loginClick:)];
    UITapGestureRecognizer *paytap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(payClick:)];
    UITapGestureRecognizer *customertap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(customerClick:)];
    
    self.headimag.clipsToBounds = YES;
    self.headimag.layer.cornerRadius = CGRectGetWidth(self.headimag.frame)/2;
    
    [self.Headview addGestureRecognizer:headtap];
    [self.nicknameview addGestureRecognizer:nicknametap];
    [self.Genderview addGestureRecognizer:gendertap];
    [self.Phoneview addGestureRecognizer:phonetap];
    [self.Emailview addGestureRecognizer:emailtap];
    [self.Loginview addGestureRecognizer:logintap];
    [self.Payview addGestureRecognizer:paytap];
    [self.Customerview addGestureRecognizer:customertap];
}

#pragma mark *************网络请求****************
//将图片上传到服务器
-(void)UploadPhotosWithImage:(UIImage*)upimage
{
    NSData *data = UIImageJPEGRepresentation(upimage, 1.0f);
    
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    [MBProgressHUD showMessage:@"正在上传图片" afterDeleay:20 WithView:self.view];
    BaseReqApi *api=[[BaseReqApi alloc]initWithRequestUrl:@"uploadPicture.json" andrequestTime:20 andParams:@{@"pic":encodedImageStr} andRequestMethod:YTKRequestMethodPOST andCache:NO andCacheTime:0 andPostToken:NO];
    
    [api StarRequest:^(TBResponseStatus responseStatus, NSString *message, id responseObject) {
        
        [self stopLoadingAnimation];
        
        if (responseStatus==1) {
            [MBProgressHUD show:@"上传成功" icon:nil view:self.view];
            
            //图像上传成功 修改用户头像
            [[ChangeUserInfoManager changeUserInfoManarer] changeUserInfoHttp:responseObject[@"data"] NickName:nil Sex:nil Email:nil Success:^(id data) {
            }];
        }else{
            [MBProgressHUD show:message icon:nil view:self.view];
        }
    }];
    
}
//获取用户信息
- (void)getUserInfoHttp
{
    NSString *token = [KUserDefaul objectForKey:User_Token];
    NSMutableDictionary *reqDict = [NSMutableDictionary dictionary];
    [reqDict setValue:token forKey:@"token"];
    
    BaseReqApi *LoginApi=[[BaseReqApi alloc]initWithRequestUrl:@"userInformation.json" andrequestTime:5 andParams:reqDict andRequestMethod:YTKRequestMethodPOST andCache:NO andCacheTime:0 andPostToken:NO];
    [MBProgressHUD showMessage:@"加载中..." afterDeleay:10 WithView:self.view];
    [LoginApi StarRequest:^(TBResponseStatus responseStatus, NSString *message, id responseObject) {
        [MBProgressHUD hideHUD];
        
        if (responseStatus==1) {
            [self refreshUI:responseObject[@"data"]];
        }else if (responseStatus==0||responseStatus==2)
        {
            [MBProgressHUD showError:message toView:self.view];
        }else{
            [MBProgressHUD showError:message toView:self.view];
            kWeakSelf(self);
            [self loginSuccess:^{
                [weakself getUserInfoHttp];
            }];
        }
    }];
}
- (void)refreshUI:(NSDictionary*)data
{
    //用户信息
    NSString *head_pic = [NSString stringWithFormat:@"%@",data[@"head_pic"]];
    if(head_pic.length > 10)
    {
        [self.headimag sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ReqUrl,head_pic]]];
    }
    NSString *gerder = @"";
    if([data[@"sex"] integerValue]==0)
    {
        gerder = @"保密";
    }else if ([data[@"sex"] integerValue]==1)
    {
        gerder = @"男";
    }else if ([data[@"sex"] integerValue]==2)
    {
        gerder = @"女";
    }
    self.nickname.text = [NSString stringWithFormat:@"%@",data[@"nickname"]];
    self.gender.text = [NSString stringWithFormat:@"%@",gerder];
    self.phone.text = [NSString stringWithFormat:@"%@",data[@"mobile"]];
    self.email.text = [NSString stringWithFormat:@"%@",data[@"email"]];
}
//用户头像
- (void)headClick:(UIGestureRecognizer*)tap
{
    NSLog(@"用户头像");
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"选择头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}
//用户昵称
- (void)nicknameClick:(UIGestureRecognizer*)tap
{
    NSLog(@"用户昵称");
    [self changeInfor:@"昵称" Info:self.nickname.text];
}
//用户性别
- (void)genderClick:(UIGestureRecognizer*)tap
{
    NSLog(@"用户性别");
    [self emitter];
}
//用户电话
- (void)phoneClick:(UIGestureRecognizer*)tap
{
    NSLog(@"用户电话");
}
//用户邮箱
- (void)emailClick:(UIGestureRecognizer*)tap
{
    NSLog(@"用户邮箱");
    [self changeInfor:@"邮箱" Info:self.email.text];
}
//登录密码
- (void)loginClick:(UIGestureRecognizer*)tap
{
    NSLog(@"登录密码");
    ChangePassWordViewController *changePassword = [[ChangePassWordViewController alloc]init];
    [self.navigationController pushViewController:changePassword animated:YES];
}
//支付密码
- (void)payClick:(UIGestureRecognizer*)tap
{
    NSLog(@"支付密码");
    ChangePayPasswordViewController *paypassword = [[ChangePayPasswordViewController alloc]init];
    [self.navigationController pushViewController:paypassword animated:YES];
}
//商户信息
- (void)customerClick:(UIGestureRecognizer*)tap
{
    NSLog(@"商户信息");
}

#pragma mark 修改用户信息
- (void)changeInfor:(NSString*)title Info:(NSString*)info
{
    InvoiceViewController *invoice = [[InvoiceViewController alloc]init];
    invoice.title = title;
    invoice.valueinfo = info;
    invoice.hidesBottomBarWhenPushed = YES;
    
    kWeakSelf(self);
    invoice.changeSuccess = ^{
        [weakself getUserInfoHttp];
    };
    [self.navigationController pushViewController:invoice animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark *************用户图像*******************
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //初始化pickerController
    pickerController = [[UIImagePickerController alloc]init];
    pickerController.view.backgroundColor = [UIColor orangeColor];
    pickerController.delegate = self;
    pickerController.allowsEditing = YES;
    
    if (buttonIndex == 0) {//相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            NSLog(@"支持相机");
            [self makePhoto];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请在设置-->隐私-->相机，中开启本应用的相机访问权限！！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"我知道了", nil];
            [alert show];
        }
    }else if (buttonIndex == 1){//相片
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
        {
            NSLog(@"支持图库");
            [self pictureLibrary];
            //            [self presentViewController:picker animated:YES completion:nil];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请在设置-->隐私-->照片，中开启本应用的相机访问权限！！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"我知道了", nil];
            [alert show];
        }
    }else if (buttonIndex == 2){//取消

    }else if (buttonIndex == 3){
        
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        {
            NSLog(@"支持相册");
            [self choosePicture];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请在设置-->隐私-->照片，中开启本应用的相机访问权限！！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"我知道了", nil];
            [alert show];
        }
    }
}
//跳转到imagePicker里
- (void)makePhoto
{
    pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:pickerController animated:YES completion:nil];
}
//跳转到相册
- (void)choosePicture
{
    pickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:pickerController animated:YES completion:nil];
}
//跳转图库
- (void)pictureLibrary
{
    pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:pickerController animated:YES completion:nil];
}
//用户取消退出picker时候调用
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"%@",picker);
    [pickerController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
//用户选中图片之后的回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"%s,info == %@",__func__,info);
    
    UIImage *userImage = [self fixOrientation:[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
    
    userImage = [self scaleImage:userImage toScale:0.3];
    
    [self.headimag setImage:userImage];

    [pickerController dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    //照片上传
    [self UploadPhotosWithImage:userImage];
}

//缩放图片
- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSLog(@"%@",NSStringFromCGSize(scaledImage.size));
    return scaledImage;
}
//修正照片方向(手机转90度方向拍照)
- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

#pragma mark **************姓别选择器**************
-(void)emitter{
    [self.emitterPickView reloadData];
    [kAppWindow addSubview:self.emitterPickView];
    [self.emitterPickView show];
}
#pragma mark -  XZPickView 代理
//列数
-(NSInteger)numberOfComponentsInPickerView:(XZPickView *)pickerView{
    return 1;
}

//行数
-(NSInteger)pickerView:(XZPickView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.emitterArray.count;
}

//标题
-(NSString *)pickerView:(XZPickView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.emitterArray[row];
}
//确认按钮点击
-(void)pickView:(XZPickView *)pickerView confirmButtonClick:(UIButton *)button{
    NSInteger left = [pickerView selectedRowInComponent:0];
   
    NSString *gender = [NSString stringWithFormat:@"%zd",left];
    kWeakSelf(self);
    [[ChangeUserInfoManager changeUserInfoManarer] changeUserInfoHttp:nil NickName:nil Sex:gender Email:nil Success:^(id data) {
        [weakself getUserInfoHttp];
    }];
}

-(XZPickView *)emitterPickView{
    if(!_emitterPickView){
        _emitterPickView = [[XZPickView alloc]initWithFrame:kScreen_Bounds title:@"请选择"];
        _emitterPickView.delegate = self;
        _emitterPickView.dataSource = self;
    }
    return _emitterPickView;
}
@end
