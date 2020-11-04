//
//  FullScreenScrollView.m
//  FDC
//
//  Created by wzz on 15/3/27.
//  Copyright (c) 2015年 JinZongCai. All rights reserved.
//

#import "FullScreenScrollView.h"
#import "UIImageView+WebCache.h"

@interface FullScreenScrollView (){
    
    CGRect ScreenRect;
    
    NSArray *AllArray;
    
    UILabel *FullTitltLable;
    
    int currentPage_full;
    
}

@property (nonatomic, assign)float scale_;


@end

@implementation FullScreenScrollView

-(instancetype)initWithPicutreArray:(NSArray*)PicutreArray withCurrentPage:(int)currentPage{
    
    ScreenRect = [UIScreen mainScreen].bounds;
    
    self = [self initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, ScreenRect.size.height)];
    
    if (self) {
        AllArray = PicutreArray;
        currentPage_full = currentPage;
        self.scrollEnabled = YES;
        self.pagingEnabled = YES;
        self.delegate = self;
        self.contentSize = CGSizeMake(ScreenRect.size.width*PicutreArray.count, ScreenRect.size.height);
        
        [self insertPhotos];
        
        self.contentOffset = CGPointMake(self.bounds.size.width*(currentPage_full-1), 0);
        
        [self insertFullTitleLable];
        
    }
    
    
    return self;
}


-(void)insertPhotos{
    
    for (int i = 0; i<AllArray.count; i++){
        
        
        
        UIScrollView *s = [[UIScrollView alloc] initWithFrame:CGRectMake(self.bounds.size.width*i, 0, self.bounds.size.width, self.bounds.size.height)];
        s.backgroundColor = [UIColor clearColor];
        s.contentSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
        s.showsHorizontalScrollIndicator = NO;
        s.showsVerticalScrollIndicator = NO;
        s.delegate = self;
        s.minimumZoomScale = 1.0;
        s.maximumZoomScale = 3.0;
        s.tag = i+1;
        [s setZoomScale:1.0];
        
        UIImageView *imageview = [[UIImageView alloc] init];
        
        UITapGestureRecognizer *tapSign = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(HiddenFullSceen:)];
        [tapSign setNumberOfTapsRequired:1];
        [imageview addGestureRecognizer:tapSign];
        
        
        UITapGestureRecognizer *doubleTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        
        [doubleTap setNumberOfTapsRequired:2];
        
        [tapSign requireGestureRecognizerToFail:doubleTap];
        
        
        imageview.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        [imageview setContentMode:UIViewContentModeScaleAspectFit];
        imageview.userInteractionEnabled = YES;
        imageview.tag = i+1;
        [imageview addGestureRecognizer:doubleTap];
        [s addSubview:imageview];
        
        [self addSubview:s];
        
        if ([AllArray[i] isKindOfClass:[NSString class]]) {
            

//            [imageview sd_setImageWithURL:[NSURL URLWithString:AllArray[i]]];
            
//            [[Animation shareAnimation] CreateAnimationAt:s];
            
            NSURL *imgUrl = [NSURL URLWithString:AllArray[i]];
            
            __block float d = 0;
            __block BOOL isDownlaod = NO;
            [imageview sd_setImageWithURL:imgUrl placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
                
                
                d = (float)receivedSize/expectedSize;
                isDownlaod = YES;
                
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (image != nil && isDownlaod == YES) {
                    
//                    [[Animation shareAnimation] stopAnimationAt:s];
                    
                    imageview.alpha = 0;
                    [UIView animateWithDuration:0.5 animations:^{
                        imageview.alpha = 1;
                    } completion:^(BOOL finished) {
                    }];
                } else if (image != nil && isDownlaod == NO) {
                    imageview.image = image;
                }
            }];

        
            
        } else if ([AllArray[i] isKindOfClass:[UIImage class]]){
            if (AllArray[i]) {
                imageview.image = AllArray[i];
            } else{

                imageview.image =[UIImage imageNamed:@""];
            }

        }else if ([AllArray[i] isKindOfClass:[UIImageView class]]){
            
            UIImageView *SubIV = AllArray[i];
            
            if (SubIV.image) {
                imageview.image = SubIV.image;
            }else{

                imageview.image =[UIImage imageNamed:@""];
            }
            
            
        }else{

            [imageview sd_setImageWithURL:AllArray[i]];
        }
    }

}

