//
//  CFImagePickerVC.h
//  codeTest
//
//  Created by yssj on 2017/2/7.
//  Copyright © 2017年 CooFree. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DO_PICKER_RESULT_UIIMAGE    0

#define DO_NO_LIMIT_SELECT          -1
#define DO_SAVE_SELECTED_ALBUM


@interface CFImagePickerVC : UIViewController

@property (nonatomic, copy) dispatch_block_t refreshBlock;

@property (assign, nonatomic) id            delegate;

@property (readwrite)   NSInteger           nMaxCount;      // -1 : no limit
@property (readwrite)   NSInteger           nColumnCount;   // 2, 3, or 4
@property (readwrite)   NSInteger           nResultType;    // default : DO_PICKER_RESULT_UIIMAGE

@property (strong, nonatomic)  UICollectionView   *cvPhotoList;
@property (strong, nonatomic)  UITableView        *tvAlbumList;
@property (weak, nonatomic) IBOutlet UIView             *vDimmed;

@property (assign,nonatomic)   BOOL           isPublish;    //发布


// init
- (void)initControls;
- (void)readAlbumList:(BOOL)bFirst;

// bottom menu
@property (weak, nonatomic) IBOutlet UIView             *vBottomMenu;
@property (weak, nonatomic) IBOutlet UIButton           *btSelectAlbum;
@property (weak, nonatomic) IBOutlet UIButton           *btOK;
@property (weak, nonatomic) IBOutlet UIImageView        *ivLine1;
@property (weak, nonatomic) IBOutlet UIImageView        *ivLine2;
@property (weak, nonatomic) IBOutlet UILabel            *lbSelectCount;
@property (weak, nonatomic) IBOutlet UIImageView        *ivShowMark;

- (void)initBottomMenu;
- (IBAction)onSelectPhoto:(id)sender;
- (IBAction)onCancel:(id)sender;
- (IBAction)onSelectAlbum:(id)sender;
- (void)hideBottomMenu;


// side buttons
@property (weak, nonatomic) IBOutlet UIButton           *btUp;
@property (weak, nonatomic) IBOutlet UIButton           *btDown;

- (IBAction)onUp:(id)sender;
- (IBAction)onDown:(id)sender;


// photos
@property (strong, nonatomic)   UIImageView             *ivPreview;

- (void)showPhotosInGroup:(NSInteger)nIndex;    // nIndex : index in album array
- (void)showPreview:(NSInteger)nIndex;          // nIndex : index in photo array
- (void)hidePreview;


// select photos
@property (strong, nonatomic)   NSMutableDictionary     *dSelected;
@property (strong, nonatomic)	NSIndexPath				*lastAccessed;

@end

@protocol CFImagePickerVCDelegate

- (void)didCancelDoImagePickerController;
- (void)didSelectPhotosFromDoImagePickerController:(CFImagePickerVC *)picker result:(NSArray *)aSelected;

@end
