//
//  UICollectionView+Magic.h
//  MagicView
//
//  Created by LL on 2021/7/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionView (Magic)

- (void)m_registerCells:(NSArray<Class> *)cells;

- (void)m_registerHeaderViews:(NSArray<Class> *)views;

- (void)m_registerFooterViews:(NSArray<Class> *)views;

@end

NS_ASSUME_NONNULL_END
