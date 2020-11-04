//
//  ShopDetailViewController.m
//  FangXinCai
//
//  Created by ios-1 on 2018/2/3.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "ShopDetailViewController.h"
#import "RightShopTableViewCell.h"
#import "RightTableViewCell.h"
#import "ServiceTableViewCell.h"
#import "BigImageTableViewCell.h"
#import "SpecTableViewCell.h"
#import "CartViewController.h"
#import "HtmlTextViewController.h"

#import "CartViewModel.h"
#import "GoodsShopModel.h"
#import "CartShopManager.h"
#import "BigImageHeadView.h"
#import "GoodsShopDetailModel.h"
#import "GoodsShopInfoModel.h"
#import "UINavigationBar+Helper.h"
#import "PageClassView.h"
#import "GoodsImageModel.h"
static CGFloat NAVBAR_CHANGE_POINT = 50.f;
#define SPECTAGVIEWHEIGH 60
@interface ShopDetailViewController ()<CAAnimationDelegate>
@property (nonatomic , strong) GoodsShopDetailModel *shopDetailModel;
@property (nonatomic , strong) GoodsShopInfoModel *goodsInfoData;
@property (nonatomic , strong) PageClassView *pageclassview;
@property (nonatomic , strong) NSDictionary *cardata;
@property (nonatomic , assign) CGFloat endPoint_x;
@property (nonatomic , assign) CGFloat endPoint_y;
@property (nonatomic , strong) CALayer *dotLayer;
@property (nonatomic , strong) UIBezierPath *path;
@end

@implementation ShopDetailViewController
{
    CGFloat _specTagViewHeigh ;
    UIView *_FootView;             //底部全选视图
    UIButton *allselectbtn;        //全选按钮
    UIButton *markbtn;             //购物数量
    UIButton *_allpaybtn;          //结算
    UIView *_delateBackview;       //底视图
    UIButton *_delateAllbtn;       //删除所有按钮
    UIButton *_addLikebtn;         //加入喜欢按钮
    UILabel *_allmoneylable;
    UILabel *_lable;
    UIButton *_collectbtn;
    UIButton *_delectbtn;
    UILabel *payTimeLabel;
    
    BOOL isfresh;         //是否刷新列表
    BOOL isDragging;      //是否滑动列表
    CGFloat oldOffsetY;   //记录列表上一次滑动的位置
    CGFloat offsetHeigh;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //隐藏导航栏
    self.isHidenNaviBar = YES;
    self.isShowLiftBack = NO;//每个根视图需要设置该属性为NO，否则会出现导航栏异常
    _specTagViewHeigh = 0;
    
    [self creatMainTableview];
    [self creatFootview];
    [self creatHeadview];
    
    [self getgoodsCollectHttp:self.goods_id SpecKey:self.spec_key Keyname:nil];
    
//    [self creatData];
}

