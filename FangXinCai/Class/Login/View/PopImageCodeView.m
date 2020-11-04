//
//  PopImageCodeView.m
//  FangXinCai
//
//  Created by ios-1 on 2018/1/23.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "PopImageCodeView.h"

@implementation PopImageCodeView

- (instancetype)initWithFrame:(CGRect)frame andbalance:(NSString*)imageurl
{
    if(self = [super initWithFrame:frame])
    {
        [self creatMainView:imageurl];
    }
    return self;
}

- (void)creatMainView:(NSString*)imageurl
{
    _SharePopview = [[UIView alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth, kScreenHeight)];
    _SharePopview.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    _SharePopview.userInteractionEnabled = YES;
    [self addSubview:_SharePopview];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disapper)];
//    [_SharePopview addGestureRecognizer:tap];
    
    CGFloat ImagecodeHeigh = KZOOM6pt(500);
    CGFloat ImagecodeWith  = KScreenWidth - KZOOM6pt(100)*2;
    
    //弹框内容
    _ShareInvitationCodeView = [[UIView alloc]initWithFrame:CGRectMake(KZOOM6pt(100), (kScreenHeight-ImagecodeHeigh)/2-KZOOM6pt(100), ImagecodeWith, ImagecodeHeigh)];
    _ShareInvitationCodeView.layer.cornerRadius = 5;
    _ShareInvitationCodeView.backgroundColor = KWhiteColor;
    [_SharePopview addSubview:_ShareInvitationCodeView];
    
    //标题
    UILabel *titlelab = [[UILabel alloc]initWithFrame:CGRectMake(0, KZOOM6pt(30), ImagecodeWith, KZOOM6pt(100))];
    titlelab.text = @"请输入图片验证码";
    titlelab.textColor = KGrayColor;
    titlelab.font = [UIFont systemFontOfSize:KZOOM6pt(30)];
    titlelab.textAlignment = NSTextAlignmentCenter;
    [_ShareInvitationCodeView addSubview:titlelab];
    
    //图片
    CGFloat imgHeigh = KZOOM6pt(80);
    CGFloat imgwidth = KZOOM6pt(333);
    
    _SharetitleImg = [[UIImageView alloc]initWithFrame:CGRectMake(KZOOM6pt(50), CGRectGetMaxY(titlelab.frame), imgwidth, imgHeigh)];
    _SharetitleImg.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_SharetitleImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ReqUrl,imageurl]]];
    [_ShareInvitationCodeView addSubview:_SharetitleImg];
    
    //刷新按钮
    UIButton *freshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    freshBtn.frame = CGRectMake(ImagecodeWith-KZOOM6pt(40)-KZOOM6pt(150), CGRectGetMinY(_SharetitleImg.frame), KZOOM6pt(150), KZOOM6pt(80));

    freshBtn.titleLabel.font = [UIFont systemFontOfSize:KZOOM6pt(30)];
    [freshBtn setTitleColor:KGrayColor forState:UIControlStateNormal];
    [freshBtn setImage:[UIImage imageNamed:@"刷新验证码"] forState:UIControlStateNormal];
    [freshBtn setTitle:@"刷新" forState:UIControlStateNormal];
    [freshBtn setImageEdgeInsets:UIEdgeInsetsMake(KZOOM6pt(10), KZOOM6pt(20), KZOOM6pt(10), KZOOM6pt(10))];
    [freshBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, KZOOM6pt(40), 0, KZOOM6pt(10))];
    [freshBtn addTarget:self action:@selector(freshCode:) forControlEvents:UIControlEventTouchUpInside];
    [_ShareInvitationCodeView addSubview:freshBtn];
    
    //输入框
    UITextField *textfield = [[UITextField alloc]initWithFrame:CGRectMake(KZOOM6pt(50), CGRectGetMaxY(_SharetitleImg.frame)+KZOOM6pt(50), ImagecodeWith-2*KZOOM6pt(50), 30)];
    textfield.delegate = self;
    textfield.backgroundColor = [UIColor groupTableViewBackgroundColor];
    textfield.placeholder = @"请输入验证码";
    textfield.font = [UIFont systemFontOfSize:KZOOM6pt(28)];
    [_ShareInvitationCodeView addSubview:self.inputTextField = textfield];
    
    //按钮
    CGFloat gobtnWidth = (CGRectGetWidth(_ShareInvitationCodeView.frame)-2*KZOOM6pt(50)-20)/2;
    CGFloat gobtnHeigh = KZOOM6pt(70);
    CGFloat spaceHeigh = 0;
    NSArray *btnArr = @[@"取消",@"确定"];
    for(int k =0;k<2;k++)
    {
        UIButton *gobtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        gobtn.frame = CGRectMake(KZOOM6pt(50)+(gobtnWidth+20)*k, CGRectGetMaxY(textfield.frame)+KZOOM6pt(50) +spaceHeigh, gobtnWidth, gobtnHeigh);
        gobtn.backgroundColor = basegreenColor;
        gobtn.clipsToBounds = YES;
        gobtn.tag = 7788+k;
        gobtn.layer.cornerRadius = 5;
        [gobtn setTitle:btnArr[k] forState:UIControlStateNormal];
        [gobtn setTintColor:[UIColor whiteColor]];
        gobtn.titleLabel.font = [UIFont systemFontOfSize:KZOOM6pt(30)];
        [gobtn addTarget:self action:@selector(goClick:) forControlEvents:UIControlEventTouchUpInside];
        [_ShareInvitationCodeView addSubview:gobtn];
    }

    _ShareInvitationCodeView.transform = CGAffineTransformMakeScale(0.3, 0.3);
    _ShareInvitationCodeView.alpha = 0.5;
    _SharePopview.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        _SharePopview.backgroundColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0] colorWithAlphaComponent:0.5];
        
        _ShareInvitationCodeView.transform = CGAffineTransformMakeScale(1, 1);
        _ShareInvitationCodeView.alpha = 1;
        
    } completion:^(BOOL finish) {
        
    }];
}

