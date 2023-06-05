//
//  UIView+Magic.h
//  MagicView
//
//  Created by LL on 2021/8/25.
//

#import <UIKit/UIKit.h>

#import "MAGProgressHUD.h"
#import "MAGEnumDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Magic)

/**
 * 当视图Layout发生变化时通知观察者
 *
 * 注意：必须是MAG类对象才能响应该方法回调，所有通过 MAGUIFactory 创建的对象都是MAG类对象
 */
@property (nonatomic, strong) void(^m_frameBlock)(id view);

/**
 * 快速给指定位置添加圆角
 *
 * 该方法内部采用的是Layer和Path实现的圆角，所以会有离屏渲染，对于有性能要求的页面慎用
 *
 * 当size发生变化后请重新调用该方法绘制圆角，可以搭配 m_frameBlock 实时获取size
 */
- (void)m_setRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii;

- (void)m_popViewController;

// 快速添加点击手势事件
- (UITapGestureRecognizer *)m_addTapGestureRecognizer:(SEL)action;

- (UITapGestureRecognizer *)m_addTapGestureRecognizer:(SEL)action target:(id)target;

@end




@interface UIView (MAGBorder)

/// 分割线样式
typedef NS_ENUM(NSInteger, MBorderLineStyle) {
    MBorderLineStyleAll     = 0,
    MBorderLineStyleTop     = 1 << 0,
    MBorderLineStyleBottom  = 1 << 1,
    MBorderLineStyleLeft    = 1 << 2,
    MBorderLineStyleRight   = 1 << 3,
};

/// 给 UIView 对象添加边框
/// @param borderStyle 边框的样式
/// @param borderColor 边框的颜色
/// @param borderWidth 边框的宽度，如果设置为0则隐藏边框
- (void)m_addBorderLineWithStyle:(MBorderLineStyle)borderStyle borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;

/// 给 UIView 对象添加边框
/// @param borderStyle 边框的样式
/// @param borderColor 边框的颜色
/// @param borderWidth 边框的宽度，如果设置为0则隐藏边框
/// @param handler 自定义边框样式
- (void)m_addBorderLineWithStyle:(MBorderLineStyle)borderStyle borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth handler:(void (^ _Nullable)(MBorderLineStyle style, UIView *lineView))handler;

@end




@interface UIView (MAGLoading)

/// 隐藏所有子视图，并且展示一个默认样式的Loading
- (void)m_startLoadingWithColor:(UIColor *)color;

/// 恢复所有视图，并且结束Loading状态
- (void)m_stopLoading;

@end




@interface UIView (MAGProgressHUD)

#pragma mark Loading样式的HUD
/// 延迟0.5秒弹出一个背景透明带文字的菊花HUD，当title为nil不显示文字
- (MAGProgressHUD *)m_showClearHUDFromText:(nullable NSString *)title;

/// 立即弹出一个背景透明带文字的菊花HUD，当title为nil不显示文字
- (MAGProgressHUD *)m_promptShowClearHUDFromText:(nullable NSString *)title;

/// 延迟0.5秒弹出一个背景半透明带文字的菊花HUD，当title为nil不显示文字
- (MAGProgressHUD *)m_showDarkHUDFromText:(nullable NSString *)title;

/// 立即弹出一个背景半透明带文字的菊花HUD，当title为nil不显示文字
- (MAGProgressHUD *)m_promptShowDarkHUDFromText:(nullable NSString *)title;


#pragma mark 文字样式的HUD
/// 根据Error.code弹出一个Error样式的文字HUD
- (nullable MAGProgressHUD *)m_showErrorHUDFromError:(NSError *)error;

/// 弹出一个Error样式的文字HUD
- (nullable MAGProgressHUD *)m_showErrorHUDFromText:(NSString *)text;

/// 弹出一个Success样式的文字HUD
- (nullable MAGProgressHUD *)m_showSuccessHUDFromText:(NSString *)text;

/// 弹出一个普通样式的文字HUD
- (nullable MAGProgressHUD *)m_showNormalHUDFromText:(NSString *)text;

/// 隐藏 HUD，当您的任务完成时，可以使用它来隐藏 HUD
- (void)m_hideAnimated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
