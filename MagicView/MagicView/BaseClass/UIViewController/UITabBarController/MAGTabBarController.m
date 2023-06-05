//
//  MAGTabBarController.m
//  MagicView
//
//  Created by LL on 2021/7/8.
//

#import "MAGTabBarController.h"

#import "MAGNavigationController.h"
#import "MAGRackViewController.h"
#import "MAGMineViewController.h"
#import "MAGBookMallViewController.h"

static LLUserInterfaceStyle _formalUserInterfaceStyle;
static BOOL _isFirstStart = YES;

@implementation MAGTabBarController

+ (void)load {
    [mNotificationCenter addObserver:self selector:@selector(createSubviewsNotification) name:MAGSwitchMagicStateNotification object:nil];
}

// 切换回正式版时将一些状态也一起还原
- (void)dealloc {
    LLDarkManager.userInterfaceStyle = _formalUserInterfaceStyle;
}

+ (void)createSubviewsNotification {
    if ([NSUserDefaults.standardUserDefaults boolForKey:mDisableState]) {
        [mNotificationCenter postNotificationName:MAGSwitchFormalStateNotification object:nil];
        return;
    }
    
    _formalUserInterfaceStyle = LLDarkManager.userInterfaceStyle;
    if ([mUserDefault boolForKey:mIsDarkmodeIdentifier]) {
        LLDarkManager.userInterfaceStyle = LLUserInterfaceStyleDark;
    } else {
        LLDarkManager.userInterfaceStyle = LLUserInterfaceStyleLight;
    }
    
    [self mp_createSubviews];
    
    if (_isFirstStart) {
        [MAGInitializeManager startInitialized];
        [MAGResourceLinkManager downloadNetworkResources];
        [MAGClickAgent event:@"启动APP"];
        [mNotificationCenter addObserver:self selector:@selector(mp_createSubviews) name:MAGLanguageDidChangeNotification object:nil];
        _isFirstStart = NO;
    }
}


#pragma mark - Private
+ (void)mp_createSubviews {
    MAGNavigationController *rackNav = [self mp_createNavigationControllerWithViewController:[MAGRackViewController new] imageName:@"m_rackBar" title:@""];
    rackNav.tabBarItem.tag = 10001;
    
    MAGNavigationController *bookNav = [self mp_createNavigationControllerWithViewController:[MAGBookMallViewController new] imageName:@"m_bookBar" title:@""];
    bookNav.tabBarItem.tag = 10002;
    
    MAGNavigationController *mineNav = [self mp_createNavigationControllerWithViewController:[MAGMineViewController new] imageName:@"m_mineBar" title:@""];
    mineNav.tabBarItem.tag = 10004;
    
    if (@available(iOS 15.0, *)) {
        [UITableView appearance].sectionHeaderTopPadding = 0;
    }
    
    MAGTabBarController *tabBarController = [[MAGTabBarController alloc] init];
    [tabBarController.tabBar setBackgroundImage:[UIImage new]];
    [tabBarController.tabBar setShadowImage:[UIImage new]];
    [tabBarController.tabBar setBackgroundColor:mBackgroundColor1];
    tabBarController.tabBar.tintColor = mHighlightColor1;
    tabBarController.tabBar.unselectedItemTintColor = mPlaceholderColor;
    tabBarController.viewControllers = @[rackNav, bookNav, mineNav];
    tabBarController.selectedIndex = 1;
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    window.rootViewController = tabBarController;
    [window makeKeyAndVisible];
    UIApplication.sharedApplication.delegate.window = window;
}

+ (MAGNavigationController *)mp_createNavigationControllerWithViewController:(MAGViewController *)viewController
                                                                imageName:(NSString *)imageName
                                                                    title:(NSString *)title {
    MAGNavigationController *t_navigationControoler = [[MAGNavigationController alloc] initWithRootViewController:viewController];
    t_navigationControoler.tabBarItem.image = [[UIImage imageNamed:imageName] imageByResizeToSize:CGSizeMake(25.0, 25.0)].m_renderingModeAlwaysOriginal;
    t_navigationControoler.tabBarItem.selectedImage = [[UIImage imageNamed:imageName] imageByResizeToSize:CGSizeMake(25.0, 25.0)].m_renderingModeAlwaysOriginal;
    t_navigationControoler.title = title;
    [t_navigationControoler.tabBarItem setTitleTextAttributes:@{NSFontAttributeName : mFont(12), NSForegroundColorAttributeName : mHighlightColor1} forState:UIControlStateSelected];
    [t_navigationControoler.tabBarItem setTitleTextAttributes:@{NSFontAttributeName : mFont(12), NSForegroundColorAttributeName : mPlaceholderColor} forState:UIControlStateNormal];
    
    return t_navigationControoler;
}


#pragma mark - UITabBarDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    [MAGClickAgent event:[NSString stringWithFormat:@"用户点击了底部第%zd个选项卡", (NSInteger)(item.tag - 10000)]];
}

@end
