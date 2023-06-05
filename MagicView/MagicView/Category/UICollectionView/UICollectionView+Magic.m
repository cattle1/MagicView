//
//  UICollectionView+Magic.m
//  MagicView
//
//  Created by LL on 2021/7/9.
//

#import "UICollectionView+Magic.h"

@implementation UICollectionView (Magic)

- (void)m_registerCells:(NSArray<Class> *)cells {
    for (Class obj in cells) {
        [self registerClass:obj forCellWithReuseIdentifier:NSStringFromClass(obj)];
    }
}

- (void)m_registerHeaderViews:(NSArray<Class> *)views {
    for (Class obj in views) {
        [self registerClass:obj forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(obj)];
    }
}

- (void)m_registerFooterViews:(NSArray<Class> *)views {
    for (Class obj in views) {
        [self registerClass:obj forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass(obj)];
    }
}

@end
