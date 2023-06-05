//
//  MAGTableViewCell.h
//  MagicView
//
//  Created by LL on 2021/7/9.
//

#import <UIKit/UIKit.h>

#import "MAGImport.h"

NS_ASSUME_NONNULL_BEGIN

@interface MAGTableViewCell : UITableViewCell

@property (nonatomic, weak, nullable) UITableView *mainTableView;

@property (nonatomic, strong, nullable) NSIndexPath *cellIndexPath;

@property (nonatomic, weak) UIView *lineView;

@property (nonatomic, assign, getter=isHiddenLine) BOOL hiddenLine;

/// contentView 的替代视图
/// @discussion 创建该 View 的作用是方便调整四周边距、圆角、动画或其他属性
@property (nonatomic, weak) UIView *mainView;

- (void)initialize;

- (void)createSubviews;

@end

NS_ASSUME_NONNULL_END
