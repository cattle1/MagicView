//
//  MAGBookReaderSetting.h
//  MagicView
//
//  Created by LL on 2021/7/16.
//

#import <Foundation/Foundation.h>

#import "MAGEnumDefine.h"

NS_ASSUME_NONNULL_BEGIN

/// 管理小说阅读器的所有属性，例如翻页动画、字体大小、字体颜色等等
@interface MAGBookReaderManager : NSObject

/// 获取/设置小说阅读器的翻页动画样式
@property (nonatomic, class) MBookReaderAnimate readerAnimate;

@property (nonatomic, class) MBookReaderBackgroundStyle readerBackgroundStyle;

@property (nonatomic, class, readonly) UIImage *readerBackgroundImage;

@property (nonatomic, class, readonly) UIColor *readerTextColor;

@property (nonatomic, class, readonly) UIFont *readerTextFont;

@property (nonatomic, class) CGFloat readerTextSize;

@property (nonatomic, class, readonly) UIFont *readerTitleFont;

@property (nonatomic, class, readonly) CGFloat lineSpacing;

/// 阅读器的Frame
@property (nonatomic, class, readonly) CGRect readerFrame;

/// 阅读器底部广告的高度
@property (nonatomic, class, readonly) CGFloat bottomADHeight;

/// 阅读顶部不安全区域的高度
@property (nonatomic, class, readonly) CGFloat readerTopHeight;

/// 阅读器底部不安全区域的高度
@property (nonatomic, class, readonly) CGFloat readerBottomHeight;

/// 小说内容显示区域
@property (nonatomic, class, readonly) CGRect bookContentFrame;

@end

NS_ASSUME_NONNULL_END
