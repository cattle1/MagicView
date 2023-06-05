//
//  UIScrollView+Magic.h
//  MagicView
//
//  Created by LL on 2021/9/22.
//

#import <UIKit/UIKit.h>

#import "MJRefresh.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (Magic)

- (MJRefreshNormalHeader *)m_addNormalHeaderRefreshWithRefreshingBlock:(void (^)(void))block;

/// 和 addNormalHeaderRefreshWithRefreshingBlock: 不同的是该方法会适配异形屏
- (MJRefreshNormalHeader *)m_addSafeHeaderRefreshWithRefreshingBlock:(void (^)(void))block;

- (MJRefreshAutoNormalFooter *)m_addNormalFooterRefreshWithRefreshingBlock:(void (^)(void))block;

- (void)m_endRefreshing;

- (void)m_endRefreshingWithNoMoreData;

- (void)m_resetNoMoreData;

@end

NS_ASSUME_NONNULL_END
