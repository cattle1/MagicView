//
//  MAGDarkModeViewController.m
//  MagicView
//
//  Created by LL on 2021/10/22.
//

#import "MAGDarkModeViewController.h"

#import "MAGDarkModeViewController1.h"

@implementation MAGDarkModeViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [MAGClickAgent appendDidAppearViewControllerName:@"深色模式页面"];
    [MAGClickAgent event:@"用户进入深色模式页面"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [MAGClickAgent event:@"用户离开深色模式页面"];
}

+ (instancetype)darkModeViewController {
    return [[MAGDarkModeViewController1 alloc] init];
}

- (void)switchDarkMode:(LLUserInterfaceStyle)style {
    if (style == LLDarkManager.userInterfaceStyle) return;
    LLDarkManager.userInterfaceStyle = style;
    
    UIView *snapshotView = [self.view snapshotViewAfterScreenUpdates:NO];
    [self.view addSubview:snapshotView];
    
    [UIView animateWithDuration:0.75 animations:^{
        snapshotView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [snapshotView removeFromSuperview];
    }];
    
    [self.mainTableView reloadData];
    [self.mainTableViewGroup reloadData];
    [self.mainCollectionView reloadData];
    
    switch (style) {
        case LLUserInterfaceStyleLight: {
            [MAGClickAgent event:@"用户切换到浅色模式"];
            [mUserDefault setBool:NO forKey:mIsDarkmodeIdentifier];
        }
            break;
        case LLUserInterfaceStyleDark: {
            [MAGClickAgent event:@"用户切换到深色模式"];
            [mUserDefault setBool:YES forKey:mIsDarkmodeIdentifier];
        }
            break;
        default: {
            // 不推荐使用跟随系统深色模式
        }
            break;
    }
}

@end
