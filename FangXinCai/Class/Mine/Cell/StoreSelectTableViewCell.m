//
//  StoreSelectTableViewCell.m
//  FangXinCai
//
//  Created by ios-1 on 2018/1/20.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "StoreSelectTableViewCell.h"

@implementation StoreSelectTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.ClaimBtn.layer.borderWidth =1;
    self.ClaimBtn.layer.borderColor = basegreenColor.CGColor;
    self.ClaimBtn.layer.cornerRadius = CGRectGetHeight(self.ClaimBtn.frame)/2;
    [self.ClaimBtn setTitleColor:basegreenColor forState:UIControlStateNormal];
    [self.ClaimBtn addTarget:self action:@selector(ClaimClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.statusImg.hidden = YES;
}

- (void)refreshData:(PickshopData*)model;
{
    self.nickName.text = model.shops_name;
    self.model = model;
    if(model.admin_user_id.integerValue >0 || model.isSelected)//认领过了可以申请加入
    {
        self.ClaimBtn.layer.borderColor = baseyellowColor.CGColor;
        [self.ClaimBtn setTitleColor:baseyellowColor forState:UIControlStateNormal];
        self.statusImg.hidden = NO;
    }
}
- (void)ClaimClick:(UIButton*)sender
{
    if(self.model.admin_user_id == 0)//可以认领
    {
//        [self ClaimStoreHttp];
    }else{//可以申请加入
        [self ApplyStoreHttp];
    }
}
//申请加入商户
- (void)ApplyStoreHttp
{
    NSString *token = [KUserDefaul objectForKey:User_Token];
    NSMutableDictionary *reqDict = [NSMutableDictionary dictionary];
    [reqDict setValue:token forKey:@"token"];
    [reqDict setValue:self.model.shops_id forKey:@"shops_id"];
    
    BaseReqApi *LoginApi=[[BaseReqApi alloc]initWithRequestUrl:@"applySuccess.json" andrequestTime:5 andParams:reqDict andRequestMethod:YTKRequestMethodPOST andCache:NO andCacheTime:0 andPostToken:NO];

    [MBProgressHUD showMessage:@"加载中..." afterDeleay:10 WithView:kAppWindow];
    [LoginApi StarRequest:^(TBResponseStatus responseStatus, NSString *message, id responseObject) {
        [MBProgressHUD hideHUD];
        
        if (responseStatus==1) {
            [MBProgressHUD showCustomIconInView:@"success" message:@"申请成功"];
            
            self.model.apply_id = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"apply_id"]];
            [self saveShops_id:responseObject];
            [self performSelector:@selector(claimSuccess) withObject:nil afterDelay:1.0];
            
        }else if (responseStatus==0||responseStatus==2)
        {
            [MBProgressHUD showError:message toView:kAppWindow];
        }else{
            [MBProgressHUD showError:message toView:kAppWindow];
        }
        
    }];
}
//认领商户
- (void)ClaimStoreHttp
{
    NSString *token = [KUserDefaul objectForKey:User_Token];
    NSMutableDictionary *reqDict = [NSMutableDictionary dictionary];
    [reqDict setValue:token forKey:@"token"];
    [reqDict setValue:self.model.shops_contacts forKey:@"shops_contacts"];
    
    BaseReqApi *LoginApi=[[BaseReqApi alloc]initWithRequestUrl:@"getbackShop.json" andrequestTime:5 andParams:reqDict andRequestMethod:YTKRequestMethodPOST andCache:NO andCacheTime:0 andPostToken:NO];
    
    [MBProgressHUD showMessage:@"加载中..." afterDeleay:10 WithView:kAppWindow];
    [LoginApi StarRequest:^(TBResponseStatus responseStatus, NSString *message, id responseObject) {
        [MBProgressHUD hideHUD];
        
        if (responseStatus==1) {
            [MBProgressHUD showCustomIconInView:@"success" message:@"认领成功"];
            [self saveShops_id:responseObject];
            [self ClaimSuccessFreshClaimBtn];
            
        }else if (responseStatus==0||responseStatus==2)
        {
            [MBProgressHUD showError:message toView:kAppWindow];
        }else{
            [MBProgressHUD showError:message toView:kAppWindow];
        }
    }];
}
//认领成功刷新界面
- (void)ClaimSuccessFreshClaimBtn
{
    self.ClaimBtn.layer.borderColor = baseyellowColor.CGColor;
    [self.ClaimBtn setTitleColor:baseyellowColor forState:UIControlStateNormal];
    self.statusImg.hidden = NO;
    
    [self performSelector:@selector(claimSuccess) withObject:nil afterDelay:1.0];
}
//认领 申请成功后保存用户的商户id
- (void)saveShops_id:(NSDictionary*)dicdata
{
    NSString *shopsID = [NSString stringWithFormat:@"%@",dicdata[@"data"][@"shops_id"]];
    [KUserDefaul setObject:shopsID forKey:User_ID];
}
- (void)claimSuccess
{
    self.model.isSelected = YES;
    if(self.claimStoreBlock)
    {
        self.claimStoreBlock(self.model);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
