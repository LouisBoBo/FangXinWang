//
//  RightShopTableViewCell.m
//  FangXinCai
//
//  Created by ios-1 on 2018/1/29.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "RightShopTableViewCell.h"
#import "CartShopManager.h"
@implementation RightShopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
  
    self.shopName.frame = CGRectMake(10, 10, KScreenWidth-100, 20);
    self.shopPrice.frame = CGRectMake(10, 30, KScreenWidth-100, 20);
    self.spaceline.hidden = YES;
    self.bottomline.hidden = NO;
    
    self.inPutTextField.borderStyle = UITextBorderStyleNone;
    self.inPutTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.inPutTextField.delegate = self;
    
    self.backView.layer.cornerRadius = CGRectGetHeight(self.backView.frame)/2;
    self.backView.layer.borderWidth = 1;
    self.backView.layer.borderColor = basegreenColor.CGColor;
    self.backView.hidden = YES;
    
    self.reduceBtn.layer.cornerRadius = CGRectGetHeight(self.backView.frame)/2;
    self.reduceBtn.layer.borderWidth = 1;
    self.reduceBtn.layer.borderColor = basegreenColor.CGColor;
    
    self.addBtn.layer.cornerRadius = CGRectGetHeight(self.backView.frame)/2;
    self.addBtn.layer.borderWidth = 1;
    self.addBtn.layer.borderColor = basegreenColor.CGColor;
    
    //加购物车
    [self.addActiveBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 35)];
    [self.addActiveBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 35, 0, 0)];
    [self.addActiveBtn setImage:[UIImage imageNamed:@"圆加"] forState:UIControlStateNormal];
    
    [self.reduceBtn addTarget:self action:@selector(reduceClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.addBtn addTarget:self action:@selector(addClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.addActiveBtn addTarget:self action:@selector(addActiveClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)refreshData:(GoodsShopData*)data;
{
    self.shopmodel = data;
    self.spec_key = data.spec_key;
    self.goods_id = data.goods_id;
    
    self.shopName.text = [NSString stringWithFormat:@"%@",data.key_name];
    self.shopPrice.text = [NSString stringWithFormat:@"￥%@/%@",data.price,data.goods_unit];
    self.inPutTextField.text = [NSString stringWithFormat:@"%@",data.goods_num];
    
    //加购物车
    [self.addActiveBtn setTitle:@"" forState:UIControlStateNormal];
    self.addActiveBtn.backgroundColor = [UIColor clearColor];
    
    [self.addActiveBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 35)];
    [self.addActiveBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 35, 0, 0)];
    [self.addActiveBtn setImage:[UIImage imageNamed:@"圆加"] forState:UIControlStateNormal];
    
    //加减商品按钮是否隐藏
    if(self.inPutTextField.text.integerValue > 0)
    {
        self.backView.hidden = NO;
        self.addActiveBtn.hidden = YES;
    }else{
        self.backView.hidden = YES;
        self.addActiveBtn.hidden = NO;
    }
}

- (void)refreshTextData:(GoodsShopData*)data;
{
    self.shopmodel = data;
    self.spec_key = data.spec_key;
    self.goods_id = data.goods_id;
    
    self.shopName.text = [NSString stringWithFormat:@"%@",data.goods_name];
    self.shopPrice.text = [NSString stringWithFormat:@"￥%@/%@",data.price,data.goods_unit];
    self.inPutTextField.text = [NSString stringWithFormat:@"%@",data.goods_num];
    
    //加购物车
    [self.addActiveBtn setTitle:@"" forState:UIControlStateNormal];
    self.addActiveBtn.backgroundColor = [UIColor clearColor];
    
    [self.addActiveBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 35)];
    [self.addActiveBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 35, 0, 0)];
    [self.addActiveBtn setImage:[UIImage imageNamed:@"圆加"] forState:UIControlStateNormal];
    
    //加减商品按钮是否隐藏
    if(self.inPutTextField.text.integerValue > 0)
    {
        self.backView.hidden = NO;
        self.addActiveBtn.hidden = YES;
    }else{
        self.backView.hidden = YES;
        self.addActiveBtn.hidden = NO;
    }
}

