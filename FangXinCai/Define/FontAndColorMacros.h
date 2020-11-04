//
//  FontAndColorMacros.h
//  MiAiApp
//
//  Created by 徐阳 on 2017/5/18.
//  Copyright © 2017年 徐阳. All rights reserved.
//

//字体大小和颜色配置

#ifndef FontAndColorMacros_h
#define FontAndColorMacros_h

#pragma mark -  间距区

//默认间距
#define KNormalSpace 12.0f

#pragma mark -  颜色区
//主题色 导航栏颜色
//#define CNavBgColor  [UIColor colorWithHexString:@"00AE68"]
//#define CNavBgFontColor  [UIColor colorWithHexString:@"ffffff"]
#define CNavBgColor      [UIColor whiteColor]
#define CNavBgFontColor  [UIColor darkGrayColor]

//默认页面背景色
#define CViewBgColor [UIColor colorWithHexString:@"f2f2f2"]

//分割线颜色
#define CLineColor [UIColor colorWithHexString:@"ededed"]

//按钮颜色
#define TBColorProvideBtnbg UIColorFromRGB(0x3880D8)

//次级字色
#define CFontColor1 [UIColor colorWithHexString:@"1f1f1f"]

//再次级字色
#define CFontColor2 [UIColor colorWithHexString:@"5c5c5c"]

// 获取RGB颜色
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

//主体色 翠绿色
#define basegreenColor [UIColor colorWithRed:0/255.0 green:165/255.0 blue:78/255.0 alpha:255/255.0]
#define freshgreenColor [UIColor colorWithRed:146/255.0 green:226/255.0 blue:107/255.0 alpha:255/255.0]
#define baseyellowColor [UIColor colorWithRed:255/255.0 green:60/255.0 blue:80/255.0 alpha:255/255.0]

// 随机色
#define DRandomColor    [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:arc4random_uniform(255)/255.0]

#pragma mark -  字体区
//字体颜色
#define KClearColor   [UIColor clearColor]
#define KWhiteColor   [UIColor whiteColor]
#define KBlackColor   [UIColor blackColor]
#define KGrayColor    [UIColor grayColor]
#define KGray2Color   [UIColor lightGrayColor]
#define KBlueColor    [UIColor blueColor]
#define KRedColor     [UIColor redColor]
#define kRandomColor  KRGBColor(arc4random_uniform(256)/255.0,arc4random_uniform(256)/255.0,arc4random_uniform(256)/255.0)


//字体大小
#define BOLDSYSTEMFONT(FONTSIZE)[UIFont boldSystemFontOfSize:FONTSIZE]
#define SYSTEMFONT(FONTSIZE)    [UIFont systemFontOfSize:FONTSIZE]
#define FONT(NAME, FONTSIZE)    [UIFont fontWithName:(NAME) size:(FONTSIZE)]
#define FFont1 [UIFont systemFontOfSize:12.0f]

#define HBFontNavTitle [UIFont systemFontOfSize:KZOOM6pt(38)]
#define HBFontTitle    [UIFont systemFontOfSize:KZOOM6pt(28)]
#define HBFontSubTitle [UIFont systemFontOfSize:KZOOM6pt(24)]
#define HBFont20       [UIFont systemFontOfSize:KZOOM6pt(40)]
#define HBFont22       [UIFont systemFontOfSize:KZOOM6pt(44)]
#define HBFont24       [UIFont systemFontOfSize:KZOOM6pt(48)]
#define HBFont10       [UIFont systemFontOfSize:KZOOM6pt(20)]
#define HBFont12       [UIFont systemFontOfSize:KZOOM6pt(24)]
#define HBFont13       [UIFont systemFontOfSize:KZOOM6pt(26)]
#define HBFont14       [UIFont systemFontOfSize:KZOOM6pt(28)]
#define HBFont15       [UIFont systemFontOfSize:KZOOM6pt(30)]
#define HBFont16       [UIFont systemFontOfSize:KZOOM6pt(32)]

/* ------------------字体图片大小坐标适配--------------------- */
#define SNN ([UIScreen mainScreen].bounds.size.width)/(750)
#define KZOOM6pt(pt) ((pt)*(SNN))

//根据图片名字得到图片  ：会copy
#define ImageNamed(imageName)   [UIImage imageNamed:imageName]

//获取图片的宽
#define IMAGEW(imageName)  ImageNamed(imageName).size.width
//获取图片的高
#define IMAGEH(imageName)  ImageNamed(imageName).size.height

#endif /* FontAndColorMacros_h */
