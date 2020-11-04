//
//  MJFriendCell2TableViewCell.m
//  03-QQ好友列表
//
//  Created by ylgwhyh on 16/2/22.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "RightTableViewCell.h"
#import "CartShopManager.h"
@implementation RightTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
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
    
    self.collectBtn.hidden = YES;
    
    [self.reduceBtn addTarget:self action:@selector(reduceClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.addBtn addTarget:self action:@selector(addClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.addactiveBtn addTarget:self action:@selector(addActiveClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.collectBtn addTarget:self action:@selector(collectClick:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)refreshTextData:(GoodsShopData*)data;
{
    self.shopmodel = data;
    self.collectBtn.hidden = NO;
    
    [self.shopImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ReqUrl,data.original_img]] placeholderImage:DefaultImg(self.shopImage.frame.size)];
    self.shopName.text = [NSString stringWithFormat:@"%@",data.goods_name];
    self.shopPrice.text = [NSString stringWithFormat:@"￥%.2f/%@",data.price.floatValue,data.goods_unit];
    self.inPutTextField.text = [NSString stringWithFormat:@"%@",data.goods_num];
    
    //加购物车
    
    [self.addactiveBtn setTitle:@"" forState:UIControlStateNormal];
    self.addactiveBtn.backgroundColor = [UIColor clearColor];
    
    [self.addactiveBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 35)];
    [self.addactiveBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 35, 0, 0)];
    [self.addactiveBtn setImage:[UIImage imageNamed:@"圆加"] forState:UIControlStateNormal];
    
    //加减商品按钮是否隐藏
    if(self.inPutTextField.text.integerValue > 0)
    {
        self.backView.hidden = NO;
        self.addactiveBtn.hidden = YES;
    }else{
        self.backView.hidden = YES;
        self.addactiveBtn.hidden = NO;
    }
}
- (void)refreshData:(GoodsShopData*)data;
{
    self.shopmodel = data;
    
    [self.shopImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ReqUrl,data.goods_img]] placeholderImage:DefaultImg(self.shopImage.frame.size)];
    self.shopName.text = [NSString stringWithFormat:@"%@",data.goods_name];
    self.shopPrice.text = [NSString stringWithFormat:@"￥%@/%@",data.price,data.goods_unit];
    self.inPutTextField.text = [NSString stringWithFormat:@"%@",data.goods_num];
    
    //是选规格还是加购物车
    if(data.moreSpeckey)
    {
        NSString *title = data.selectMoreSpeckey?@"收起":@"选规格";
        [self.addactiveBtn setTitle:title forState:UIControlStateNormal];
//        [self.addactiveBtn setTitle:title forState:UIControlStateSelected];
        
        [self.addactiveBtn setTitleColor:KWhiteColor forState:UIControlStateNormal];
        self.addactiveBtn.titleLabel.font = [UIFont systemFontOfSize:KZOOM6pt(28)];
        self.addactiveBtn.backgroundColor = basegreenColor;
        self.addactiveBtn.layer.cornerRadius = CGRectGetHeight(self.addactiveBtn.frame)/2;
    
        [self.addactiveBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [self.addactiveBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        
        self.backView.hidden = YES;
        self.addactiveBtn.hidden = NO;

    }else{
        
        //加购物车
        
        [self.addactiveBtn setTitle:@"" forState:UIControlStateNormal];
        self.addactiveBtn.backgroundColor = [UIColor clearColor];
        
        [self.addactiveBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 35)];
        [self.addactiveBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 35, 0, 0)];
        [self.addactiveBtn setImage:[UIImage imageNamed:@"圆加"] forState:UIControlStateNormal];
        
        //加减商品按钮是否隐藏
        if(self.inPutTextField.text.integerValue > 0)
        {
            self.backView.hidden = NO;
            self.addactiveBtn.hidden = YES;
        }else{
            self.backView.hidden = YES;
            self.addactiveBtn.hidden = NO;
        }
    }
}

- (void)addActiveClick:(UIButton*)sender
{
    if(self.shopmodel.moreSpeckey)
    {
        self.shopmodel.selectMoreSpeckey = !self.shopmodel.selectMoreSpeckey;
        sender.selected = !sender.selected;
        
        if(self.selectSpecBlock)
        {
            self.selectSpecBlock(self.shopmodel);
        }

    }else{
        NSString *goods_num = [NSString stringWithFormat:@"%zd",self.inPutTextField.text.integerValue+1];
        [self AddReduiceCartShop:goods_num Add:YES];
    }
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
- (void)collectClick:(UIButton*)sender
{
    if(self.collectBlock)
    {
        self.collectBlock(self.shopmodel);
    }
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
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"friend";
    RightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RightTableViewCell" owner:nil options:nil] lastObject];
    }
    
    return cell;
}

- (void)AddReduiceCartShop:(NSString*)good_num Add:(BOOL)add
{
    NSString *token = [KUserDefaul objectForKey:User_Token];
    NSMutableDictionary *reqDict = [NSMutableDictionary dictionary];
    [reqDict setValue:token forKey:@"token"];
    [reqDict setValue:self.shopmodel.goods_id forKey:@"goods_id"];
    [reqDict setValue:self.shopmodel.spec_key forKey:@"spec_key"];
    [reqDict setValue:good_num forKey:@"goods_num"];
    
    BaseReqApi *LoginApi=[[BaseReqApi alloc]initWithRequestUrl:@"editCartGoods.json" andrequestTime:5 andParams:reqDict andRequestMethod:YTKRequestMethodPOST andCache:NO andCacheTime:0 andPostToken:NO];
    [MBProgressHUD showMessage:@"加载中..." afterDeleay:10 WithView:kAppWindow];
    [LoginApi StarRequest:^(TBResponseStatus responseStatus, NSString *message, id responseObject) {
        [MBProgressHUD hideHUDForView:kAppWindow];
        
        if (responseStatus==1) {
        
            if(good_num.integerValue == 0)
            {
                self.addactiveBtn.hidden = NO;
                self.backView.hidden = YES;
            }else if(good_num.integerValue > 0){
                self.addactiveBtn.hidden = YES;
                self.backView.hidden = NO;
            }
            
            self.shopmodel.goods_num = good_num;
            self.inPutTextField.text = self.shopmodel.goods_num;
            
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

@end
