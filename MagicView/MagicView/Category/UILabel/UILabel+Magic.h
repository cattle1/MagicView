//
//  UILabel+Magic.h
//  MagicView
//
//  Created by LL on 2021/7/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (Magic)

/// 计算文字的宽度，不会换行
@property (nonatomic, readonly) CGFloat m_textWidth;

/**
 * 计算文字的高度
 *
 * 默认情况下只计算文字一行的高度
 * 如果 preferredMaxLayoutWidth 有值则按照最大宽度计算高度
 * 如果 preferredMaxLayoutWidth 不能确定可以将 m_maxLayoutWidthEqualWidth 设置为YES来自动计算高度
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

@property (nonatomic, readonly) CGSize m_textSize;

/**
 * 调整文本视图的内边距，默认是UIEdgeInsetsZero
 * @discusstion 只有MAGLabel才会生效，所有由 MAGUIFactory 创建的 lable 都是 MAGLabel
 */
@property (nonatomic, assign) UIEdgeInsets m_edgeInsets;

@end

NS_ASSUME_NONNULL_END