//测试用
- (void)creatData
{
    NSString *newss = [KUserDefaul objectForKey:@"detail"];
    NSData * getJsonData = [newss dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * getDict = [NSJSONSerialization JSONObjectWithData:getJsonData options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"getDict == %@",getDict);
    
    [self handleData:getDict];
}
#pragma mark **************** 网络请求 ****************
- (void)getgoodsCollectHttp:(NSString*)goodsid SpecKey:(NSString*)speckey Keyname:(NSString*)keyname
{
    NSString *token = [KUserDefaul objectForKey:User_Token];
    NSMutableDictionary *reqDict = [NSMutableDictionary dictionary];
    [reqDict setValue:token forKey:@"token"];
    [reqDict setValue:goodsid forKey:@"goods_id"];
    [reqDict setValue:speckey forKey:@"spec_key"];
    
    BaseReqApi *LoginApi=[[BaseReqApi alloc]initWithRequestUrl:@"goodsDetail.json" andrequestTime:5 andParams:reqDict andRequestMethod:YTKRequestMethodPOST andCache:NO andCacheTime:0 andPostToken:NO];
    [MBProgressHUD showMessage:@"加载中..." afterDeleay:10 WithView:self.view];
    [LoginApi StarRequest:^(TBResponseStatus responseStatus, NSString *message, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view];
        
        if (responseStatus==1) {
    
            [self.serviceArr removeAllObjects];
            [self.bigImageArr removeAllObjects];
            
            [self handleData:responseObject];
            
//            NSString *sstt = [HelpWay dictionaryToJSON:responseObject];
//            NSLog(@"sstt == %@",sstt);
//            [KUserDefaul setObject:sstt forKey:@"detail"];

//
//            if(keyname.length > 0)
//            {
//                self.tagsView.selectTitle = keyname;
//                [self.tagsView reloadData];
//            }
            
        }else if (responseStatus==0||responseStatus==2)
        {
            [MBProgressHUD showError:message toView:kAppWindow];
        }else{
            [MBProgressHUD showError:message toView:kAppWindow];
            kWeakSelf(self);
            [self loginSuccess:^{
                [weakself getgoodsCollectHttp:self.goods_id SpecKey:self.spec_key Keyname:nil];
            }];
        }
    }];
}

