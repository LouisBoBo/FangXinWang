//
//  CFImagePickerVC.m
//  codeTest
//
//  Created by yssj on 2017/2/7.
//  Copyright © 2017年 CooFree. All rights reserved.
//

#import "CFImagePickerVC.h"
#import "AssetHelper.h"
#import "DoAlbumCell.h"
#import "DoPhotoCell.h"
//#import "NSString+helper.h"
#import "GlobalTool.h"

#import "NavgationbarView.h"

#import "MessageReadManager.h"

#import "CFPhotoEditViewController.h"
#import "AddTagsViewController.h"

#define kScreenWidth          [[UIScreen mainScreen] bounds].size.width           //(e.g. 320)
#define TableHeight 200
#define TableSectionHeight 50
#define TableCellHeight 66


@interface CFImagePickerCell : UITableViewCell

@property (nonatomic,strong)UIImageView *imgView;
@property (nonatomic,strong)UILabel *nameLabel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
@implementation CFImagePickerCell
- (UIImageView *)imgView {
    if (nil == _imgView) {
        _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 8, 50, 50)];
        _imgView.clipsToBounds = YES;
    }
    return _imgView;
}
- (UILabel *)nameLabel {
    if (nil == _nameLabel) {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.imgView.frame)+10, 8, 200, 50)];
