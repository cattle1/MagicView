//
//  MAGAbstractViewController.h
//  MagicView
//
//  Created by LL on 2021/7/8.
//

#import <UIKit/UIKit.h>

#import "MAGNavigationController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MAGAbstractViewController : UIViewController

/// 是否开启侧滑返回，默认是YES
@property (nonatomic, assign) BOOL canSlidingBack;

/// 设置/获取底部Home条的隐藏状态，默认是非隐藏状态
@property (nonatomic, assign) BOOL homeIndicatorHidden;

/// 设置/获取状态栏的隐藏状态，默认是非隐藏状态
@property (nonatomic, assign) BOOL statusBarHidden;

/// 获取当前控制器的状态栏样式
@property (nonatomic, assign, readonly) UIStatusBarStyle statusBarStyle;

/// 设置状态栏为默认样式
- (void)setStatusBarDefaultStyle;

/// 设置状态栏为浅色样式
- (void)setStatusBarLightStyle;

/// 设置状态栏为深色样式
- (void)setStatusBarDarkStyle;

/// 深色模式下设置为浅色状态栏，浅色模式下设置为深色状态栏
- (void)setStatusBarAutoStyle;

@end

NS_ASSUME_NONNULL_END
