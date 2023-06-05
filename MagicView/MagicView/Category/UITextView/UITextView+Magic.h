//
//  UITextView+Magic.h
//  MagicView
//
//  Created by LL on 2022/1/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (Magic)

/// 文本视图显示的占位符文本(当文本视图内容为空时)。
/// @discussion 为该属性设置一个新值会替换 `m_placeholderAttributedText` 中的文本。
/// @return 返回 `m_placeholderAttributedText` 中的纯文本。
@property (nonatomic, copy) NSString *m_placeholderText;

/// 占位符文本的字体，默认值与 `font` 属性相同。
/// @discussion 为该属性设置一个新值将会导致新字体应用于整个 `m_placeholderAttributedText`。
/// @return 返回 `m_placeholderAttributedText` 第1个属性的字体。
@property (nonatomic, strong, nullable) UIFont *m_placeholderFont;

/// 占位符文本的颜色，默认为灰色([UIColor systemGrayColor])。
/// @discussion 为该属性设置一个新值将会导致新颜色应用于整个 `m_placeholderAttributedText`。
/// @return 返回 `m_placeholderAttributedText` 第1个属性的文字颜色。
@property (nonatomic, strong) UIColor *m_placeholderTextColor;

/// 文本视图显示的样式占位符文本(当文本视图内容为空时)。
/// @discussion 给这个属性设置一个新值将会替换 `m_placeholderText` 、`m_placeholderFont` 、 `m_placeholderTextColor` 的值，
@property (nonatomic, copy, nullable) NSAttributedString *m_placeholderAttributedText;

@end

NS_ASSUME_NONNULL_END