- (void)handleData:(NSDictionary*)dic
{
    self.shopDetailModel = [GoodsShopDetailModel mj_objectWithKeyValues:dic];
    NSDictionary *infodic = dic[@"data"][@"goods_info"];
    self.goodsInfoData = [GoodsShopInfoModel mj_objectWithKeyValues:infodic];
    NSLog(@"shopDetailModel = %@",self.shopDetailModel);
    
    //详情分类
    self.sectionTitleArray = @[@"选择规格",@"服务保障",@"详细信息",@"商品属性"];
    
    //商品大图
    NSMutableArray *imagesUrl = [NSMutableArray array];
    NSArray *arr = self.shopDetailModel.data.goods_image;
    for(int i= 0;i<arr.count ; i++)
    {
        NSDictionary *imagedata = arr[i];
        NSString *imageurl = [NSString stringWithFormat:@"%@%@",ReqUrl,imagedata[@"image_url"]];
        [imagesUrl addObject:imageurl];
    }
    
    //商品细节图
    NSMutableString *goods_content = [NSMutableString stringWithFormat:@"%@",self.goodsInfoData.goods_content];
    NSArray *contentArr = [goods_content componentsSeparatedByString:@"<p><img src="];
    for(NSString *sstt in contentArr)
    {
        if(sstt.length >10)
        {
            NSMutableString *str = [NSMutableString stringWithFormat:@"%@",sstt];
            NSArray *strArr = [str componentsSeparatedByString:@" title="];
            if(strArr.count)
            {
                NSString *stst = strArr[0];
                NSString *newstr = [stst substringWithRange:NSMakeRange(1, stst.length-2)];
                GoodsImageModel *imageModel = [GoodsImageModel new];
                imageModel.imageStr = newstr;
                [self.bigImageArr addObject:imageModel];
            }
        }
    }
    
    //服务保障
    NSDictionary *serviceDic = self.shopDetailModel.data.goods_service;
    if(serviceDic !=nil)
    {
        NSArray *psfwArr = serviceDic[@"psfw"];
        NSArray *shfwArr = serviceDic[@"shfw"];
        NSArray *xdtjArr = serviceDic[@"xdtj"];
        NSArray *zffsArr = serviceDic[@"zffs"];
        
        NSArray *headimages = @[@"待发货",@"待发货",@"待发货",@"待发货"];
        NSArray *titleArr = @[@"配送服务",@"售后服务",@"下单条件",@"支付方式"];
        NSMutableArray *allService = [NSMutableArray array];
        if(psfwArr != nil)
        {
            [allService addObject:psfwArr];
        }
        if(shfwArr != nil)
        {
            [allService addObject:shfwArr];
        }
        if(xdtjArr != nil)
        {
            [allService addObject:xdtjArr];
        }
        if(zffsArr != nil)
        {
            [allService addObject:zffsArr];
        }
        
        for(int j =0; j<allService.count; j++)
        {
            NSArray *serviceArr = allService[j];
            
            GoodsserviceData *model = [GoodsserviceData new];
            model.headImage = headimages[j];
            model.title = titleArr[j];
            NSMutableArray *values = [NSMutableArray array];
            for(int i =0; i <serviceArr.count; i++)
            {
                [values addObject:[NSString stringWithFormat:@"%@",serviceArr[i][@"value"]]];
            }
            model.value = [values componentsJoinedByString:@"\n"];
            
            [self.serviceArr addObject:model];
        }
    }
    
    
    //刷新轮播图
    [self.tabHeadView refreshBanaImages:imagesUrl GoodsInfo:self.goodsInfoData];
    
    //选择规格视图的高度
    if(self.shopDetailModel.data.goods_spec.count >0)
    {
        //标签高度
        
        NSMutableArray *tagsArray = [NSMutableArray array];
        [tagsArray addObjectsFromArray:self.shopDetailModel.data.goods_spec];
        
        NSArray *titles = [self gettitleArray:tagsArray];
    
        CGFloat tagsHeight = 0;
        if(titles.count)
        {
            tagsHeight = [HXTagsView getHeightWithTags:titles layout:nil tagAttribute:nil width:kScreenWidth];
        }
        CGFloat tagviewH   = tagsHeight + (self.shopDetailModel.data.goods_spec.count >0?10:0);
        
        _specTagViewHeigh = tagviewH>60?(tagviewH+20):60;
    }
    
    //刷新规格视图
    [self refreshSpecTagView];
    
    //刷新列表
    [self.tableView reloadData];
    
    //刷新脚底视图
    [self freshFootView:self.shopDetailModel.data.goods_cart];
    
    //创建分类条
    [self setPageClassView:self.sectionTitleArray];
}
#pragma mark **************** 导航条  ****************
-(void)creatHeadview
{
    //导航条
    UIImageView *headview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 64)];
    headview.backgroundColor = KWhiteColor;
    headview.alpha = 0;
    [self.view addSubview:self.headNavView = headview];
    headview.userInteractionEnabled=YES;
    
    UIButton *backbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backbtn.frame=CGRectMake(-10, 20, 80, 44);
    [backbtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [backbtn setImage:[UIImage imageNamed:@"返回按钮"] forState:UIControlStateNormal];
    [self.view addSubview:backbtn];
    
    UILabel* titlelable =[[UILabel alloc]init];
    titlelable.frame=CGRectMake(0, 0, 300, 40);
    titlelable.center=CGPointMake(KScreenWidth/2, headview.frame.size.height/2+10);
    titlelable.text=@"商品详情";
    titlelable.alpha = 0;
    titlelable.font = HBFont16;
    titlelable.textColor= CNavBgFontColor;
    titlelable.textAlignment=NSTextAlignmentCenter;
    [headview addSubview:self.titlelable = titlelable];
    
    UIButton *editbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [editbtn setTitle:@"编辑" forState:UIControlStateNormal];
    [editbtn setTitleColor:KGrayColor forState:UIControlStateNormal];
    editbtn.titleLabel.font = [UIFont systemFontOfSize:KZOOM6pt(30)];
    [editbtn addTarget:self action:@selector(editClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:editbtn];

    [editbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(25);
        make.left.mas_equalTo(KScreenWidth - 45);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
    }];
    

}
- (void)editClick:(UIButton*)sender
{
    NSLog(@"编辑");
}
- (void)back:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark **************** 分类条  ****************
- (void)setPageClassView:(NSArray*)titleArr
{
    PageClassView *pageclassview = [[PageClassView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, 40) TitleArr:titleArr];
    pageclassview.alpha = 0;

    pageclassview.selectBlock = ^(NSInteger index) {
        
        if(index == 1 && self.serviceArr.count == 0)
        {
            return;
        }
        else if(index == 2 && self.bigImageArr.count == 0)
        {
            return;
        }else if (index == 3 && self.shopDetailModel.data.goods_attr.count == 0)
        {
            return;
        }
        
        isDragging = NO;
        NSIndexPath * dayOne = [NSIndexPath indexPathForRow:0 inSection:index];
        if(dayOne)
        {
            self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
            [self.tableView scrollToRowAtIndexPath:dayOne atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    };
    [self.view addSubview:self.pageclassview = pageclassview];
}

#pragma mark **************** 规格标签 ****************
- (void)refreshSpecTagView
{
    NSMutableArray *tagsArray = [NSMutableArray array];
    [tagsArray addObjectsFromArray:self.shopDetailModel.data.goods_spec];
    
    self.tagsView.tags = [self gettitleArray:tagsArray];
    if(self.tagsView.tags.count)
    {
        self.tagsView.height = [HXTagsView getHeightWithTags:self.tagsView.tags layout:self.tagsView.layout tagAttribute:self.tagsView.tagAttribute width:kScreenWidth];
        [self.tagsView reloadData];
    }
}

- (NSArray *)gettitleArray:(NSArray*)tagsArray
{
    NSMutableArray *tagstitleArray = [NSMutableArray array];
    
    for(int i =0 ;i<tagsArray.count;i++)
    {
        GoodsspecData *specData = tagsArray[i];
        if([specData.selected boolValue]==YES)
        {
            self.tagsView.selectTitle = specData.key_name;
        }
        [tagstitleArray addObject:specData.key_name];
    }
    
    return tagstitleArray;
}

#pragma mark **************** 购物车 ****************
-(void)creatFootview
{
    _FootView=[[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight-50, KScreenWidth, 50)];
    _FootView.tag=7272;
    [self.view addSubview:_FootView];
    
    UILabel *linelable=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 0.5)];
    linelable.backgroundColor=RGBCOLOR(197, 197, 197);
    [_FootView addSubview:linelable];
    
    //购物车数量
    allselectbtn=[[UIButton alloc]init];
    allselectbtn.frame=CGRectMake(10,-10,50, 50);
    allselectbtn.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [allselectbtn setImage:[UIImage imageNamed:@"购物车"] forState:UIControlStateNormal];
    allselectbtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    allselectbtn.layer.cornerRadius = 25;
    allselectbtn.layer.shadowOffset = CGSizeMake(10, 10);
    allselectbtn.layer.shadowOpacity = 0.7;
    allselectbtn.clipsToBounds=YES;
    allselectbtn.tag=9999;
    allselectbtn.layer.borderColor=KGrayColor.CGColor;
    [allselectbtn addTarget:self action:@selector(cartClick:) forControlEvents:UIControlEventTouchUpInside];
    [_FootView addSubview:allselectbtn];
    
    markbtn=[[UIButton alloc]init];
    markbtn.frame=CGRectMake(45,-10,20, 20);
    markbtn.backgroundColor = [UIColor redColor];
    markbtn.layer.cornerRadius = 10;
    markbtn.clipsToBounds=YES;
    markbtn.hidden = YES;
    markbtn.titleLabel.font = HBFont10;
    [markbtn setTitleColor:KWhiteColor forState:UIControlStateNormal];
    markbtn.layer.borderColor=KGrayColor.CGColor;
    [_FootView addSubview:markbtn];
    
    //去购物车
    _allpaybtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    _allpaybtn.frame=CGRectMake(kScreenWidth-KZOOM6pt(200), 0.5, KZOOM6pt(200), _FootView.frame.size.height-1);;
    _allpaybtn.backgroundColor = RGBCOLOR(197, 197, 197);
    _allpaybtn.titleLabel.font = [UIFont systemFontOfSize:KZOOM6pt(46)];
    [_allpaybtn addTarget:self action:@selector(cartClick:) forControlEvents:UIControlEventTouchUpInside];
    [_FootView addSubview:_allpaybtn];
    
    payTimeLabel=[[UILabel alloc]initWithFrame:_allpaybtn.frame];
    payTimeLabel.attributedText=[[NSAttributedString alloc]initWithString:@"去购物车"];
    payTimeLabel.textAlignment=NSTextAlignmentCenter;
    payTimeLabel.numberOfLines=0;
    payTimeLabel.textColor=[UIColor whiteColor];
    payTimeLabel.backgroundColor=[UIColor clearColor];
    [_FootView addSubview:payTimeLabel];
    
    _allmoneylable=[[UILabel alloc]initWithFrame:CGRectMake(KZOOM6pt(140), CGRectGetMidY(_allpaybtn.frame)-20+KZOOM6pt(5), kScreenWidth-KZOOM6pt(360), 20)];
    _allmoneylable.text=[NSString stringWithFormat:@"合计:￥0.0"];
    _allmoneylable.font=[UIFont systemFontOfSize:KZOOM6pt(28)];
    _allmoneylable.textColor=basegreenColor;
    _allmoneylable.textAlignment=NSTextAlignmentRight;
    [_FootView addSubview:_allmoneylable];
    
    _lable=[[UILabel alloc]initWithFrame:CGRectMake(_allmoneylable.frame.origin.x, CGRectGetMidY(_allpaybtn.frame)-KZOOM6pt(5), _allmoneylable.frame.size.width, 20)];
    _lable.text= [NSString stringWithFormat:@"运费:￥%.2f",0.0];
    _lable.textColor=RGBCOLOR(168, 168, 168);
    _lable.font=[UIFont systemFontOfSize:KZOOM6pt(24)];
    _lable.textAlignment=NSTextAlignmentRight;
    [_FootView addSubview:_lable];
}

