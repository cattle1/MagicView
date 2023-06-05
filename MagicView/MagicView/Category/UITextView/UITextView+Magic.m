//
//  UITextView+Magic.m
//  MagicView
//
//  Created by LL on 2022/1/24.
//

#import "UITextView+Magic.h"

@implementation UITextView (Magic)

- (void)setM_placeholderText:(NSString *)m_placeholderText {
    NSAttributedString *origin_attr = [self m_placeholderAttributedText];
    NSMutableAttributedString *t_attr = [[NSMutableAttributedString alloc] initWithString:m_placeholderText ?: @"" attributes:origin_attr.attributes];
    if (t_attr.font == nil) {
        [t_attr addAttribute:NSFontAttributeName value:self.font range:t_attr.rangeOfAll];
    }
    if (t_attr.color == nil) {
        [t_attr addAttribute:NSForegroundColorAttributeName value:[UIColor systemGrayColor] range:t_attr.rangeOfAll];
    }
    [self setM_placeholderAttributedText:t_attr];
}

- (NSString *)m_placeholderText {
    NSAttributedString *attr = [self m_placeholderAttributedText];
    return attr.string ?: @"";
}

- (void)setM_placeholderFont:(UIFont *)m_placeholderFont {
    NSMutableAttributedString *t_attr = [[self m_placeholderAttributedText] mutableCopy];
    t_attr.font = m_placeholderFont ?: self.font;
    [self setM_placeholderAttributedText:[t_attr copy]];
}

- (UIFont *)m_placeholderFont {
    NSAttributedString *attr = [self m_placeholderAttributedText];
    if (attr.font) {
        return attr.font;
    } else {
        return self.font;
    }
}

- (void)setM_placeholderTextColor:(UIColor *)m_placeholderTextColor {
    NSMutableAttributedString *t_attr = [[self m_placeholderAttributedText] mutableCopy];
    t_attr.color = m_placeholderTextColor ?: [UIColor systemGrayColor];
    [self setM_placeholderAttributedText:[t_attr copy]];
}

- (UIColor *)m_placeholderTextColor {
    NSAttributedString *attr = [self m_placeholderAttributedText];
    if (attr.color) {
        return attr.color;
    } else {
        return [UIColor systemGrayColor];
    }
}

- (void)setM_placeholderAttributedText:(NSAttributedString *)m_placeholderAttributedText {
    objc_setAssociatedObject(self, @selector(m_placeholderAttributedText), m_placeholderAttributedText, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self setNeedsDisplay];
}

- (NSAttributedString *)m_placeholderAttributedText {
    return objc_getAssociatedObject(self, @selector(m_placeholderAttributedText));
}

@end
