//
//  RightShopTableViewCell.h
//  FangXinCai
//
//  Created by ios-1 on 2018/1/29.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsShopModel.h"
#import "GoodsShopInfoModel.h"
#import "GoodsShopDetailModel.h"

@interface RightShopTableViewCell : UITableViewCell<UITextFieldDelegate,CAAnimationDelegate>
@property (weak, nonatomic) IBOutlet UILabel *spaceline;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UILabel *shopPrice;
@property (weak, nonatomic) IBOutlet UITextField *inPutTextField;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIButton *reduceBtn;
@property (weak, nonatomic) IBOutlet UIButton *addActiveBtn;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *bottomline;

@property (nonatomic , strong) NSString *goods_id;
@property (nonatomic , strong) NSString *spec_key;
@property (nonatomic , strong) GoodsShopData *shopmodel;
@property (nonatomic , strong) void(^addCartBlock)(NSDictionary*data,BOOL add);
- (void)refreshData:(GoodsShopData*)data;
- (void)refreshTextData:(GoodsShopData*)data;
- (void)refreshSpecData:(GoodsShopInfoModel*)data Speckey:(NSString*)speckey;
@end