//        _nameLabel.textColor = kSubTitleColor;
//        _nameLabel.font = [UIFont systemFontOfSize:kZoom6pt(12)];
    }
    return _nameLabel;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
    }
    return self;
}
- (void)setUI {
    [self.contentView addSubview:self.imgView];
    [self.contentView addSubview:self.nameLabel];
}
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    CFImagePickerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CFImagePickerCell"];
    if (nil == cell) {
        cell = [[CFImagePickerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CFImagePickerCell"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}
@end

@interface CFTableHeader : UIView
typedef void (^ButtonClickBlock)(UIButton *sender);
@property (nonatomic,copy)ButtonClickBlock BtnBlock;
@property (nonatomic,strong)UILabel *textLabel;
@property (nonatomic,strong)UIButton *AllBtn;
- (void)ButtonClickBlock:(ButtonClickBlock )block;
@end
@implementation CFTableHeader

- (instancetype)initWithFrame:(CGRect)frame {
    if (self=[super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}
- (UIButton *)AllBtn {
    if (_AllBtn==nil) {
        _AllBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _AllBtn.frame=CGRectMake(0, 0, kScreenWidth, TableSectionHeight);
        [_AllBtn addTarget:self action:@selector(tableHeaderViewClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_AllBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_AllBtn setTitle:@"所有照片" forState:UIControlStateNormal];
        [_AllBtn setImage:[UIImage imageNamed:@"hebing_icon"] forState:UIControlStateSelected];
        [_AllBtn setImage:[UIImage imageNamed:@"zhankai_icon"] forState:UIControlStateNormal];
        [_AllBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_AllBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [_AllBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    }
    return _AllBtn;
}
- (void)ButtonClickBlock:(ButtonClickBlock)block {
    _BtnBlock = block;
}
- (void)tableHeaderViewClick:(UIButton *)sender {
    if (_BtnBlock) {
        _BtnBlock(sender);
    }
}
- (UILabel *)textLabel {
    if (_textLabel==nil) {
        _textLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-10, self.frame.size.height)];
        _textLabel.textAlignment=NSTextAlignmentRight;
    }
    return _textLabel;
}
- (void)setUI {
    [self addSubview:self.textLabel];
    [self addSubview:self.AllBtn];
}
@end

@interface CFImagePickerVC ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) MessageReadManager *messageReadManager;//message阅读的管理者

@property (nonatomic,strong)CFTableHeader *tableHeaderView;
@property (nonatomic,strong)UIButton *backView;
@end

@implementation CFImagePickerVC
{
    BOOL _is_groups;
}
- (MessageReadManager *)messageReadManager
{
    if (_messageReadManager == nil) {
        _messageReadManager = [MessageReadManager defaultManager];
    }
    
    return _messageReadManager;
}
- (void)viewDidAppear:(BOOL)animated
{
    
//    if(_is_groups == NO)
//    {
//        //没有设置允许使用相册 提示用户
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                        message:@"请在设备的\"设置-隐私-相册\"中允许访问相册。"
//                                                       delegate:self
//                                              cancelButtonTitle:@"确定"
//                                              otherButtonTitles:nil];
//        [alert show];
//        
//        
//    }
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied){
        //没有设置允许使用相册 提示用户
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请在设备的\"设置-隐私-相册\"中允许访问相册。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }
   
    
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
//    if (!_isPublish) {
//        if (_nResultType == DO_PICKER_RESULT_UIIMAGE)
//            [ASSETHELPER clearData];
        
//        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
//    }
 
}
- (void)leftBarButtonClick {
//    if (_isPublish) {
        [self dismissViewControllerAnimated:YES completion:nil];
//    }
//    else
//    if (self.navigationController) {
//        [self.navigationController popViewControllerAnimated:YES];
//    }else
//        [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)setNavigationItemLeftAndRight;
{
    
    UIImageView *headview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    headview.image=[UIImage imageNamed:@"导航背景"];
    [self.view addSubview:headview];
    headview.userInteractionEnabled=YES;
    
    UIButton *backbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backbtn.frame=CGRectMake(0, 20, 46, 46);
    [backbtn addTarget:self action:@selector(leftBarButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [backbtn setImage:[UIImage imageNamed:@"返回按钮_正常"] forState:UIControlStateNormal];
    //    [backbtn setImage:[UIImage imageNamed:@"返回按钮_高亮"] forState:UIControlStateHighlighted];
    [headview addSubview:backbtn];
    
    UIButton *setbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    setbtn.frame=CGRectMake(kScreenWidth-80, 20, 80, 44);
    [setbtn addTarget:self action:@selector(onSelectPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [setbtn setTitle:@"确定" forState:UIControlStateNormal];
    [setbtn setTitleColor:tarbarrossred forState:UIControlStateNormal];
    [setbtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
//    [setbtn setImage:[UIImage imageNamed:@"消息按钮_正常"] forState:UIControlStateNormal];
    //    [setbtn setImage:[UIImage imageNamed:@"消息按钮_高亮"] forState:UIControlStateHighlighted];
    if (!_isPublish)
        [headview addSubview:setbtn];
    
    UILabel *titlelable=[[UILabel alloc]init];
    titlelable.frame=CGRectMake(0, 0, headview.frame.size.width, 40);
    titlelable.center=CGPointMake(kScreenWidth/2, headview.frame.size.height/2+10);
    titlelable.text= @"选择照片";
    titlelable.font = kNavTitleFontSize;
    titlelable.textColor=kMainTitleColor;
    titlelable.textAlignment=NSTextAlignmentCenter;
    [headview addSubview:titlelable];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets=NO;
    
//    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(onSelectPhoto:)];
    
//    if (_isPublish) {
        self.navigationController.navigationBar.hidden=YES;
//    }
    
    [self setNavigationItemLeftAndRight];
    
    [self setUI];
    [self readAlbumList:YES];

    
    UINib *nib = [UINib nibWithNibName:@"DoPhotoCell" bundle:nil];
    [_cvPhotoList registerNib:nib forCellWithReuseIdentifier:@"DoPhotoCell"];

    
    // new photo is located at the first of array
    ASSETHELPER.bReverse = YES;
    
    if (_nMaxCount != 1)
    {
        // init gesture for multiple selection with panning
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanForSelection:)];
        [self.view addGestureRecognizer:pan];
    }
    
    // init gesture for preview
    UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongTapForPreview:)];
    longTap.minimumPressDuration = 0.3;
    [self.view addGestureRecognizer:longTap];
    
    
    // add observer for refresh asset data
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(handleEnterForeground:)
                                                 name: UIApplicationWillEnterForegroundNotification
                                               object: nil];
}

- (CFTableHeader *)tableHeaderView {
    if (_tableHeaderView==nil) {
        _tableHeaderView=[[CFTableHeader alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-TableSectionHeight, kScreenWidth, TableSectionHeight)];
        _tableHeaderView.backgroundColor=[UIColor whiteColor];
        kSelfWeak;
        [_tableHeaderView ButtonClickBlock:^(UIButton *sender) {
            sender.selected=!sender.selected;
            if (sender.selected) {
                [weakSelf showTableView];
            }else {
                [weakSelf hideTableView];
            }
        }];
    }
    return _tableHeaderView;
}
- (UIButton *)backView {
    if (_backView==nil) {
        _backView=[UIButton buttonWithType:UIButtonTypeCustom];
        _backView.backgroundColor=[UIColor colorWithWhite:0. alpha:.3961];
        [_backView addTarget:self action:@selector(hideTableView) forControlEvents:UIControlEventTouchUpInside];
        self.backView.frame=CGRectMake(0, 0, kScreenWidth, self.view.frame.size.height);
        _backView.alpha=0;
    }
    return _backView;
}
- (void)showTableView {
    UIWindow *window=[[[UIApplication sharedApplication]delegate]window];
    [window addSubview:self.backView];

    [UIView animateWithDuration:0.25 animations:^{
        self.backView.frame=CGRectMake(0, 0, kScreenWidth, self.view.frame.size.height-_tvAlbumList.frame.size.height-TableSectionHeight);
        self.backView.alpha=1;
        
        _tvAlbumList.frame = CGRectMake(0,self.view.frame.size.height-_tvAlbumList.frame.size.height, self.view.frame.size.width, _tvAlbumList.frame.size.height);
        self.tableHeaderView.frame = CGRectMake(0, _tvAlbumList.frame.origin.y-TableSectionHeight, kScreenWidth, TableSectionHeight);
    }];
    
}
- (void)hideTableView {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.backView.alpha=0;
        self.backView.frame=CGRectMake(0, 0, kScreenWidth, self.view.frame.size.height);
        self.tableHeaderView.AllBtn.selected=NO;

        _tvAlbumList.frame = CGRectMake(0, self.view.frame.size.height, kScreenWidth, _tvAlbumList.frame.size.height);
        self.tableHeaderView.frame = CGRectMake(0, self.view.frame.size.height-TableSectionHeight, kScreenWidth, TableSectionHeight);
    }completion:^(BOOL finished) {
        [self.backView removeFromSuperview];
    }];
    
}
- (void)setUI {
    
    //确定是水平滚动，还是垂直滚动
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
    flowLayout.minimumLineSpacing=5;
    flowLayout.minimumInteritemSpacing=5;
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
//    flowLayout.headerReferenceSize = CGSizeMake(kScreenWidth, ZOOM(570));  //设置head大小
    _cvPhotoList = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64-TableSectionHeight) collectionViewLayout:flowLayout];
    _cvPhotoList.backgroundColor=[UIColor groupTableViewBackgroundColor];
    _cvPhotoList.delegate=self;
    _cvPhotoList.dataSource=self;
    [self.view addSubview:_cvPhotoList];
    
    _tvAlbumList = [[UITableView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, kScreenWidth, TableHeight)style:UITableViewStyleGrouped];
    _tvAlbumList.sectionFooterHeight=[self minHeight];
    _tvAlbumList.tableHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    _tvAlbumList.tableFooterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];

    _tvAlbumList.rowHeight=TableCellHeight;
//    _tvAlbumList.bounces=NO;
    _tvAlbumList.delegate=self;
    _tvAlbumList.dataSource=self;
    _tvAlbumList.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_tvAlbumList];
    
    [self.view addSubview:self.tableHeaderView];

//    _tvAlbumList.frame = CGRectMake(0, _vBottomMenu.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
//    _tvAlbumList.alpha = 0.0;
}
- (CGFloat)minHeight {
    return CGFLOAT_MIN;
}
- (void)readAlbumList:(BOOL)bFirst
{
    kSelfWeak;
    [ASSETHELPER getGroupList:^(NSArray *aGroups) {
        
        [weakSelf.tvAlbumList reloadData];
        
        NSInteger nIndex = 0;
#ifdef DO_SAVE_SELECTED_ALBUM
        nIndex = [weakSelf getSelectedGroupIndex:aGroups];
        if (nIndex < 0)
            nIndex = 0;
#endif
        [weakSelf.tvAlbumList selectRowAtIndexPath:[NSIndexPath indexPathForRow:nIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        [weakSelf.btSelectAlbum setTitle:[ASSETHELPER getGroupInfo:nIndex][@"name"] forState:UIControlStateNormal];
        
        [weakSelf showPhotosInGroup:nIndex];
        
        if (aGroups.count == 1)
            weakSelf.btSelectAlbum.enabled = NO;
        
        // calculate tableview's height
        weakSelf.tvAlbumList.frame = CGRectMake(weakSelf.tvAlbumList.frame.origin.x, weakSelf.tvAlbumList.frame.origin.y, weakSelf.tvAlbumList.frame.size.width, MIN(aGroups.count * TableCellHeight, TableCellHeight*3));
        kSelfStrong;
        
        strongSelf->_is_groups = YES;
    }];
    
    
}

#pragma mark - UITableViewDelegate for selecting album
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ASSETHELPER getGroupCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CFImagePickerCell *cell=[CFImagePickerCell cellWithTableView:tableView];
    NSDictionary *d = [ASSETHELPER getGroupInfo:indexPath.row];
    cell.imgView.image=d[@"thumbnail"];
    NSString *count=[NSString stringWithFormat:@"%@", d[@"count"]];
    cell.nameLabel.attributedText=[NSMutableString getOneColorInLabel:[NSString stringWithFormat:@"%@ %@",d[@"name"],count] ColorString:count Color:[UIColor redColor] fontSize:14];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self showPhotosInGroup:indexPath.row];
    [_btSelectAlbum setTitle:[ASSETHELPER getGroupInfo:indexPath.row][@"name"] forState:UIControlStateNormal];
    
    [self hideTableView];
}


