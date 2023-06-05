//
//  MAGTableView.m
//  MagicView
//
//  Created by LL on 2021/9/7.
//

#import "MAGTableView.h"

@interface MAGTableView ()

// FIXME: 测试文案
/// 插入 cell 后需要保持在原位置所需要的滚动距离
/// @discussion 正常情况下插入 cell 后 tableView 的 contentOffset.y 属性没有变化，
///             所以会导致视觉上的滚动，该属性保存着 tableView 需要保持视觉上不滚动所需要的实际滚动距离
/// @note 如果有 section 的话可能会计算不准确，待确认。
@property (nonatomic, assign) NSInteger cellHoverSpacing;

@end

@implementation MAGTableView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    !self.m_frameBlock ?: self.m_frameBlock(self);
}

- (void)setContentOffset:(CGPoint)contentOffset {
    if (self.cellHoverSpacing > 0) {
        contentOffset.y = self.cellHoverSpacing;
        [super setContentOffset:contentOffset];
    } else {
        [super setContentOffset:contentOffset];
    }
}

/// 重写 insertRowsAtIndexPaths: withRowAnimation: 方法来保证往前插入 cell 的时候 tableView不会滚动
- (void)insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
    self.cellHoverSpacing = 0;
    
    // 这里通过第一个元素是不是0来判断是不是往前插入 cell
    if (self.m_cellHover && indexPaths.firstObject.row == 0) {
        // 获取被插入的所有 cell 高度
        BOOL result = [self.delegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)];
        if (result) {
            for (NSIndexPath *indexPath in indexPaths) {
                CGFloat rowHeight = [self.delegate tableView:self heightForRowAtIndexPath:indexPath];
                self.cellHoverSpacing += rowHeight;
            }
        } else {
            self.cellHoverSpacing += (self.rowHeight * indexPaths.count);
        }
        
        if (@available(iOS 11.0, *)) {
            [self performBatchUpdates:^{
                [super insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
            } completion:^(BOOL finished) {
                self.cellHoverSpacing = 0;
            }];
        } else {
            [self beginUpdates];
            [super insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
            [self endUpdates];
            self.cellHoverSpacing = 0;
        }
    } else {
        [super insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    }
}

@end
