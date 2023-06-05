//
//  UITableView+Magic.h
//  MagicView
//
//  Created by LL on 2021/7/9.
//

#import <UIKit/UIKit.h>

@class MAGTableSectionView;

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (Magic)

/// 返回一个空白的占位 sectionView
@property (nonatomic, readonly) MAGTableSectionView *m_reusableSectionView;

/// 设置为YES表示开启单元格悬停，默认为NO
/// @discussion 默认情况下，当你向 TableView 往前插入 Cell 时会导致TableView自动滚动到前面的Cell位置而不是停留在当前位置，
///             将该属性设置为YES将会使TableView停留在当前位置，仅对往前插入有效，因为往末尾插入cell不会导致滚动。
/// @note 请使用 insertRowsAtIndexPaths: withRowAnimation: 方法进行插入，仅对MAG子类生效
@property (nonatomic, assign) BOOL m_cellHover;

- (void)m_registerCells:(NSArray<Class> *)cells;

- (void)m_registerSectionView:(NSArray<Class> *)views;

@end

NS_ASSUME_NONNULL_END
