//
//  MagicNavigationBar.h
//  MagicView
//
//  Created by LL on 2021/7/6.
//

#import "MAGView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MAGNavigationBar : MAGView

@property (nonatomic, readonly) UIView *backgroundView;

@property (nonatomic, readonly) MAGLabel *titleLabel;

@property (nonatomic, readonly) UIImageView *backImageView;

@property (nonatomic, readonly) UIView *bottomLineView;

/// 标题(titleLabel)是否自动居中，默认是YES
/// @Discussion 只考虑了左侧有一个返回按钮并且右侧没有控件的情况，
///             如果 titleLabel 显示异常请将此属性设置为NO，
///             然后手动调整 titleLabel 的内边距来保证显示正常。
@property (nonatomic, assign, getter=isTitleAutoCenter) BOOL titleAutoCenter;

@end

NS_ASSUME_NONNULL_END
