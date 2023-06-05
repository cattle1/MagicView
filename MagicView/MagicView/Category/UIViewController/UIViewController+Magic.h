//
//  UIViewController+Magic.h
//  MagicView
//
//  Created by LL on 2021/7/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Magic)

/// 自动返回上个页面
/// @discussion 如果当前页面是 push 进入的则执行 pop，否则执行 dismiss
- (void)m_popViewController;

@end

NS_ASSUME_NONNULL_END