#pragma mark - UICollectionViewDelegates for photos
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [ASSETHELPER getPhotoCountOfCurrentGroup];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DoPhotoCell *cell = (DoPhotoCell *)[_cvPhotoList dequeueReusableCellWithReuseIdentifier:@"DoPhotoCell" forIndexPath:indexPath];
    cell.backgroundColor=[UIColor brownColor];
    cell.ivPhoto.image = [ASSETHELPER getImageAtIndex:indexPath.row type:ASSET_PHOTO_THUMBNAIL];
    
    if (_dSelected[@(indexPath.row)] == nil)
        [cell setSelectMode:NO];
    else
        [cell setSelectMode:YES];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    [self.messageReadManager showBrowserWithImages:@[[ASSETHELPER getImageAtIndex:indexPath.row type:ASSET_PHOTO_THUMBNAIL]]];
//    return;
    
    if (_isPublish) {
//        kSelfWeak;
//        AddTagsViewController *vc=[[AddTagsViewController alloc]init];
//        vc.refreshBlock = ^{
//            if (weakSelf.refreshBlock) {
//                weakSelf.refreshBlock();
//            }
//        };
//        vc.tagImage=[ASSETHELPER getImageAtIndex:indexPath.row type:ASSET_PHOTO_SCREEN_SIZE];
        
//        CFPhotoEditViewController *vc2 = [CFPhotoEditViewController new];
//        vc2.oriImage=[ASSETHELPER getImageAtIndex:indexPath.row type:ASSET_PHOTO_SCREEN_SIZE];
        NSMutableArray *arr = [NSMutableArray arrayWithObject:[ASSETHELPER getImageAtIndex:indexPath.row type:ASSET_PHOTO_SCREEN_SIZE]];
//        vc2.imgArr = arr;
//        vc2.refreshBlock = ^{
//            if (weakSelf.refreshBlock) {
//                weakSelf.refreshBlock();
//            }
//        };
//        [self.navigationController pushViewController:vc2 animated:YES];
        
        [self toPhotoEditVC:arr isNeedBlock:NO];
        
        return;
    }
    
    if (_nMaxCount > 1 || _nMaxCount == DO_NO_LIMIT_SELECT)
    {
        DoPhotoCell *cell = (DoPhotoCell *)[collectionView cellForItemAtIndexPath:indexPath];
        
        if ((_dSelected[@(indexPath.row)] == nil) && (_nMaxCount > _dSelected.count))
        {
            // select
            _dSelected[@(indexPath.row)] = @(_dSelected.count);
            [cell setSelectMode:YES];
        }
        else
        {
            // unselect
            [_dSelected removeObjectForKey:@(indexPath.row)];
            [cell setSelectMode:NO];
            
            if (_dSelected.count>=_nMaxCount) {
                [NavgationbarView showMessageAndHide:[NSString stringWithFormat:@"最多只能选择%zd张图片哦～",_nMaxCount]];
            }
        }
        
        if (_nMaxCount == DO_NO_LIMIT_SELECT)
            _lbSelectCount.text = [NSString stringWithFormat:@"(%d)", (int)_dSelected.count];
        else
            _lbSelectCount.text = [NSString stringWithFormat:@"(%d/%d)", (int)_dSelected.count, (int)_nMaxCount];
        
        self.tableHeaderView.textLabel.text=[NSString stringWithFormat:@"%zd/%zd",_dSelected.count,_nMaxCount];

        
       
    }
    else
    {
        if (_nResultType == DO_PICKER_RESULT_UIIMAGE)
            [_delegate didSelectPhotosFromDoImagePickerController:self result:@[[ASSETHELPER getImageAtIndex:indexPath.row type:ASSET_PHOTO_SCREEN_SIZE]]];
        else
            [_delegate didSelectPhotosFromDoImagePickerController:self result:@[[ASSETHELPER getAssetAtIndex:indexPath.row]]];
      
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_nColumnCount == 2){
        CGFloat width = (self.view.frame.size.width-15)/2;
        
        return CGSizeMake(width, width);
    }
    else if (_nColumnCount == 3){
        CGFloat width = (self.view.frame.size.width-20)/3;

        return CGSizeMake(width, width);
    }
    else if (_nColumnCount == 4)
    {
//        CGFloat width = (kScreenWidth - 10)/5;
        CGFloat width = (self.view.frame.size.width-25)/4;

        return CGSizeMake(width, width);
        
        //        return CGSizeMake(77, 77);
    }
    return CGSizeZero;
}

