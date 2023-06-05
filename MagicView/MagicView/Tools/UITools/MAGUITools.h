//
//  MagicSystemTools.h
//  MagicView
//
//  Created by LL on 2021/7/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MAGUITools : NSObject

/// 获取当前显示的UITabBarController
@property (nonatomic, class, readonly, nullable) UITabBarController *currentTabBarController;

/// 获取当前显示的UINavigationController
@property (nonatomic, class, readonly, nullable) UINavigationController *currentNavigationController;

/// 获取当前显示的UIViewController
@property (nonatomic, class, readonly, nullable) UIViewController *currentViewController;

/// 获取当前显示的UIView
@property (nonatomic, class, readonly, nullable) UIView *currentView;

/// 顶部不安全区域的高度
@property (nonatomic, class, readonly) CGFloat safeAreaInsertTop;

/// 底部不安全区域的高度
@property (nonatomic, class, readonly) CGFloat safeAreaInsertBottom;

/// 获取tabBar的高度
@property (nonatomic, class, readonly) CGFloat tabBarHeight;

/// 获取navigationBar的高度
@property (nonatomic, class, readonly) CGFloat navigationBarHeight;


/// 计算某个字体下文字的单行高度
+ (CGFloat)calcTextHeightFromFont:(UIFont *)font;

/// 计算文字宽高信息
/// @param fitSize 指定限制的尺寸
/// @param text 要计算的简单文本NSString或属性字符串NSAttributedString
/// @param numberOfLines 指定最大显示的行数
/// @param font 指定计算时文本的字体，nil表示使用默认17号字体
/// @param textAlignment 指定文本对齐方式，默认是NSTextAlignmentNatural
/// @param lineBreakMode 指定多行时断字模式，默认NSLineBreakByTruncatingTail
/// @param minimumScaleFactor 指定文本的最小缩放因子，默认为0
/// @param shadowOffset 指定阴影偏移位置
+ (CGSize)calcTextSize:(CGSize)fitSize
                  text:(id)text
         numberOfLines:(NSInteger)numberOfLines
                  font:(nullable UIFont *)font
         textAlignment:(NSTextAlignment)textAlignment
         lineBreakMode:(NSLineBreakMode)lineBreakMode
    minimumScaleFactor:(CGFloat)minimumScaleFactor
          shadowOffset:(CGSize)shadowOffset;

@end

NS_ASSUME_NONNULL_END