-(void)insertFullTitleLable{
    
    //UIView *Mainview = [[UIApplication sharedApplication].delegate window];
    
    FullTitltLable = [[UILabel alloc]init];
//    FullTitltLable.frame = Frame((currentPage_full-1)*self.bounds.size.width, Screen_Height-40, Screen_Width, 40);
    FullTitltLable.frame=CGRectMake((currentPage_full-1)*self.bounds.size.width, KScreenHeight-60, KScreenWidth, 40);
    FullTitltLable.text = [NSString stringWithFormat:@"%d/%d",currentPage_full,AllArray.count?AllArray.count : 1];
    FullTitltLable.backgroundColor = [UIColor clearColor];
    FullTitltLable.textColor = [UIColor whiteColor];
    FullTitltLable.textAlignment = NSTextAlignmentCenter;
    
    if(AllArray.count)
    {
    
        [self addSubview:FullTitltLable];
        
    }
//    self.contentOffset = CGPointMake(FrameW(self)*(currentPage_full-1), 0);
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(HiddenFullSceen:)];
//    [self.superview addGestureRecognizer:tap];
    
}

-(void)HiddenFullSceen:(UIGestureRecognizer*)ges{
    
//    [ges.view removeFromSuperview];
    

    [UIView animateWithDuration:0.3 animations:^{
        
        self.alpha=0;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        [FullTitltLable removeFromSuperview];
        
    }];

    
}

#pragma mark - ScrollView delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGRect rect = FullTitltLable.frame;
    
    FullTitltLable.frame = CGRectMake(self.contentOffset.x, rect.origin.y, rect.size.width, rect.size.height);
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    for (UIView *v in scrollView.subviews){
        return v;
    }
    return nil;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView == self){
        
        int Imagepage =  self.contentOffset.x/CGRectGetWidth(self.frame);
        
        int allCount = self.contentSize.width/CGRectGetWidth(self.frame);
        
        FullTitltLable.text = [NSString stringWithFormat:@"%d/%d",Imagepage+1,allCount];
        
        CGFloat x = scrollView.contentOffset.x;
        if (x==offset){
            
        }
        else {
            offset = x;
            for (UIScrollView *s in scrollView.subviews){
                if ([s isKindOfClass:[UIScrollView class]]){
                    [s setZoomScale:1.0];
                    UIImageView *image = [[s subviews] objectAtIndex:0];
                    image.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
                }
            }
        }
    }
}

//- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
//
//}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView{

    UIView *v = [scrollView.subviews objectAtIndex:0];
    if ([v isKindOfClass:[UIImageView class]]){
        if (scrollView.zoomScale<1.0){
//         v.center = CGPointMake(scrollView.frame.size.width/2.0, scrollView.frame.size.height/2.0);
        }
    }
}

#pragma mark -
-(void)handleDoubleTap:(UIGestureRecognizer *)gesture{
    
    UIScrollView *ZoomSc = (UIScrollView*)gesture.view.superview;
    
    if (ZoomSc.zoomScale == 3.0) {
        [ZoomSc setZoomScale:1.0 animated:YES];
        return;
    }
    
    float newScale = [ZoomSc zoomScale] * 1.5;
    CGRect zoomRect = [self zoomRectForScale:newScale  inView:ZoomSc withCenter:[gesture locationInView:gesture.view]];
    UIView *view = gesture.view.superview;
    if ([view isKindOfClass:[UIScrollView class]]){
        UIScrollView *s = (UIScrollView *)view;
        [s zoomToRect:zoomRect animated:YES];
    }
    
    
    
}

#pragma mark - Utility methods

-(CGRect)zoomRectForScale:(float)scale inView:(UIScrollView*)scrollView withCenter:(CGPoint)center {

CGRect zoomRect;

zoomRect.size.height = [scrollView frame].size.height / scale;
zoomRect.size.width  = [scrollView frame].size.width  / scale;

zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);

return zoomRect;
}


/*
-(CGRect)resizeImageSize:(CGRect)rect{
    //    //x:%f y:%f width:%f height:%f ", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    CGRect newRect;
    
    CGSize newSize;
    CGPoint newOri;
    
    CGSize oldSize = rect.size;
    if (oldSize.width>=320.0 || oldSize.height>=460.0){
        float scale = (oldSize.width/320.0>oldSize.height/460.0?oldSize.width/320.0:oldSize.height/460.0);
        newSize.width = oldSize.width/scale;
        newSize.height = oldSize.height/scale;
    }
    else {
        newSize = oldSize;
    }
    newOri.x = (320.0-newSize.width)/2.0;
    newOri.y = (460.0-newSize.height)/2.0;
    
    newRect.size = newSize;
    newRect.origin = newOri;
    
    return newRect;
}
*/

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
// Drawing code
}
*/

@end