// for multiple selection with panning
- (void)onPanForSelection:(UIPanGestureRecognizer *)gestureRecognizer
{
    if (_ivPreview != nil)
        return;
    
    double fX = [gestureRecognizer locationInView:_cvPhotoList].x;
    double fY = [gestureRecognizer locationInView:_cvPhotoList].y;
    
    for (UICollectionViewCell *cell in _cvPhotoList.visibleCells)
    {
        float fSX = cell.frame.origin.x;
        float fEX = cell.frame.origin.x + cell.frame.size.width;
        float fSY = cell.frame.origin.y;
        float fEY = cell.frame.origin.y + cell.frame.size.height;
        
        if (fX >= fSX && fX <= fEX && fY >= fSY && fY <= fEY)
        {
            NSIndexPath *indexPath = [_cvPhotoList indexPathForCell:cell];
            
            if (_lastAccessed != indexPath)
            {
                [self collectionView:_cvPhotoList didSelectItemAtIndexPath:indexPath];
            }
            
            _lastAccessed = indexPath;
        }
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        _lastAccessed = nil;
        _cvPhotoList.scrollEnabled = YES;
    }
}

// for preview
- (void)onLongTapForPreview:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (_ivPreview != nil)
        return;
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        double fX = [gestureRecognizer locationInView:_cvPhotoList].x;
        double fY = [gestureRecognizer locationInView:_cvPhotoList].y;
        
        // check boundary of controls
        CGPoint pt = [gestureRecognizer locationInView:self.view];
        if (CGRectContainsPoint(_vBottomMenu.frame, pt))
            return;
        if (_btDown.alpha == 1.0 && CGRectContainsPoint(_btDown.frame, pt))
            return;
        if (_btUp.alpha == 1.0 && CGRectContainsPoint(_btUp.frame, pt))
            return;
        
        NSIndexPath *indexPath = nil;
        for (UICollectionViewCell *cell in _cvPhotoList.visibleCells)
        {
            float fSX = cell.frame.origin.x;
            float fEX = cell.frame.origin.x + cell.frame.size.width;
            float fSY = cell.frame.origin.y;
            float fEY = cell.frame.origin.y + cell.frame.size.height;
            
            if (fX >= fSX && fX <= fEX && fY >= fSY && fY <= fEY)
            {
                indexPath = [_cvPhotoList indexPathForCell:cell];
                break;
            }
        }
        
        if (indexPath != nil)
            [self showPreview:indexPath.row];
    }
}

