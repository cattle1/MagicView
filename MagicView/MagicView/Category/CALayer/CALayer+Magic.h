//
//  CALayer+Magic.h
//  MagicView
//
//  Created by LL on 2021/9/19.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CALayer (Magic)

/// 一个布尔值，用于标识是 loading 下的隐藏状态，便于后续恢复
@property (nonatomic, assign) BOOL m_loadingHidden;

/// 保存 loading 状态下被移除的 contents
@property (nonatomic, strong, nullable) id m_loadingContents;

@end

NS_ASSUME_NONNULL_END
