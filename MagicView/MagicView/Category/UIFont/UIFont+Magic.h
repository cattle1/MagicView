//
//  UIFont+Magic.h
//  MagicView
//
//  Created by LL on 2021/8/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIFont (Magic)

/// 计算该字体文字显示所需要的高度(按照一行计算)
- (CGFloat)m_textHeight;

@end

NS_ASSUME_NONNULL_END