#pragma mark - for photos
- (void)showPhotosInGroup:(NSInteger)nIndex
{
    if (_nMaxCount == DO_NO_LIMIT_SELECT)
    {
        _dSelected = [[NSMutableDictionary alloc] init];
        _lbSelectCount.text = @"(0)";
    }
    else if (_nMaxCount >= 1)
    {
        _dSelected = [[NSMutableDictionary alloc] initWithCapacity:_nMaxCount];
        _lbSelectCount.text = [NSString stringWithFormat:@"(0/%d)", (int)_nMaxCount];
        self.tableHeaderView.textLabel.text=[NSString stringWithFormat:@"%zd/%zd",_dSelected.count,_nMaxCount];

    }
    kSelfWeak;
    [ASSETHELPER getPhotoListOfGroupByIndex:nIndex result:^(NSArray *aPhotos) {
        
        [weakSelf.cvPhotoList reloadData];
        
        weakSelf.cvPhotoList.alpha = 0.3;
        [UIView animateWithDuration:0.2 animations:^(void) {
            [UIView setAnimationDelay:0.1];
            weakSelf.cvPhotoList.alpha = 1.0;
        }];
        
        if (aPhotos.count > 0)
        {
            [weakSelf.cvPhotoList scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
        }
        
        weakSelf.btUp.alpha = 0.0;
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            if (weakSelf.cvPhotoList.contentSize.height < weakSelf.cvPhotoList.frame.size.height)
                weakSelf.btDown.alpha = 0.0;
            else
                weakSelf.btDown.alpha = 1.0;
        });
    }];
    
