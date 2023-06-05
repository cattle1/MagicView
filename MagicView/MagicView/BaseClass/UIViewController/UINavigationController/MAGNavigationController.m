//
//  MAGNavigationController.m
//  MagicView
//
//  Created by LL on 2021/7/8.
//

#import "MAGNavigationController.h"

@implementation MAGNavigationController

@dynamic delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    
    [self setNavigationBarHidden:NO];
    [self.navigationBar setHidden:YES];
    [self.interactivePopGestureRecognizer addTarget:self action:@selector(handleInteractivePopGestureRecognizer:)];
}


#pragma mark - UINavigationControllerDelegate
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (viewController == nil) return;
    
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    BOOL isRootVC = (viewController == navigationController.viewControllers.firstObject);
    if (self.canSlidingBack) {
        self.canSlidingBack = !isRootVC;
    }
}

// 接管系统手势返回的回调
- (void)handleInteractivePopGestureRecognizer:(UIScreenEdgePanGestureRecognizer *)gestureRecognizer {
    if ([self.delegate respondsToSelector:@selector(navigationController:poppingByInteractiveGestureRecognizer:isCancelled:viewControllerWillDisappear:viewControllerWillAppear:)]) {
        UIViewController<MAGNavigationControllerTransitionDelegate> *viewControllerWillDisappear = [self.transitionCoordinator viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIViewController<MAGNavigationControllerTransitionDelegate> *viewControllerWillAppear = [self.transitionCoordinator viewControllerForKey:UITransitionContextToViewControllerKey];
        
        [self.delegate navigationController:self poppingByInteractiveGestureRecognizer:gestureRecognizer isCancelled:self.transitionCoordinator.cancelled viewControllerWillDisappear:viewControllerWillDisappear viewControllerWillAppear:viewControllerWillAppear];
    }
}


#pragma mark - Setter/Getter
- (void)setCanSlidingBack:(BOOL)canSlidingBack {
    _canSlidingBack = canSlidingBack;
    
    self.interactivePopGestureRecognizer.enabled = canSlidingBack;
}

- (void)setHomeIndicatorHidden:(BOOL)homeIndicatorHidden {
    _homeIndicatorHidden = homeIndicatorHidden;
        
    if (@available(iOS 11.0, *)) {
        [self setNeedsUpdateOfHomeIndicatorAutoHidden];
    }
}

- (void)setStatusBarHidden:(BOOL)statusBarHidden {
    _statusBarHidden = statusBarHidden;
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)setStatusBarDefaultStyle {
    _statusBarStyle = UIStatusBarStyleDefault;
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)setStatusBarLightStyle {
    _statusBarStyle = UIStatusBarStyleLightContent;
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)setStatusBarDarkStyle {
    if (@available(iOS 13.0, *)) {
        _statusBarStyle = UIStatusBarStyleDarkContent;
    } else {
        _statusBarStyle = UIStatusBarStyleDefault;
    }
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)setStatusBarAutoStyle {
    if (LLDarkManager.isDarkMode) {
        [self setStatusBarLightStyle];
    } else {
        [self setStatusBarDarkStyle];
    }
}


#pragma mark - UIKit
- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.statusBarStyle;
}

- (BOOL)prefersStatusBarHidden {
    return self.statusBarHidden;
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    return self.homeIndicatorHidden;
}

@end
