//
//  MAGNavigationController.h
//  MagicView
//
//  Created by LL on 2021/7/8.
//

#import <UIKit/UIKit.h>

@class MAGNavigationController;

NS_ASSUME_NONNULL_BEGIN

@protocol MAGNavigationControllerTransitionDelegate <UINavigationControllerDelegate>

@optional

/**
 *  当前界面正处于手势返回的过程中，可自行通过 gestureRecognizer.state 来区分手势返回的各个阶段。手势返回有多个阶段（手势返回开始、拖拽过程中、松手并成功返回、松手但不切换界面），不同阶段的 viewController 的状态可能不一样。
 *  @param navigationController 当前正在手势返回的 MAGNavigationController，请勿通过 vc.navigationController 获取 MAGNavigationController 的引用，而应该用本参数。因为某些手势阶段，vc.navigationController 得到的是 nil。
 *  @param gestureRecognizer 手势对象
 *  @param isCancelled 表示当前手势返回是否取消，只有在松手后这个参数的值才有意义
 *  @param viewControllerWillDisappear 手势返回中顶部的那个 vc，松手时如果成功手势返回，则该参数表示被 pop 的界面，如果手势返回取消，则该参数表示背后的界面。
 *  @param viewControllerWillAppear 手势返回中背后的那个 vc，松手时如果成功手势返回，则该参数表示背后的界面，如果手势返回取消，则该参数表示当前顶部的界面。
 */
- (void)navigationController:(nonnull MAGNavigationController *)navigationController
poppingByInteractiveGestureRecognizer:(nullable UIScreenEdgePanGestureRecognizer *)gestureRecognizer
                 isCancelled:(BOOL)isCancelled
 viewControllerWillDisappear:(nullable UIViewController *)viewControllerWillDisappear
    viewControllerWillAppear:(nullable UIViewController *)viewControllerWillAppear;

@end


@interface MAGNavigationController : UINavigationController<MAGNavigationControllerTransitionDelegate>

/// 是否开启侧滑返回，默认是YES
@property (nonatomic, assign) BOOL canSlidingBack;

/// 设置/获取底部Home条的隐藏状态，默认是非隐藏状态
@property (nonatomic, assign) BOOL homeIndicatorHidden;

/// 设置/获取状态栏的隐藏状态，默认是非隐藏状态
@property (nonatomic, assign) BOOL statusBarHidden;

/// 获取当前控制器的状态栏样式
@property (nonatomic, assign, readonly) UIStatusBarStyle statusBarStyle;

@property (nonatomic, weak) id<MAGNavigationControllerTransitionDelegate> delegate;

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