#ifdef DO_SAVE_SELECTED_ALBUM
    // save selected album
    [self saveSelectedGroup:nIndex];
#endif
    
}

- (void)showPreview:(NSInteger)nIndex
{
    [self.view bringSubviewToFront:_vDimmed];
    
    _ivPreview = [[UIImageView alloc] initWithFrame:_vDimmed.frame];
    _ivPreview.contentMode = UIViewContentModeScaleAspectFit;
    _ivPreview.autoresizingMask = _vDimmed.autoresizingMask;
    [_vDimmed addSubview:_ivPreview];
    
    _ivPreview.image = [ASSETHELPER getImageAtIndex:nIndex type:ASSET_PHOTO_SCREEN_SIZE];
    
    // add gesture for close preview
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanToClosePreview:)];
    [_vDimmed addGestureRecognizer:pan];
    
    [UIView animateWithDuration:0.2 animations:^(void) {
        _vDimmed.alpha = 1.0;
    }];
}

- (void)hidePreview
{
    [self.view bringSubviewToFront:_tvAlbumList];
    [self.view bringSubviewToFront:_vBottomMenu];
    
    [_ivPreview removeFromSuperview];
    _ivPreview = nil;
    
    _vDimmed.alpha = 0.0;
    [_vDimmed removeGestureRecognizer:[_vDimmed.gestureRecognizers lastObject]];
}

/**
 跳转 图片裁剪界面

 @param aResult 图片数组
 @param isNeedBlock 是否需要图片回传
 */
