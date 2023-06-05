//
//  MAGAbstractViewController.m
//  MagicView
//
//  Created by LL on 2021/7/8.
//

#import "MAGAbstractViewController.h"

@implementation MAGAbstractViewController


#pragma mark - Setter
- (void)setCanSlidingBack:(BOOL)canSlidingBack {
    _canSlidingBack = canSlidingBack;
    
    if ([self.navigationController isKindOfClass:MAGNavigationController.class]) {
        ((MAGNavigationController *)self.navigationController).canSlidingBack = canSlidingBack;
    }
}

- (void)setHomeIndicatorHidden:(BOOL)homeIndicatorHidden {
    _homeIndicatorHidden = homeIndicatorHidden;
        
    if (@available(iOS 11.0, *)) {
        [self setNeedsUpdateOfHomeIndicatorAutoHidden];
    }
}

- (void)setStatusBarHidden:(BOOL)statusBarHidden {
    _statusBarHidden = statusBarHidden;
    
    if ([self.navigationController respondsToSelector:@selector(setStatusBarHidden:)]) {
        [(MAGNavigationController *)self.navigationController setStatusBarHidden:statusBarHidden];
    }
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)setStatusBarDefaultStyle {
    if ([self.navigationController respondsToSelector:@selector(setStatusBarDefaultStyle)]) {
        [(MAGNavigationController *)self.navigationController setStatusBarDefaultStyle];
    }
    
    _statusBarStyle = UIStatusBarStyleDefault;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)setStatusBarLightStyle {
    if ([self.navigationController respondsToSelector:@selector(setStatusBarLightStyle)]) {
        [(MAGNavigationController *)self.navigationController setStatusBarLightStyle];
    }
    
    _statusBarStyle = UIStatusBarStyleLightContent;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)setStatusBarDarkStyle {
    if ([self.navigationController respondsToSelector:@selector(setStatusBarDarkStyle)]) {
        [(MAGNavigationController *)self.navigationController setStatusBarDarkStyle];
    }
    
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