- (void)freshFootView:(NSDictionary*)dic
{
    NSString *totalprice = [NSString stringWithFormat:@"%@",dic[@"order_total_price"]];
    NSString *shipping_fee = [NSString stringWithFormat:@"%@",dic[@"shipping_fee"]];
    NSString *count = [NSString stringWithFormat:@"%@",dic[@"count"]];
    count = count.intValue >99?@"99+":count;
    [markbtn setTitle:count forState:UIControlStateNormal];
    _allmoneylable.text=[NSString stringWithFormat:@"合计:%.2f",totalprice.floatValue];
    _lable.text=[NSString stringWithFormat:@"运费:%.2f",shipping_fee.floatValue];
    
    if(count.integerValue > 0)
    {
        markbtn.hidden = NO;
        _allpaybtn.backgroundColor= basegreenColor;
    }else{
        markbtn.hidden = YES;
        _allpaybtn.backgroundColor = RGBCOLOR(197, 197, 197);
    }
}

#pragma mark -加入购物车动画
-(void)joinCartAnimationWithRect:(CGRect)rect
{
    _endPoint_x = 40;
    _endPoint_y = KScreenHeight - 50;
    
    CGFloat startX = rect.origin.x;
    CGFloat startY = rect.origin.y;
    
    _path= [UIBezierPath bezierPath];
    [_path moveToPoint:CGPointMake(startX, startY)];
    
    //三点曲线
    [_path addCurveToPoint:CGPointMake(_endPoint_x, _endPoint_y)
             controlPoint1:CGPointMake(startX, startY)
             controlPoint2:CGPointMake(startX - 180, startY - 200)];
    _dotLayer = [CALayer layer];
    _dotLayer.backgroundColor = [UIColor redColor].CGColor;
    _dotLayer.frame = CGRectMake(0, 0, 20, 20);
    _dotLayer.cornerRadius = 10;
    [self.view.layer addSublayer:_dotLayer];
    [self groupAnimation];
    
}
#pragma mark - 组合动画
-(void)groupAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = _path.CGPath;
    animation.rotationMode = kCAAnimationRotateAuto;
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"alpha"];
    alphaAnimation.duration = 0.5f;
    alphaAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    alphaAnimation.toValue = [NSNumber numberWithFloat:0.1];
    alphaAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup *groups = [CAAnimationGroup animation];
    groups.animations = @[animation,alphaAnimation];
    groups.duration = 0.8f;
    groups.removedOnCompletion = NO;
    groups.fillMode = kCAFillModeForwards;
    groups.delegate = self;
    [groups setValue:@"groupsAnimation" forKey:@"animationName"];
    [_dotLayer addAnimation:groups forKey:nil];
    [self performSelector:@selector(removeFromLayer:) withObject:_dotLayer afterDelay:0.75f];
}
- (void)removeFromLayer:(CALayer *)layerAnimation{
    
    [layerAnimation removeFromSuperlayer];
}
#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if ([[anim valueForKey:@"animationName"]isEqualToString:@"groupsAnimation"]) {
        
        CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        shakeAnimation.duration = 0.25f;
        shakeAnimation.fromValue = [NSNumber numberWithFloat:0.9];
        shakeAnimation.toValue = [NSNumber numberWithFloat:1];
        shakeAnimation.autoreverses = YES;
        
        [markbtn.layer addAnimation:shakeAnimation forKey:nil];
        [self freshFootView:self.cardata];
    }
}
- (void)cartClick:(UIButton*)sender
{
    NSLog(@"去购物车");
    CartViewController *cart = [[CartViewController alloc]init];
    cart.ShopCart_Type = ShopCart_NormalType;
    cart.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:cart animated:YES];
}
#pragma mark **************** 数据列表 ****************
- (void)creatMainTableview
{
    self.tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight-50);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.mj_header.hidden = YES;
    self.tableView.mj_footer.hidden = YES;
    
    self.tableView.tableHeaderView = self.tabHeadView;

    [self.tableView registerNib:[UINib nibWithNibName:@"ServiceTableViewCell" bundle:nil] forCellReuseIdentifier:@"ServiceCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BigImageTableViewCell" bundle:nil] forCellReuseIdentifier:@"ImageCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SpecTableViewCell" bundle:nil] forCellReuseIdentifier:@"SpecCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RightShopTableViewCell" bundle:nil] forCellReuseIdentifier:@"RightShopCell"];
    
    self.tableView.estimatedRowHeight = 60;
    [self.view addSubview:self.tableView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return self.goodsInfoData!=nil?40:0;
    }
    else if(section == 1)
    {
        return self.serviceArr.count>0?40:0;
    }
    else if(section == 2)
    {
        return self.bigImageArr.count>0?40:0;
    }else if (section == 3)
    {
        return self.shopDetailModel.data.goods_attr.count>0?40:0;
    }
    return 0;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
    headview.backgroundColor = RGBCOLOR(250, 250, 250);
    
    UIView *baseview = [[UIView alloc]initWithFrame:CGRectMake(0, 10, KScreenWidth, 30)];
    baseview.backgroundColor = KWhiteColor;
    [headview addSubview:baseview];
    
    UILabel *headlab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, KScreenWidth-20, 30)];
    if(section > 1)
    {
        headlab.textAlignment = NSTextAlignmentCenter;
    }else{
        headlab.textAlignment = NSTextAlignmentLeft;
    }
    
    headlab.font = HBFont14;
    headlab.textColor = KGrayColor;
    headlab.text = self.sectionTitleArray[section];
    [baseview addSubview:headlab];
    
    return headview;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if(section == 0)
    {
        return self.goodsInfoData != nil?2:0;
    }
    else if(section == 1)
    {
        return self.serviceArr.count;
    }
    else if(section == 2)
    {
        return self.bigImageArr.count;
    }else if (section == 3)
    {
        return self.shopDetailModel.data.goods_attr.count;
    }
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            return self.goodsInfoData!=nil?_specTagViewHeigh:0;
        }else
            return self.goodsInfoData!=nil?60:0;
    }else{
        return UITableViewAutomaticDimension;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{

    if(indexPath.section == 0)
    {
        // 1.创建cell
        RightShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RightShopCell"];
        if(cell == nil)
        {
            cell = [[RightShopTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"RightShopCell"];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        if(indexPath.row == 0)
        {
            cell.backView.hidden = YES;
            cell.addActiveBtn.hidden = YES;
            [cell.contentView addSubview:self.tagsView];
        }else{
            cell.backView.hidden = NO;
            cell.addActiveBtn.hidden = NO;
            [cell refreshSpecData:self.goodsInfoData Speckey:self.spec_key];
            kWeakSelf(self);
            kWeakSelf(cell);
            
            cell.addCartBlock = ^(NSDictionary *data, BOOL add) {
                weakself.cardata = data;
                if(add)
                {
                    CGRect parentRect = [weakcell convertRect:weakcell.addActiveBtn.frame toView:weakself.view];
                    // 这里是动画开始的方法
                    [weakself joinCartAnimationWithRect:parentRect];
                    [self changeTabbarCartNum];
                }else{
                    [weakself freshFootView:self.cardata];
                    [self changeTabbarCartNum];
                }
            };
        }
        
        return cell;
    }
    else if(indexPath.section == 1)
    {
        ServiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ServiceCell"];
        if(cell == nil)
        {
            cell = [[ServiceTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ServiceCell"];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        GoodsserviceData *serviceData = self.serviceArr[indexPath.row];
        [cell refreshData:serviceData];
        return cell;
    }
    else if(indexPath.section == 2)
    {
        BigImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImageCell"];
        if(cell == nil)
        {
            cell = [[BigImageTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ImageCell"];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        GoodsImageModel *imageModel = self.bigImageArr[indexPath.row];
        [cell refreshData:imageModel];
        return cell;
    }
    else if(indexPath.section == 3)
    {
        SpecTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SpecCell"];
        if(cell == nil)
        {
            cell = [[SpecTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"SpecCell"];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        GoodsattrData *attrdata = self.shopDetailModel.data.goods_attr[indexPath.row];
        [cell refreshData:attrdata];
        return cell;
    }
    return 0;
}

#pragma mark 滑动改变当前的title
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    NSLog(@"*********section=%zd",section);
    if(isDragging && !isfresh && self.sectionTitleArray.count == section+1)
    {
        self.selectHeadIndex = section;
        [self.pageclassview setTitle:self.selectHeadIndex];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath NS_AVAILABLE_IOS(6_0);
{
    NSLog(@"*********4444444section=%zd",indexPath.section);
    if(isDragging && !isfresh)
    {
        if (self.tableView.contentOffset.y > oldOffsetY) {
            // 上滑
            self.selectHeadIndex = indexPath.section+1;
            
            [self.pageclassview setTitle:self.selectHeadIndex];
        }
        else{
            // 下滑
            self.selectHeadIndex = indexPath.section-1;
            
            [self.pageclassview setTitle:self.selectHeadIndex];
        }
    }
}
- (void)scrollViewDidChangeAdjustedContentInset:(UIScrollView *)scrollView
{
    isfresh = NO;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    isDragging = YES;
    
    // 获取开始拖拽时tableview偏移量
    oldOffsetY = self.tableView.contentOffset.y;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
//uitableview处理section的不悬浮，禁止section停留的方法，主要是这段代码
//    CGFloat sectionHeaderHeight = -100;
//if(scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
//        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
//        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//    }
    if(isDragging)
    {
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    //改变导航栏背景色
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_CHANGE_POINT) {
        CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
       
        self.titlelable.alpha = alpha;
        self.headNavView.alpha = alpha;
        self.pageclassview.alpha = alpha;
        
    } else {
        
        self.titlelable.alpha = 0;
        self.headNavView.alpha = 0;
        self.pageclassview.alpha = 0;
        
        self.selectHeadIndex = 0;
        [self.pageclassview setTitle:self.selectHeadIndex];
    }
}
#pragma mark 清除单个商品
- (void)deleteShopCat:(NSIndexPath*)indexPath
{
    ShopCartModel *model = self.dataArray[0];
    NSMutableArray *dataArray = [NSMutableArray arrayWithArray:model.list];
    
    [dataArray removeObjectAtIndex:indexPath.row];
    
    model.list = dataArray;
    if(model.list.count == 0)
    {
        [self.dataArray removeObjectAtIndex:0];
    }else{
        [self.dataArray replaceObjectAtIndex:0 withObject:model];
    }
    
    [self.tableView reloadData];
}

#pragma mark 获取文字高度
-(CGFloat)getRowHeight:(NSString *)text fontSize:(CGFloat)fontSize
{
    text = [text stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    //文字高度
    CGFloat height = 30;
    if([[[UIDevice currentDevice]systemVersion] floatValue]>=7.0){
        
        CGRect rect=[text boundingRectWithSize:CGSizeMake(self.tableView.frame.size.width-100, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:fontSize] forKey:NSFontAttributeName] context:nil];
        
        height=rect.size.height<30?30:rect.size.height;
    }
    
    return height+KZOOM6pt(20);
}
- (BigImageHeadView*)tabHeadView
{
    if(_tabHeadView == nil)
    {
        _tabHeadView = [[BigImageHeadView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KZOOM6pt(600)) Goodsid:self.goods_id];
    }
    return _tabHeadView;
}
- (SpecTagHeadView*)speckHeadView
{
    if(_speckHeadView == nil)
    {
        _speckHeadView = [[SpecTagHeadView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, _specTagViewHeigh)];
        kWeakSelf(self);
        _speckHeadView.selectBlock = ^(GoodsspecData *model) {
            weakself.spec_key = model.spec_key;
            weakself.goods_id = model.goods_id;
            [weakself getgoodsCollectHttp:model.goods_id SpecKey:model.spec_key Keyname:nil];
        };
    }
    
    return _speckHeadView;
}

- (HXTagsView*)tagsView
{
    if(_tagsView == nil)
    {
        _tagsView = [[HXTagsView alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth-20, _specTagViewHeigh)];
        _tagsView.backgroundColor = basegreenColor;
        _tagsView.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        kWeakSelf(self);
        _tagsView.completion = ^(NSArray *selectTags,NSInteger currentIndex) {
            NSLog(@"selectTags:%@ currentIndex:%ld",selectTags, (long)currentIndex);
            GoodsspecData *model = weakself.shopDetailModel.data.goods_spec[currentIndex];
            weakself.spec_key = model.spec_key;
            weakself.goods_id = model.goods_id;
            [weakself getgoodsCollectHttp:model.goods_id SpecKey:model.spec_key Keyname:model.key_name];
        };
    }
    return _tagsView;
}
- (NSMutableArray*)dataArray
{
    if(_dataArray == nil)
    {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray*)allDataArr
{
    if(_allDataArr == nil)
    {
        _allDataArr = [NSMutableArray array];
    }
    return _allDataArr;
}
- (NSMutableArray*)serviceArr
{
    if(_serviceArr == nil)
    {
        _serviceArr = [NSMutableArray array];
    }
    return _serviceArr;
}
- (NSMutableArray*)bigImageArr
{
    if(_bigImageArr == nil)
    {
        _bigImageArr = [NSMutableArray array];
    }
    return _bigImageArr;
}
- (NSMutableArray*)headArray
{
    if(_headArray == nil)
    {
        _headArray = [NSMutableArray array];
    }
    return _headArray;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
