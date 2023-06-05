//
//  UITableView+Magic.m
//  MagicView
//
//  Created by LL on 2021/7/9.
//

#import "UITableView+Magic.h"

#import "MAGTableSectionView.h"

@implementation UITableView (Magic)

- (MAGTableSectionView *)m_reusableSectionView {
    return [self dequeueReusableHeaderFooterViewWithIdentifier:MAGTableSectionView.className];
}

- (void)m_registerCells:(NSArray<Class> *)cells {
    for (Class obj in cells) {
        [self registerClass:obj forCellReuseIdentifier:NSStringFromClass(obj)];
    }
}

- (void)m_registerSectionView:(NSArray<Class> *)views {
    for (Class obj in views) {
        [self registerClass:obj forHeaderFooterViewReuseIdentifier:NSStringFromClass(obj)];
    }
}

- (void)setM_cellHover:(BOOL)m_cellHover {
    [self setAssociateValue:@(m_cellHover) withKey:@selector(m_cellHover)];
}

- (BOOL)m_cellHover {
    return [[self getAssociatedValueForKey:@selector(m_cellHover)] boolValue];
}

@end