- (void)toPhotoEditVC:(NSArray *)aResult isNeedBlock:(BOOL)isNeedBlock {
    kSelfWeak;
    CFPhotoEditViewController *vc2 = [CFPhotoEditViewController new];
    vc2.imgArr = [aResult mutableCopy];
    vc2.isFromPublish = isNeedBlock;
    vc2.refreshBlock = ^{
        if (weakSelf.refreshBlock) {
            weakSelf.refreshBlock();
        }
    };
    vc2.editPhotosBlock = ^(NSArray *arr) {
        [weakSelf.delegate didSelectPhotosFromDoImagePickerController:self result:arr];
    };
    [self.navigationController pushViewController:vc2 animated:YES];
}
- (void)onSelectPhoto:(id)sender
{
    NSMutableArray *aResult = [[NSMutableArray alloc] initWithCapacity:_dSelected.count];
    NSArray *aKeys = [_dSelected keysSortedByValueUsingSelector:@selector(compare:)];
    
    if(_dSelected.count)
    {
        
        
        if (_nResultType == DO_PICKER_RESULT_UIIMAGE)
        {
            for (int i = 0; i < _dSelected.count; i++) {
                UIImage *img = [ASSETHELPER getImageAtIndex:[aKeys[i] intValue] type:ASSET_PHOTO_SCREEN_SIZE];
                
                //img = %@",img);
                if (img!=nil) {
                    [aResult addObject:[ASSETHELPER getImageAtIndex:[aKeys[i] intValue] type:ASSET_PHOTO_SCREEN_SIZE]];
                }
            }
        }
        else
        {
            for (int i = 0; i < _dSelected.count; i++)
                [aResult addObject:[ASSETHELPER getAssetAtIndex:[aKeys[i] integerValue]]];
        }
        
        [self toPhotoEditVC:aResult isNeedBlock:YES];
        
//        [_delegate didSelectPhotosFromDoImagePickerController:self result:aResult];
        
        
    }else{
        
        [_delegate didCancelDoImagePickerController];
    }
}
- (void)onPanToClosePreview:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint translation = [gestureRecognizer translationInView:self.view];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        [UIView animateWithDuration:0.2 animations:^(void) {
            
            if (_vDimmed.alpha < 0.7)   // close preview
            {
                CGPoint pt = _ivPreview.center;
                if (_ivPreview.center.y > _vDimmed.center.y)
                    pt.y = self.view.frame.size.height * 1.5;
                else if (_ivPreview.center.y < _vDimmed.center.y)
                    pt.y = -self.view.frame.size.height * 1.5;
                
                _ivPreview.center = pt;
                
                [self hidePreview];
            }
            else
            {
                _vDimmed.alpha = 1.0;
                _ivPreview.center = _vDimmed.center;
            }
            
        }];
    }
    else
    {
        _ivPreview.center = CGPointMake(_ivPreview.center.x, _ivPreview.center.y + translation.y);
        [gestureRecognizer setTranslation:CGPointMake(0, 0) inView:self.view];
        
        _vDimmed.alpha = 1 - ABS(_ivPreview.center.y - _vDimmed.center.y) / (self.view.frame.size.height / 2.0);
    }
}

#pragma mark - save selected album
- (void)saveSelectedGroup:(NSInteger)nIndex
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:[[ASSETHELPER getGroupAtIndex:nIndex] valueForProperty:ALAssetsGroupPropertyName] forKey:@"DO_SELECTED_ALBUM"];
    [defaults synchronize];
    
    //[[ASSETHELPER getGroupAtIndex:nIndex] valueForProperty:ALAssetsGroupPropertyName] : %@", [[ASSETHELPER getGroupAtIndex:nIndex] valueForProperty:ALAssetsGroupPropertyName]);
}

- (NSString *)loadSelectedGroup
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //---------> %@", [defaults objectForKey:@"DO_SELECTED_ALBUM"]);
    
    return [defaults objectForKey:@"DO_SELECTED_ALBUM"];
}

- (NSInteger)getSelectedGroupIndex:(NSArray *)aGroups
{
    NSString *strOldAlbumName = [self loadSelectedGroup];
    for (int i = 0; i < aGroups.count; i++)
    {
        NSDictionary *d = [ASSETHELPER getGroupInfo:i];
        if ([d[@"name"] isEqualToString:strOldAlbumName])
            return i;
    }
    
    return -1;
}
- (void)handleEnterForeground:(NSNotification*)notification
{
    [self readAlbumList:NO];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];

    MyLog(@"%@ release", [self class]);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
