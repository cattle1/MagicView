//
//  NSAttributedString+Magic.h
//  MagicView
//
//  Created by LL on 2021/8/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSAttributedString (Magic)

/// 按照 size 将富文本分割成多个富文本
- (NSArray<NSAttributedString *> *)m_componentsSeparatedBySize:(CGSize)size;

/// 按钮 size 将富文本分割并返回第一个 size 区间的内容
- (nullable NSAttributedString *)m_separatedBySize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