- (void)refreshSpecData:(GoodsShopInfoModel*)data Speckey:(NSString*)speckey;
{
    self.goods_id = data.goods_id;
    self.spec_key = speckey;
    
    NSString * shopname = [NSString stringWithFormat:@"￥%.2f",data.price.floatValue];
    if(data.goods_unit.length >0)
    {
        shopname = [NSString stringWithFormat:@"￥%.2f/%@",data.price.floatValue,data.goods_unit];
    }
    NSString * shopprice = [NSString stringWithFormat:@"￥%.2f",data.market_price.floatValue];
    
    CGFloat shopnameWidth = [self getRowHeight:shopname fontSize:KZOOM6pt(30)];
    CGFloat shoppriceWidth = [self getRowHeight:shopprice fontSize:KZOOM6pt(30)];
    
    self.shopName.frame = CGRectMake(10, 20, shopnameWidth, 20);
    self.shopName.textColor = [UIColor redColor];
    
    self.shopPrice.frame = CGRectMake(CGRectGetMaxX(self.shopName.frame), 21, shoppriceWidth, 20);
    self.shopPrice.textColor = KGrayColor;
    
    self.spaceline.frame = CGRectMake(CGRectGetMaxX(self.shopName.frame), 29, shoppriceWidth-20, 1);
    self.spaceline.center = self.shopPrice.center;
    self.spaceline.hidden = NO;
    
    self.bottomline.hidden = YES;
    
    self.shopName.text = shopname;
    self.shopPrice.text = shopprice;
    self.inPutTextField.text = [NSString stringWithFormat:@"%@",data.goods_num];
    
    //加购物车
    [self.addActiveBtn setTitle:@"" forState:UIControlStateNormal];
    self.addActiveBtn.backgroundColor = [UIColor clearColor];
    
    [self.addActiveBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 35)];
    [self.addActiveBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 35, 0, 0)];
    [self.addActiveBtn setImage:[UIImage imageNamed:@"圆加"] forState:UIControlStateNormal];
    
    //加减商品按钮是否隐藏
    if(self.inPutTextField.text.integerValue > 0)
    {
        self.backView.hidden = NO;
        self.addActiveBtn.hidden = YES;
    }else{
        self.backView.hidden = YES;
        self.addActiveBtn.hidden = NO;
    }
}
- (void)addActiveClick:(UIButton*)sender
{
    NSString *goods_num = [NSString stringWithFormat:@"%zd",self.inPutTextField.text.integerValue+1];
    [self AddReduiceCartShop:goods_num Add:YES];
}
- (void)reduceClick:(UIButton*)sender
{
    NSString *goods_num = [NSString stringWithFormat:@"%zd",self.inPutTextField.text.integerValue-1];
    [self AddReduiceCartShop:goods_num Add:NO];
}
- (void)addClick:(UIButton*)sender
{
    NSString *goods_num = [NSString stringWithFormat:@"%zd",self.inPutTextField.text.integerValue+1];
    [self AddReduiceCartShop:goods_num Add:YES];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField;
{
    if(textField.text.integerValue == 0)
    {
        textField.text = @"1";
    }else if(textField.text.integerValue >= 1){
        
    }
    
    return YES;
}
#pragma mark 网络请求加入购物车
- (void)AddReduiceCartShop:(NSString*)good_num Add:(BOOL)add
{
    NSString *token = [KUserDefaul objectForKey:User_Token];
    NSMutableDictionary *reqDict = [NSMutableDictionary dictionary];
    [reqDict setValue:token forKey:@"token"];
    [reqDict setValue:self.goods_id forKey:@"goods_id"];
    [reqDict setValue:self.spec_key forKey:@"spec_key"];
    [reqDict setValue:good_num forKey:@"goods_num"];
    
    BaseReqApi *LoginApi=[[BaseReqApi alloc]initWithRequestUrl:@"editCartGoods.json" andrequestTime:5 andParams:reqDict andRequestMethod:YTKRequestMethodPOST andCache:NO andCacheTime:0 andPostToken:NO];
    [MBProgressHUD showMessage:@"加载中..." afterDeleay:10 WithView:kAppWindow];
    [LoginApi StarRequest:^(TBResponseStatus responseStatus, NSString *message, id responseObject) {
        [MBProgressHUD hideHUDForView:kAppWindow];
        
        if (responseStatus==1) {
            
            self.shopmodel.goods_num = good_num;
            self.inPutTextField.text = good_num;
            
            if(good_num.integerValue == 0)
            {
                self.addActiveBtn.hidden = NO;
                self.backView.hidden = YES;
            }else if(good_num.integerValue > 0){
                self.addActiveBtn.hidden = YES;
                self.backView.hidden = NO;
            }
            
            //加购物车成功的回调
            NSString *count = responseObject[@"data"][@"count"];
            [CartShopManager cartShopManarer].cartCount = count.integerValue;
            if(self.addCartBlock)
            {
                self.addCartBlock(responseObject[@"data"],add);
            }
            
        }else if (responseStatus==0||responseStatus==2)
        {
            [MBProgressHUD showError:message toView:kAppWindow];
        }else{
            [MBProgressHUD showError:message toView:kAppWindow];
        }
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

#pragma mark 获取文字宽度
-(CGFloat)getRowHeight:(NSString *)text fontSize:(CGFloat)fontSize
{
    text = [text stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    //文字宽度
    CGFloat width = 60;
    if([[[UIDevice currentDevice]systemVersion] floatValue]>=7.0){
        
        CGRect rect=[text boundingRectWithSize:CGSizeMake(200, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:fontSize] forKey:NSFontAttributeName] context:nil];
        
        width=rect.size.width;
    }
    
    return width+KZOOM6pt(20);
}
@end