#pragma mark ******** 弹框点击事件 **********
- (void)goClick:(UIButton*)sender
{
    if(sender.tag == 7788)//取消
    {
        if(self.leftHideMindBlock)
        {
            self.leftHideMindBlock();
        }
        
    }else if (sender.tag == 7789)//确定
    {
        if(self.rightHideMindBlock)
        {
            self.rightHideMindBlock();
        }
        
        if(self.CodeSuccessBlock)
        {
            self.CodeSuccessBlock(self.inputTextField.text);
        }
    }
    
}

//弹框消失
- (void)disapper
{
    if(self.tapHideMindBlock)
    {
        self.tapHideMindBlock();
    }
}

//弹框消失
- (void)remindViewHiden
{

    [UIView animateWithDuration:0.5 animations:^{
        
        _SharePopview.backgroundColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0] colorWithAlphaComponent:0];
        _ShareInvitationCodeView.transform = CGAffineTransformMakeScale(0.25, 0.25);
        _ShareInvitationCodeView.alpha = 0;
        
    } completion:^(BOOL finish) {
        
        [self removeFromSuperview];
        
    }];
    
}

- (void)freshCode:(UIButton*)sender
{
    NSLog(@"刷新");
    [self imageCodeHttp];
}

- (void)imageCodeHttp
{
    NSString *phone = [KUserDefaul objectForKey:User_Phone];
    NSMutableDictionary *reqDict = [NSMutableDictionary dictionary];
    [reqDict setValue:phone forKey:@"mobile"];
    
    BaseReqApi *Api=[[BaseReqApi alloc]initWithRequestUrl:@"verifyCode.json" andrequestTime:5 andParams:reqDict andRequestMethod:YTKRequestMethodPOST andCache:NO andCacheTime:0 andPostToken:NO];
    [MBProgressHUD showMessage:@"加载中..." afterDeleay:10 WithView:self];
    [Api StarRequest:^(TBResponseStatus responseStatus, NSString *message, id responseObject) {
        [MBProgressHUD hideHUD];
        if (responseStatus == 1) {
            [_SharetitleImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ReqUrl,responseObject[@"data"]]]];
        }else if (responseStatus==0||responseStatus==2)
        {
            [MBProgressHUD showError:message toView:kAppWindow];
        }else{
            
            [MBProgressHUD showError:message toView:kAppWindow];
        }
    }];
    
}
@end
