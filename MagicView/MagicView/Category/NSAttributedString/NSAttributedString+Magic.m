//
//  NSAttributedString+Magic.m
//  MagicView
//
//  Created by LL on 2021/8/26.
//

#import "NSAttributedString+Magic.h"

@implementation NSAttributedString (Magic)

- (NSArray<NSAttributedString *> *)m_componentsSeparatedBySize:(CGSize)size {
    NSMutableAttributedString *mutableAttr = [self mutableCopy];
    NSMutableArray<NSAttributedString *> *attributedStringArray = [NSMutableArray array];

    while (mutableAttr.length > 0) {
        @autoreleasepool {
            YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:size text:mutableAttr];
            if (NSMaxRange(layout.visibleRange) > mutableAttr.length) break;
            NSAttributedString *pageAttributedString = [mutableAttr attributedSubstringFromRange:layout.visibleRange];
            [mutableAttr deleteCharactersInRange:layout.visibleRange];
            [attributedStringArray addObject:pageAttributedString];
        }
    }

    return [attributedStringArray copy];
}

- (nullable NSAttributedString *)m_separatedBySize:(CGSize)size {    
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:size text:self];
    if (NSMaxRange(layout.visibleRange) > self.length) return nil;;
    return [self attributedSubstringFromRange:layout.visibleRange];
}

@end
