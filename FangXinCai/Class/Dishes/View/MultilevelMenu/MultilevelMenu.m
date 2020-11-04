//
//  MultilevelMenu.m
//  MultilevelMenu
//
//  Created by gitBurning on 15/3/13.
//  Copyright (c) 2015年 BR. All rights reserved.
//

#import "MultilevelMenu.h"
#import "MJFriendGroup.h"
#import "MJFriend.h"
#import "MJHeaderView.h"
#import "RightTableViewCell.h"
#import "LeftTableViewCell.h"
#import "GoodsCategoryModel.h"
#import "GoodsShopModel.h"
#import "RightShopTableViewCell.h"
#import "Common.h"
#import "MultilHeadView.h"
#import "CartShopManager.h"

#define kCellRightLineTag 100
#define kImageDefaultName @"tempShop"
#define kMultilevelCollectionViewCell @"MultilevelCollectionViewCell"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface MultilevelMenu() <MJHeaderViewDelegate>

@property(strong, nonatomic ) UITableView * leftTablew;
@property(strong, nonatomic ) UITableView * rightTablew;

@property(assign, nonatomic) BOOL isReturnLastOffset;
@property (nonatomic , strong) GoodsCategoryData *currentGoodsData;
@property (nonatomic , assign) NSInteger currentPage;  //当前页
@property (nonatomic , assign) NSInteger sort;         //当前赛选条件
@end
@implementation MultilevelMenu

-(instancetype)initWithFrame:(CGRect)frame WithData:(GoodsCategoryData *)data withSelectIndex:(void (^)(NSInteger, NSInteger, id))selectIndex
{
    self=[super initWithFrame:frame];
    if (self) {
        if (data.child.count==0) {
            return nil;
        }
        
        self.backgroundColor = AppVCBGColor;
        _block=selectIndex;
        self.leftSelectColor= basegreenColor;
        self.leftSelectBgColor=[UIColor whiteColor];
        self.leftBgColor=CViewBgColor;
        self.leftSeparatorColor=KGrayColor;
        self.leftUnSelectBgColor=CViewBgColor;
        self.leftUnSelectColor=[UIColor blackColor];
        
        _selectIndex=0;
        _allData=data.child;
        
        _currentPage =1;//默认第一页
        _sort = 1;      //默认按商品名排序
        [self creatMainTableView:frame];
    }
    return self;
}

