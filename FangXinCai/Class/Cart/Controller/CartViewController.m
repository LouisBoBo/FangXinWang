//
//  CartViewController.m
//  FangXinCai
//
//  Created by ios-1 on 2018/1/8.
//  Copyright © 2018年 ios-1. All rights reserved.
//

#import "CartViewController.h"
#import "CartShopTableViewCell.h"
#import "JoinShopTableViewCell.h"
#import "CartTableFootViewCell.h"
#import "CartNavgationView.h"
#import "CartViewModel.h"
#import "CartCountModel.h"
#import "CartShopManager.h"
#import "ConfirmOrderViewController.h"
@interface CartViewController ()
@property (nonatomic , strong) CartCountModel *countModel;
@property (nonatomic , assign) NSInteger currentPage;
@end

@implementation CartViewController
{
    UIView *_FootView;             //底部全选视图
    UIButton *allselectbtn;        //全选按钮
    UIButton *_allpaybtn;          //结算
    UIView *_delateBackview;       //底视图
    UIButton *_delateAllbtn;       //删除所有按钮
    UIButton *_addLikebtn;         //加入喜欢按钮
    UILabel *_allmoneylable;
    UILabel *_lable;
    UIButton *_collectbtn;
    UIButton *_delectbtn;
    UILabel *payTimeLabel;
    
    CGFloat _shopTotalPrice;       //所选商品总价
    NSInteger _selectShopCount;    //所选商品计数
    BOOL _isAllShopSelect;         //是否全部勾选
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isShowLiftBack = NO;//每个根视图需要设置为NO，否则会出现导航栏异常
    self.isHidenNaviBar = YES;//隐藏导航栏
    _isAllShopSelect = NO;//全部选中默认为NO
    self.currentPage = 1;
    self.isJoin = YES;//测试用
    
    [self creatNavagationView];
    [self creatMainTableview];
    [self creatFootview];
    
//    [self creatData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tabDataArr removeAllObjects];
    [self getCartDataHttp];
}
- (void)viewDidAppear:(BOOL)animated
{
    //刷新tabbar上购物车数量
    [CartShopManager cartShopManarer].cartCount = 0;
    [self changeTabbarCartNum];
}
//测试用
- (void)creatData
{
    NSString *newss = [KUserDefaul objectForKey:@"sstt"];
    NSData * getJsonData = [newss dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * getDict = [NSJSONSerialization JSONObjectWithData:getJsonData options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"getDict == %@",getDict);
    
    CartViewModel *model = [CartViewModel mj_objectWithKeyValues:getDict];
     NSLog(@"model == %@",model);
    [self.tabDataArr addObjectsFromArray:model.data];
    
    [self.tableView reloadData];
}
- (void)creatNavagationView
{
    self.navigationItem.rightBarButtonItems = nil;
    CartNavgationView *naview = [[CartNavgationView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 64)];
    
    [self.view addSubview:naview];
    
    naview.customerBlock = ^{

    };

    naview.editBlock = ^(BOOL edit) {
        NSString *latstr = edit?@"删除":@"结算";
        
        if(self.selectShopArr.count >0)
        {
            payTimeLabel.attributedText= [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@(%zd)",latstr,self.selectShopArr.count]];
        }else{
            payTimeLabel.attributedText= [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",latstr]];
        }
    
        _allmoneylable.hidden = edit;
        _lable.hidden = edit;
    };
}
- (void)creatMainTableview
{
    CGFloat Heigh = self.ShopCart_Type==ShopCart_TarbarType?49:0;
    self.tableView.frame = CGRectMake(0, 64, KScreenWidth, KScreenHeight-64-Heigh-50);
    self.tableviewstyle = UITableViewStyleGrouped;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.mj_footer.hidden = YES;
    
    [self configureNeedShowEmptyDataSetScrollView:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CartShopTableViewCell" bundle:nil] forCellReuseIdentifier:@"CartShopCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"JoinShopTableViewCell" bundle:nil] forCellReuseIdentifier:@"JoinShopCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CartTableFootViewCell" bundle:nil] forCellReuseIdentifier:@"FootCell"];
    
    [self.view addSubview:self.tableView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.tabDataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    ShopCartModel *model = self.tabDataArr[section];
    return model.list.count?30:0;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ShopCartModel *model = self.tabDataArr[section];
    
    UIView *headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
    headview.backgroundColor = RGBCOLOR(250, 250, 250);
    
    UILabel *headlab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 30)];
    headlab.font = [UIFont systemFontOfSize:KZOOM6pt(28)];
    headlab.textColor = KGrayColor;
    headlab.text = model.cat_name;
    
    UILabel *infolab = [[UILabel alloc]initWithFrame:CGRectMake(200, 0, KScreenWidth-200-10, 30)];
    infolab.font = [UIFont systemFontOfSize:KZOOM6pt(24)];
    infolab.textAlignment = NSTextAlignmentRight;
    infolab.textColor = KGrayColor;
    infolab.tag = 10000 +section;
    infolab.text = [NSString stringWithFormat:@"共%zd件商品  小计:￥%.2f",0,0.0];
    
    if(self.sectionSelectArr.count)
    {
        NSMutableDictionary *dic = self.sectionSelectArr[section];
        NSString* sectiontotalPrice = [dic objectForKey:@"sectiontotalPrice"];
        NSString* sectiontotalCount = [dic objectForKey:@"sectiontotalCount"];
        
        infolab.text = [NSString stringWithFormat:@"共%zd件商品  小计:￥%.2f",sectiontotalCount.integerValue ,sectiontotalPrice.floatValue];
    }
    
    [headview addSubview:headlab];
    [headview addSubview:infolab];
    return headview;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ShopCartModel *model = self.tabDataArr[section];
    
    if(self.isJoin && model.list.count)
    {
        return model.list.count+1+1;
    }else{
        return model.list.count+1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShopCartModel *model = self.tabDataArr[indexPath.section];
    
    if(self.isJoin)
    {
        if(indexPath.row == 0)
        {
            return 30;
        }else if (indexPath.row == model.list.count+1)
        {
            return 10;
        }
    }else{
        if(indexPath.row == model.list.count)
        {
            return 10;
        }
    }
//    if(self.isJoin && indexPath.row == 0)
//    {
//        return 30;
//    }else if (indexPath.row == model.list.count)
//    {
//        return 10;
//    }
     return 80;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShopCartModel *model = self.tabDataArr[indexPath.section];
    if(self.isJoin)
    {
        if(indexPath.row == 0)
        {
            JoinShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JoinShopCell"];
            if(!cell)
            {
                cell = [[JoinShopTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"JoinShopCell"];
            }
            
            return cell;
        }else if (indexPath.row == model.list.count+1){
            CartTableFootViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FootCell"];
            if(!cell)
            {
                cell = [[CartTableFootViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"FootCell"];
            }
            return cell;
        }
        else{
            CartShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CartShopCell"];
            if(!cell)
            {
                cell = [[CartShopTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CartShopCell"];
            }
            
            NSArray *dataArray = model.list;
            
            ShopCartData *cartmodel = dataArray[indexPath.row-1];
            [cell refreshData:cartmodel];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            kWeakSelf(self);
            
            cell.selectBlock = ^(ShopCartData *model, CartCountModel *countmodel) {
                weakself.countModel = countmodel;
                [weakself freshTableview];
            };
            cell.deleteBlock = ^(ShopCartData *model) {
                
                [weakself deleteShopCat:indexPath];
            };
           
            cell.reduceAndAddBlock = ^(ShopCartData *model, CartCountModel *countmodel) {
                weakself.countModel = countmodel;
                
                [weakself freshTableview];
            };
            return cell;
        }
       
    }else{
        if (indexPath.row == model.list.count){
            CartTableFootViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FootCell"];
            if(!cell)
            {
                cell = [[CartTableFootViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"FootCell"];
            }
            return cell;
        }else{
            CartShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CartShopCell"];
            if(!cell)
            {
                cell = [[CartShopTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CartShopCell"];
            }
            
            NSArray *dataArray = model.list;
            
            ShopCartData *cartmodel = dataArray[indexPath.row];
            [cell refreshData:cartmodel];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            kWeakSelf(self);
            
            cell.selectBlock = ^(ShopCartData *model, CartCountModel *countmodel) {
                weakself.countModel = countmodel;
                [weakself freshTableview];
            };
            
            cell.deleteBlock = ^(ShopCartData *model) {
                [weakself deleteShopCat:indexPath];
            };
            
            cell.reduceAndAddBlock = ^(ShopCartData *model, CartCountModel *countmodel) {
                weakself.countModel = countmodel;
                [weakself freshTableview];
            };
            return cell;
        }
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.isJoin && indexPath.row==0)
    {
        return UITableViewCellEditingStyleNone;
    }
        return UITableViewCellEditingStyleDelete;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //uitableview处理section的不悬浮，禁止section停留的方法，主要是这段代码
    CGFloat sectionHeaderHeight = 40;
    if(scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}
//删除商品时提示弹框
- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self creatAltViewTitle:@"温馨提示" Message:@"是否要删除此商品" Sure:@"确定" Cancle:@"取消" SureBlock:^(id data) {
            [self deleteShopCat:indexPath];
        } CaccleBlock:^(id data) {
            
        }];
    }
}

#pragma mark 下拉刷新
- (void)actionMJHeaderRefresh
{
    self.currentPage = 1;
    [self.tabDataArr removeAllObjects];
    [self getCartDataHttp];
}
#pragma mark 上拉加载
- (void)actionMJFooterLoadMore
{
    [self getCartDataHttp];
}
#pragma mark FootView tableView
- (void)freshTableview
{
    if(self.tabDataArr.count == 0)
    {
        self.Type=TBNODateType;
        self.countModel.count =0;
        _isAllShopSelect = NO;
    }
    
    [self refreshSctionHeadView];
    [self freshFootView];
    [self.tableView reloadData];
}

#pragma mark 批量视图
-(void)creatFootview
{
    CGFloat Heigh = self.ShopCart_Type==ShopCart_TarbarType?49:0;
    _FootView=[[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight-50-Heigh, KScreenWidth, 50)];
    _FootView.backgroundColor=[UIColor whiteColor];
    _FootView.tag=7272;
    [self.view addSubview:_FootView];
    
    UILabel *linelable=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 0.5)];
    linelable.backgroundColor=RGBCOLOR(197, 197, 197);
    [_FootView addSubview:linelable];
    
    //全选按钮
    allselectbtn=[[UIButton alloc]init];
    allselectbtn.frame=CGRectMake(0,_FootView.frame.size.height/2-KZOOM6pt(60)/2,KZOOM6pt(200), KZOOM6pt(60));
    allselectbtn.imageEdgeInsets = UIEdgeInsetsMake(0,-KZOOM6pt(18),0.0f,KZOOM6pt(20));
    allselectbtn.titleEdgeInsets = UIEdgeInsetsMake(0, -KZOOM6pt(10), 0.0f, KZOOM6pt(10));
    [allselectbtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    [allselectbtn setImage:[UIImage imageNamed:@"勾选1"] forState:UIControlStateSelected];
    allselectbtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [allselectbtn setTitle:@"全选" forState:UIControlStateNormal];
    allselectbtn.titleLabel.font = [UIFont systemFontOfSize:KZOOM6pt(30)];
    [allselectbtn setTitleColor:basegreenColor forState:UIControlStateNormal];
    allselectbtn.clipsToBounds=YES;
    allselectbtn.selected=NO;
    allselectbtn.tag=9999;
    allselectbtn.layer.borderColor=KGrayColor.CGColor;
    [allselectbtn addTarget:self action:@selector(selectclick:) forControlEvents:UIControlEventTouchUpInside];
    [_FootView addSubview:allselectbtn];
    
    
    //结算
    _allpaybtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    _allpaybtn.frame=CGRectMake(kScreenWidth-KZOOM6pt(200), 0.5, KZOOM6pt(200), _FootView.frame.size.height-1);;
    _allpaybtn.backgroundColor = RGBCOLOR(197, 197, 197);
    _allpaybtn.titleLabel.font = [UIFont systemFontOfSize:KZOOM6pt(46)];
    [_allpaybtn addTarget:self action:@selector(pay:) forControlEvents:UIControlEventTouchUpInside];
    [_FootView addSubview:_allpaybtn];
    
    payTimeLabel=[[UILabel alloc]initWithFrame:_allpaybtn.frame];
    payTimeLabel.attributedText=[[NSAttributedString alloc]initWithString:@"结算"];
    payTimeLabel.textAlignment=NSTextAlignmentCenter;
    payTimeLabel.numberOfLines=0;
    payTimeLabel.textColor=[UIColor whiteColor];
    payTimeLabel.backgroundColor=[UIColor clearColor];
    [_FootView addSubview:payTimeLabel];
    
    _allmoneylable=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(allselectbtn.frame)+KZOOM6pt(10), CGRectGetMidY(_allpaybtn.frame)-20+KZOOM6pt(5), kScreenWidth/2, 20)];
    _allmoneylable.text=[NSString stringWithFormat:@"合计:￥0.0"];
    _allmoneylable.font=[UIFont systemFontOfSize:KZOOM6pt(28)];
    _allmoneylable.textColor=basegreenColor;
    _allmoneylable.textAlignment=NSTextAlignmentLeft;
    [_FootView addSubview:_allmoneylable];
    
    _lable=[[UILabel alloc]initWithFrame:CGRectMake(_allmoneylable.frame.origin.x, CGRectGetMidY(_allpaybtn.frame)-KZOOM6pt(5), _allmoneylable.frame.size.width, 20)];
    _lable.text= [NSString stringWithFormat:@"运费:￥%.2f",0.0];
    _lable.textColor=RGBCOLOR(168, 168, 168);
    _lable.font=[UIFont systemFontOfSize:KZOOM6pt(24)];
    _lable.textAlignment=NSTextAlignmentLeft;
    [_FootView addSubview:_lable];
    
}

#pragma mark  Footview
- (void)freshFootView
{
    //全选按钮是否选中
    BOOL found = self.tabDataArr.count?YES:NO;
    for(int i=0;i<self.tabDataArr.count;i++)
    {
        ShopCartModel *model = self.tabDataArr[i];
        NSArray *dataArray = model.list;
        
        for(int j=0;j<dataArray.count;j++)
        {
            ShopCartData *model = dataArray[j];
            if([model.selected integerValue] == 0)
            {
                found = NO;
                break;
            }
        }
    }
    _isAllShopSelect = found;
    allselectbtn.selected = _isAllShopSelect;
    
    //结算按钮状态
    NSString *sstt = _allmoneylable.hidden?@"删除":@"结算";
    if(self.countModel.count)
    {
        _allpaybtn.backgroundColor= basegreenColor;
        payTimeLabel.attributedText= [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@(%zd)",sstt,self.countModel.count]];
    }else{
        _allpaybtn.backgroundColor = RGBCOLOR(197, 197, 197);
        payTimeLabel.attributedText= [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",sstt]];
    }
    
    //改变商品总价
    _allmoneylable.text=[NSString stringWithFormat:@"合计:￥%.2f",self.countModel.order_total_price.floatValue];
    _lable.text= [NSString stringWithFormat:@"运费:￥%.2f",self.countModel.shipping_fee.floatValue];
}
#pragma mark section header
- (void)refreshSctionHeadView
{
    [self.sectionSelectArr removeAllObjects];
    for(int i =0; i<self.tabDataArr.count;i++)
    {
        CGFloat sectiontotalPrice = 0;
        NSInteger sectiontotalCount = 0;
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        ShopCartModel *model = self.tabDataArr[i];
        NSArray *dataArray = model.list;
        for(ShopCartData *model in dataArray)
        {
            if(model.selected)
            {
                sectiontotalPrice += model.member_goods_price.floatValue*model.goods_num.integerValue;
                sectiontotalCount ++;
            }

            [dic setObject:[NSString stringWithFormat:@"%.2f",sectiontotalPrice] forKey:@"sectiontotalPrice"];
            [dic setObject:[NSString stringWithFormat:@"%zd",sectiontotalCount] forKey:@"sectiontotalCount"];
        }

        [self.sectionSelectArr addObject:dic];
    }
}

#pragma mark 全选商品
- (void)selectclick:(UIButton*)sender
{
    kWeakSelf(self);
    [[CartShopManager cartShopManarer] selectCartShopHttp:@"0" Select:_isAllShopSelect Success:^(id data) {
        
        sender.selected = !sender.selected;
        _isAllShopSelect = sender.selected;
        
        self.countModel = [CartCountModel mj_objectWithKeyValues:data[@"data"]];
        for(int i=0;i<weakself.tabDataArr.count;i++)
        {
            ShopCartModel *model = self.tabDataArr[i];
            NSArray *dataArray = model.list;
            
            for(int j=0;j<dataArray.count;j++)
            {
                ShopCartData *model = dataArray[j];
                model.selected = [NSNumber numberWithBool:_isAllShopSelect];
            }
        }
        [weakself freshTableview];
    }];
}

#pragma mark 结算或者删除
- (void)pay:(UIButton*)sender
{
    if(self.countModel.count <= 0)
    {
        [MBProgressHUD show:@"请选择商品" icon:nil view:self.view];
        return;
    }
    
    if([payTimeLabel.text hasPrefix:@"结算"])
    {
        [KUserDefaul removeObjectForKey:SelectCoupon];//如果是新下单 删除之前选择的优惠券
        ConfirmOrderViewController *confirmOrder = [[ConfirmOrderViewController alloc]init];
        [self.navigationController pushViewController:confirmOrder animated:YES];
    }else{//删除
        kWeakSelf(self);
        [self creatAltViewTitle:@"温馨提示" Message:@"是否要删除所选商品" Sure:@"确定" Cancle:@"取消" SureBlock:^(id data) {
            [weakself deleteMoreShopCat];
        } CaccleBlock:^(id data) {
            
        }];
    }
}

#pragma mark 删除多个商品
- (void)deleteMoreShopCat
{
    NSMutableArray *IDArray = [NSMutableArray array];
    NSMutableArray *allArray = [NSMutableArray array];
    for(int i=0;i<self.tabDataArr.count;i++)
    {
        ShopCartModel *model = self.tabDataArr[i];
        NSArray *arr = model.list;
        
        NSMutableArray *indeArr = [NSMutableArray array];
        for(int j=0;j<arr.count;j++)
        {
            ShopCartData *model = arr[j];
            if([model.selected integerValue] == 0)
            {
                [indeArr addObject:model];
            }else{
                [IDArray addObject:model.ID];
            }
        }
        [allArray addObjectsFromArray:indeArr];
    }
    
    [self.tabDataArr removeAllObjects];
    self.tabDataArr = [NSMutableArray arrayWithArray:allArray];
    
    NSString *ids = [IDArray componentsJoinedByString:@","];
    [[CartShopManager cartShopManarer] deleateCartShopHttp:ids Success:^(id data) {
        
        [self freshTableview];
    }];
}
#pragma mark 删除单个商品
- (void)deleteShopCat:(NSIndexPath*)indexPath
{
    ShopCartModel *model = self.tabDataArr[indexPath.section];
    NSMutableArray *dataArray = [NSMutableArray arrayWithArray:model.list];
    NSInteger index = self.isJoin?(indexPath.row-1):indexPath.row;
    ShopCartData *datamodel = dataArray[index];
    
    kWeakSelf(self);
    [[CartShopManager cartShopManarer] deleateCartShopHttp:datamodel.ID Success:^(id data) {
        
        [MBProgressHUD show:@"删除成功" icon:nil view:self.view];
        
        self.countModel = [CartCountModel mj_objectWithKeyValues:data[@"data"]];
        [dataArray removeObjectAtIndex:index];
        
        model.list = dataArray;
        if(model.list.count == 0)
        {
            [self.tabDataArr removeObjectAtIndex:indexPath.section];
        }else{
            [self.tabDataArr replaceObjectAtIndex:indexPath.section withObject:model];
        }
        
        [weakself freshTableview];
    }];
}
#pragma mark *****************网络请求**************
//购物车数据
- (void)getCartDataHttp
{
    NSString *token = [KUserDefaul objectForKey:User_Token];
    NSMutableDictionary *reqDict = [NSMutableDictionary dictionary];
    [reqDict setValue:token forKey:@"token"];
    
    BaseReqApi *LoginApi=[[BaseReqApi alloc]initWithRequestUrl:@"cartGoods.json" andrequestTime:5 andParams:reqDict andRequestMethod:YTKRequestMethodPOST andCache:NO andCacheTime:0 andPostToken:NO];
    [MBProgressHUD showMessage:@"加载中..." afterDeleay:10 WithView:self.view];
    [LoginApi StarRequest:^(TBResponseStatus responseStatus, NSString *message, id responseObject) {
        [MBProgressHUD hideHUD];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (responseStatus==1) {
            
//            NSString *sstt = [HelpWay dictionaryToJSON:responseObject];
//            NSLog(@"sstt == %@",sstt);
//            [KUserDefaul setObject:sstt forKey:@"sstt"];
            
            self.currentPage ++;
            
            CartViewModel *model = [CartViewModel mj_objectWithKeyValues:responseObject];
            self.countModel = [CartCountModel mj_objectWithKeyValues:responseObject[@"tongji"]];
            NSLog(@"model == %@",model);
            [self.tabDataArr addObjectsFromArray:model.data];
            
            [self freshTableview];
    
        }else if (responseStatus==0||responseStatus==2)
        {
            [MBProgressHUD showError:message toView:self.view];
        }else{
            [MBProgressHUD showError:message toView:self.view];
            kWeakSelf(self);
            [self loginSuccess:^{
                [weakself getCartDataHttp];
            }];
        }
    }];
}

- (NSMutableArray*)tabDataArr
{
    if(_tabDataArr == nil)
    {
        _tabDataArr = [NSMutableArray array];
    }
    return _tabDataArr;
}

- (NSMutableArray*)selectShopArr
{
    if(_selectShopArr == nil)
    {
        _selectShopArr = [NSMutableArray array];
    }
    return _selectShopArr;
}

- (NSMutableArray*)sectionSelectArr
{
    if(_sectionSelectArr == nil)
    {
        _sectionSelectArr = [NSMutableArray array];
    }
    return _sectionSelectArr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
@end
