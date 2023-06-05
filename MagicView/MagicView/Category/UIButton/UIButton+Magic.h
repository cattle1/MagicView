//
//  UIButton+Magic.h
//  MagicView
//
//  Created by LL on 2021/9/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 用于 `MAGButton.m_cornerRadius` 属性，当 `m_cornerRadius` 为 `QMUIButtonCornerRadiusAdjustsBounds` 时，`MAGButton` 会在高度变化时自动调整 `m_cornerRadius`，使其始终保持为高度的 1/2。
static const CGFloat MAGButtonCornerRadiusAdjustsBounds = -1;

@interface UIButton (Magic)

/// 计算 UIControlStateNormal 样式下文字1行显示所需要的宽度
@property (nonatomic, readonly) CGFloat m_textWidth;

/**
 * 计算 UIControlStateNormal 样式下文字显示所需要的高度
 *
 * 如果 titleLabel.preferredMaxLayoutWidth 为0，内部会自动开启动态计算高度，
 *
 * 如果 titleLabel.preferredMaxLayoutWidth 大于0则会按照它的值来计算高度，并且不会开启动态计算高度
 */
@property (nonatomic, readonly) CGFloat m_textHeight;

/**
 * 设置最大显示宽度和实际显示宽度相等
 *
 * 该属性通常和 m_textHeight 方法搭配使用，
 * 如果该属性被设置为YES并且 preferredMaxLayoutWidth 为0，
 * 那么当 Label 的宽度发生变化时会自动更新自身高度，
 * 该值默认是NO
 */
@property (nonatomic, assign) BOOL m_maxLayoutWidthEqualWidth;

/**
 * 计算 UIControlStateNormal 样式下文字显示所需要的宽高信息
 *
 * 如果没有设置 titleLabel.preferredMaxLayoutWidth 将会按照一行计算
 */
@property (nonatomic, readonly) CGSize m_textSize;

/// 默认为 0。将其设置为 MAGButtonCornerRadiusAdjustsBounds 可自动保持圆角为按钮高度的一半。
/// 该属性仅对 MAGButton 有效
@property(nonatomic, assign) CGFloat m_cornerRadius;

@end

NS_ASSUME_NONNULL_END
