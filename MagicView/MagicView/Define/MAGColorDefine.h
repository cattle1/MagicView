//
//  MAGColorDefine.h
//  MagicView
//
//  Created by LL on 2021/7/8.
//

#ifndef MAGColorDefine_h
#define MAGColorDefine_h

#import "UIColor+Magic.h"

UIKIT_STATIC_INLINE UIColor *mColorRGBA(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha) {
    return [UIColor colorWithRed:(red)/255.0 green:(green)/255.0 blue:(blue)/255.0 alpha:(alpha)];
}

UIKIT_STATIC_INLINE UIColor *mColorRGB(CGFloat red, CGFloat green, CGFloat blue) {
    return mColorRGBA(red, green, blue, 1.0);
}

UIKIT_STATIC_INLINE UIColor *mColorHex(NSString *hexString) {
    return [UIColor colorWithHexString:hexString];
}

/// 创建并返回一个延迟渐变色，渐变色仅对 MAGView 对象的 backgroundColor 有效
__attribute__((unused)) static UIColor *mGradientColor(UIColor *color, ...) {
    va_list list;
    va_start(list, color);
    NSMutableArray *colorArray = nil;
    if (color) {
        colorArray = [NSMutableArray array];
        [colorArray addObject:color];
        UIColor *t_color;
        while ((t_color = va_arg(list, UIColor *))) {
            [colorArray addObject:t_color];
        }
    }
    va_end(list);
    
    return [UIColor m_delayGradientColorWithColorArray:colorArray];
}

// 随机色
#define mRandomColor mColorRGB(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

// 背景主色
#define mBackgroundColor1 mColorRGB(255, 255, 255).themeColor(mColorRGB(31, 31, 31))

// 背景辅色
#define mBackgroundColor2 mColorRGB(228, 228, 230).themeColor(mColorRGB(61, 61, 65))

// 导航栏背景色
#define mNavBarBackgroundColor mGradientColor(mColorHex(@"#ff8177"), mColorHex(@"#ff867a"), mColorHex(@"#ff8c7f"), mColorHex(@"#f99185"), mColorHex(@"#cf556c"), mColorHex(@"#b12a5b"), nil)

// 导航栏 tintColor
#define mNavBarTintColor UIColor.whiteColor

// 分割线颜色
#define mLineColor mColorRGB(240, 238, 245).themeColor(mColorRGB(39, 39, 39))

// 文字主色
#define mTextColor1 mColorRGB(57, 57, 60).themeColor(mColorRGB(211, 211, 211))

// 文字辅色
#define mTextColor2 mColorRGB(138, 138, 142).themeColor(mColorRGB(152, 152, 159))

// 占位颜色
#define mPlaceholderColor mColorRGB(196, 196, 198).themeColor(mColorRGB(71, 71, 74))

// 高亮主色
#define mHighlightColor1 mColorRGB(253, 188, 35)

// 高亮辅色
#define mHighlightColor2 mColorRGB(88, 86, 214).themeColor(mColorRGB(94, 92, 230))

// 小说阅读器的高亮颜色
#define mBookReaderHighlightColor mColorRGB(30, 144, 255)

#pragma mark - 常用色
#define mClearColor [UIColor clearColor]

#define mBlackColor mColorRGB(57, 56, 60).themeColor(mColorRGB(255, 255, 255))

#define mWhiteColor mColorRGB(255, 255, 255).themeColor(mColorRGB(57, 56, 60))

#define mGrayColor mColorRGB(176, 176, 176).themeColor(mColorRGBA(255, 255, 255, 0.6))

#endif /* MAGColorDefine_h */