- (void)creatMainTableView:(CGRect)frame
{
    /**
     左边的视图
     */
    self.leftTablew=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kLeftWidth, frame.size.height)];
    self.leftTablew.dataSource=self;
    self.leftTablew.delegate=self;
    
    [self.leftTablew.layer setBorderColor:BorDerColor1.CGColor];
    [self.leftTablew.layer setBorderWidth:1.0f];
    
    self.leftTablew.tableFooterView=[[UIView alloc] init];
    [self addSubview:self.leftTablew];
    
    self.leftTablew.backgroundColor=self.leftBgColor;
    if ([self.leftTablew respondsToSelector:@selector(setLayoutMargins:)]) {
        self.leftTablew.layoutMargins=UIEdgeInsetsZero;
    }
    if ([self.leftTablew respondsToSelector:@selector(setSeparatorInset:)]) {
        self.leftTablew.separatorInset=UIEdgeInsetsZero;
    }
    self.leftTablew.separatorColor=self.leftSeparatorColor;
    
    
    /**
     右边的视图
     */
    float leftMargin = 0;
    self.rightTablew=[[UITableView alloc] initWithFrame:CGRectMake(kLeftWidth+leftMargin,0,kScreenWidth-kLeftWidth-leftMargin*2,frame.size.height)];
    
    //添加footView可以去掉尾部空白的cell
    _rightTablew.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _rightTablew.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_rightTablew setSeparatorInset:UIEdgeInsetsZero];
    [_rightTablew setLayoutMargins:UIEdgeInsetsZero];
    
    self.rightTablew.delegate=self;
    self.rightTablew.dataSource=self;
    
    // 每一组头部控件的高度
    self.rightTablew.sectionHeaderHeight = 42;
    self.rightTablew.backgroundColor=[UIColor whiteColor];
    
    [self addSubview:_rightTablew];
    
    self.isReturnLastOffset=YES;
    self.backgroundColor=self.leftSelectBgColor;
    
    //注册cell
    [self.rightTablew registerNib:[UINib nibWithNibName:@"RightTableViewCell" bundle:nil] forCellReuseIdentifier:@"RightCell"];
    
    [self.rightTablew registerNib:[UINib nibWithNibName:@"RightShopTableViewCell" bundle:nil] forCellReuseIdentifier:@"RightShopCell"];
    
    //头部刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(actionMJHeaderRefresh)];
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    self.rightTablew.mj_header = header;
    
    //底部刷新
    self.rightTablew.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(actionMJFooterLoadMore)];
    
    //设置没有数据的界面
}
//下拉刷新
- (void)actionMJHeaderRefresh
{
    self.currentPage = 1;
    [self.rightData removeAllObjects];
    [self.rightAllData removeAllObjects];
    [self goodsCatoryHttp:self.currentGoodsData Sort:self.sort];
}
//上拉加载
- (void)actionMJFooterLoadMore
{
    [self goodsCatoryHttp:self.currentGoodsData Sort:self.sort];
}
-(void)setNeedToScorllerIndex:(NSInteger)needToScorllerIndex{
    
    //滑动到 指定行数
    if(self.allData.count)
    {
        [self.leftTablew selectRowAtIndexPath:[NSIndexPath indexPathForRow:needToScorllerIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
        
        _selectIndex=needToScorllerIndex;
        _needToScorllerIndex=needToScorllerIndex;
    }
}
-(void)setLeftBgColor:(UIColor *)leftBgColor{
    _leftBgColor=leftBgColor;
    self.leftTablew.backgroundColor=leftBgColor;
}
-(void)setLeftSelectBgColor:(UIColor *)leftSelectBgColor{
    
    _leftSelectBgColor=leftSelectBgColor;
    self.rightTablew.backgroundColor=leftSelectBgColor;
    
    self.backgroundColor=leftSelectBgColor;
}
-(void)setLeftSeparatorColor:(UIColor *)leftSeparatorColor{
    _leftSeparatorColor=leftSeparatorColor;
    self.leftTablew.separatorColor=leftSeparatorColor;
    self.leftTablew.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
}

- (void)reloadAllData:(GoodsCategoryData*)allData;
{
    _allData = allData.child;
    [self.leftTablew reloadData];
    
    if(_allData.count)
    {
        self.currentPage = 1;
        [self.rightData removeAllObjects];
        [self.rightAllData removeAllObjects];
        [self goodsCatoryHttp:_allData[0] Sort:1];
    }
}
-(void)setLeftTablewCellSelected:(BOOL)selected withCell:(LeftTableViewCell *)cell
{
    if (selected) {
        cell.titleLabel.textColor=self.leftSelectColor;
        cell.selectView.hidden = NO;
    }
    else{
        cell.titleLabel.textColor=self.leftUnSelectColor;
        cell.selectView.hidden = YES;
    }
}

#pragma mark---左边的tablew 代理
#pragma mark--deleagte

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(_leftTablew == tableView){
        return 1;
    }else {
        
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView == _leftTablew)
    {
        return 0.01;
    }
    return 40;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(_leftTablew == tableView){

        return self.allData.count;
    }else {
        return self.rightData.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(_leftTablew == tableView){
        
        // 1.创建cell
        LeftTableViewCell *cell = [LeftTableViewCell cellWithTableView:tableView];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell setSeparatorInset:UIEdgeInsetsZero];
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
        // 2.设置cell的数据
        GoodsCategoryData *categoryData = self.allData[indexPath.row];
        cell.titleLabel.text = categoryData.name;
        
        // 3.设置cell的选中处理事件
        
        if (indexPath.row==self.selectIndex) {
            NSLog(@"设置点中");
            [self setLeftTablewCellSelected:YES withCell:cell];
        }
        else{
            [self setLeftTablewCellSelected:NO withCell:cell];
            
            NSLog(@"设置不点中");
        }
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            cell.layoutMargins=UIEdgeInsetsZero;
        }
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            cell.separatorInset=UIEdgeInsetsZero;
        }

        return cell;

    }
    else {

        GoodsShopData *shopdata = [GoodsShopData alloc];
        if(self.rightData.count)
        {
            shopdata = self.rightData[indexPath.row];
        }
        
        if(shopdata.childSpeckey && !shopdata.moreSpeckey)
        {
            // 1.创建cell
            RightShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RightShopCell"];
            if(cell == nil)
            {
                cell = [[RightShopTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"RightShopCell"];
            }
            
            kWeakSelf(self);
            kWeakSelf(cell);
            cell.addCartBlock = ^(NSDictionary *data, BOOL add) {
                if(add)
                {
                    CGRect parentRect = [weakcell convertRect:weakcell.addActiveBtn.frame toView:weakself];
                    // 这里是动画开始的方法
                    [weakself joinCartAnimationWithRect:parentRect];
                }else{
                    if(weakself.addAndReduceBlock)
                    {
                        weakself.addAndReduceBlock();
                    }
                }
            };
            
            cell.backgroundColor = RGB(251, 251, 251);
            [cell refreshData:shopdata];
            return cell;
            
        }else{
            // 1.创建cell
            RightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RightCell"];
            if(cell == nil)
            {
                cell = [[RightTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"RightCell"];
            }
            kWeakSelf(self);
            kWeakSelf(cell);
            cell.selectSpecBlock = ^(GoodsShopData *shopmodel) {
                [weakself insertChildData:shopmodel Index:indexPath.row];
            };
            [cell refreshData:shopdata];
            
            cell.addCartBlock = ^(NSDictionary *data, BOOL add) {
                if(add)
                {
                    CGRect parentRect = [weakcell convertRect:weakcell.addactiveBtn.frame toView:weakself];
                    // 这里是动画开始的方法
                    [weakself joinCartAnimationWithRect:parentRect];
                }else{
                    if(weakself.addAndReduceBlock)
                    {
                        weakself.addAndReduceBlock();
                    }
                }
            };
            
            return cell;
        }
    }
}

/**
 *  返回每一组需要显示的头部标题(字符出纳)
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(tableView == _rightTablew)
    {        
        kWeakSelf(self);
        self.HeadView.headClick = ^(NSInteger sort) {
            weakself.currentPage = 1;
            [weakself.rightData removeAllObjects];
            [weakself.rightAllData removeAllObjects];
            [weakself goodsCatoryHttp:weakself.currentGoodsData Sort:sort];
        };
        
        return self.HeadView;
    }
    return nil;
}
- (MultilHeadView*)HeadView
{
    if(_HeadView == nil)
    {
        _HeadView = [[MultilHeadView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_rightTablew.frame), 40)];
    }
    return _HeadView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == _leftTablew)
    {
        return 42;
    }else{
        
        GoodsShopData *shopdata = [GoodsShopData alloc];
        if(self.rightData.count)
        {
            shopdata = self.rightData[indexPath.row];
        }
        if(shopdata.childSpeckey && !shopdata.moreSpeckey)//子规格
        {
            return 60;
        }
        return 80;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.leftTablew == tableView){
        LeftTableViewCell * cell=(LeftTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        _selectIndex=indexPath.row;
        
        if(indexPath.row !=0)
        {
            NSIndexPath *Path = [NSIndexPath indexPathForRow:0 inSection:0];
            
            LeftTableViewCell * zerocell=(LeftTableViewCell*)[tableView cellForRowAtIndexPath:Path];
            [self setLeftTablewCellSelected:NO withCell:zerocell];
        }
        
        [self setLeftTablewCellSelected:YES withCell:cell];
        
        GoodsCategoryData *categoryData = self.allData[indexPath.row];
        
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
        self.isReturnLastOffset=NO;
        _needToScorllerIndex = indexPath.row;
        

        if (self.isRecordLastScroll) {
            [self.rightTablew scrollRectToVisible:CGRectMake(0, categoryData.offsetScorller, self.rightTablew.frame.size.width, self.rightTablew.frame.size.height) animated:self.isRecordLastScrollAnimated];
        }else{
            
            [self.rightTablew scrollRectToVisible:CGRectMake(0, 0, self.rightTablew.frame.size.width, self.rightTablew.frame.size.height) animated:self.isRecordLastScrollAnimated];
        }
        
        if(self.leftTableBlock)
        {
            self.leftTableBlock(categoryData);
        }
        
        self.currentPage = 1;
        [self.rightData removeAllObjects];
        [self.rightAllData removeAllObjects];
        [self goodsCatoryHttp:categoryData Sort:self.sort];
    }else{
        //NSLog(@"rightTableView.indexPath%ld",(long)indexPath.row);
        NSLog(@"rightTableCellSelect...");
        
        GoodsShopData *shopdata = [GoodsShopData alloc];
        if(self.rightData.count)
        {
            shopdata = self.rightData[indexPath.row];
        }
        
        if(self.rightTableBlock)
        {
            self.rightTableBlock(shopdata);
        }
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.leftTablew == tableView){
        LeftTableViewCell * cell=(LeftTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
       
        [self setLeftTablewCellSelected:NO withCell:cell];
        
        cell.backgroundColor=self.leftUnSelectBgColor;

    }else{
        NSLog(@"rightTableViewCellDidSelect...");
    }
}

#pragma mark---记录滑动的坐标
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.rightTablew]) {

        self.isReturnLastOffset=YES;
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([scrollView isEqual:self.rightTablew]) {
        
        GoodsCategoryData *title = self.allData[self.selectIndex];
        title.offsetScorller=scrollView.contentOffset.y;
        self.isReturnLastOffset=NO;
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([scrollView isEqual:self.rightTablew]) {
        
        GoodsCategoryData *title = self.allData[self.selectIndex];
        title.offsetScorller=scrollView.contentOffset.y;
        self.isReturnLastOffset=NO;

    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if ([scrollView isEqual:self.rightTablew] && self.isReturnLastOffset) {

        GoodsCategoryData *title = self.allData[self.selectIndex];
        title.offsetScorller=scrollView.contentOffset.y;
    }
}

#pragma mark--Tools
-(void)performBlock:(void (^)())block afterDelay:(NSTimeInterval)delay{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}


#pragma mark ***************网络请求***************
- (void)goodsCatoryHttp:(GoodsCategoryData*)data Sort:(NSInteger)sort
{
    self.currentGoodsData = data;
    self.sort = sort;
    
    NSString *token = [KUserDefaul objectForKey:User_Token];
    NSMutableDictionary *reqDict = [NSMutableDictionary dictionary];
    [reqDict setValue:token forKey:@"token"];
    [reqDict setValue:@"10" forKey:@"pageSize"];
    [reqDict setValue:data.ID forKey:@"id"];
    [reqDict setValue:[NSString stringWithFormat:@"%zd",self.currentPage] forKey:@"page"];
    [reqDict setValue:[NSString stringWithFormat:@"%zd",sort] forKey:@"sort"];
    
    BaseReqApi *LoginApi=[[BaseReqApi alloc]initWithRequestUrl:@"categoryGoods.json" andrequestTime:5 andParams:reqDict andRequestMethod:YTKRequestMethodPOST andCache:NO andCacheTime:0 andPostToken:NO];
    [MBProgressHUD showMessage:@"加载中..." afterDeleay:10 WithView:self];
    [LoginApi StarRequest:^(TBResponseStatus responseStatus, NSString *message, id responseObject) {
        [MBProgressHUD hideHUDForView:self];
        [self.rightTablew.mj_header endRefreshing];
        [self.rightTablew.mj_footer endRefreshing];
        if (responseStatus==1) {
            self.currentPage ++;
            
            GoodsShopModel *model = [GoodsShopModel mj_objectWithKeyValues:responseObject];
            [self.rightAllData addObjectsFromArray:model.data];
            
            [self handleData:model.data];

        }else if (responseStatus==0||responseStatus==2)
        {
            [MBProgressHUD showError:message toView:self];
        }else{
            [MBProgressHUD showError:message toView:self];
        }
    }];
}

- (void)handleData:(NSArray*)data
{
    if(data.count)
    {
        for(NSArray *dataArr in data)
        {
            CGFloat selectMoreSpeckey = NO;
            
            for(int i=0;i<dataArr.count;i++)
            {
                
                if(i == 0)
                {
                    GoodsShopData *childData = dataArr[0];
                    childData.childSpeckey = NO;
                    childData.moreSpeckey = dataArr.count>1?YES:NO;
                    [self.rightData addObject:childData];
                    
                    selectMoreSpeckey = childData.selectMoreSpeckey;
                    if(!selectMoreSpeckey)
                    {
                        break;
                    }
                }
                
                GoodsShopData *childotherData1 = dataArr[i];
                GoodsShopData *childotherData = [childotherData1 copy];
                childotherData.childSpeckey = YES;
                childotherData.moreSpeckey =  NO;
                [self.rightData addObject:childotherData];
                
            }
        }
    }
    [self.rightTablew reloadData];
}

//插入子规格数据
- (void)insertChildData:(GoodsShopData *)model Index:(NSInteger)index
{
    [self.rightData removeAllObjects];
    [self handleData:self.rightAllData];
}


#pragma mark -加入购物车动画
-(void)joinCartAnimationWithRect:(CGRect)rect
{
    self.endPoint_x = KScreenWidth*0.8;
    self.endPoint_y = KScreenHeight-40;
    
    CGFloat startX = rect.origin.x;
    CGFloat startY = rect.origin.y;
    
    self.path= [UIBezierPath bezierPath];
    [self.path moveToPoint:CGPointMake(startX, startY)];
    
    //三点曲线
    [self.path addCurveToPoint:CGPointMake(self.endPoint_x, self.endPoint_y)
                 controlPoint1:CGPointMake(startX, startY)
                 controlPoint2:CGPointMake(startX - 180, startY - 200)];
    self.dotLayer = [CALayer layer];
    self.dotLayer.backgroundColor = [UIColor redColor].CGColor;
    self.dotLayer.frame = CGRectMake(0, 0, 20, 20);
    self.dotLayer.cornerRadius = 10;
    [self.layer addSublayer:_dotLayer];
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
    
    if(self.addAndReduceBlock)
    {
        self.addAndReduceBlock();
    }
    
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
        
        //        [markbtn.layer addAnimation:shakeAnimation forKey:nil];
    }
}
- (NSMutableArray*)rightAllData
{
    if(_rightAllData == nil)
    {
        _rightAllData = [NSMutableArray array];
    }
    return _rightAllData;
}
- (NSMutableArray*)rightData
{
    if(_rightData == nil)
    {
        _rightData = [NSMutableArray array];
    }
    return _rightData;
}
@end
