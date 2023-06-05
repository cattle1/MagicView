//
//  WXYZ_MainTabbarViewController.m
//  MagicView
//
//  Created by LL on 2021/7/6.
//

#import "WXYZ_MainTabbarViewController.h"

#import "WXYZ_RackViewController.h"
#import "WXYZ_MallViewController.h"
#import "WXYZ_DiscoverViewController.h"
#import "WXYZ_MineViewController.h"

@implementation WXYZ_MainTabbarViewController

+ (void)load {
    // 切换到正式版(请不要删除，因为壳子需要用到，也不要修改通知名称)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchFormalStateNotification) name:@"MAGSwitchFormalStateNotification" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createSubviews];
}

#pragma mark - UI
- (void)createSubviews {
    UINavigationController *rackNav = [self mp_createNavigationControllerWithViewController:[[WXYZ_RackViewController alloc] init] imageName:@"bookRack" title:@"书架"];
    
    UINavigationController *mallNav = [self mp_createNavigationControllerWithViewController:[[WXYZ_MallViewController alloc] init] imageName:@"bookMall" title:@"书城"];
    
    UINavigationController *discoverNav = [self mp_createNavigationControllerWithViewController:[[WXYZ_DiscoverViewController alloc] init] imageName:@"discover" title:@"发现"];
    
    UINavigationController *mineNav = [self mp_createNavigationControllerWithViewController:[[WXYZ_MineViewController alloc] init] imageName:@"mine" title:@"我的"];
    
    self.viewControllers = @[rackNav, mallNav, discoverNav, mineNav];
}


#pragma mark - Notification
+ (void)switchFormalStateNotification {
    UIWindow *window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    window.rootViewController = [[WXYZ_MainTabbarViewController alloc] init];
    [window makeKeyAndVisible];
    UIApplication.sharedApplication.delegate.window = window;
}


#pragma mark - Private
- (UINavigationController *)mp_createNavigationControllerWithViewController:(UIViewController *)viewController
                                                                imageName:(NSString *)imageName
                                                                    title:(NSString *)title {
    UINavigationController *t_navigationControoler = [[UINavigationController alloc] initWithRootViewController:viewController];
    t_navigationControoler.tabBarItem.image = [UIImage imageNamed:imageName];
    t_navigationControoler.tabBarItem.selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_select", imageName]];
    t_navigationControoler.title = title;
    [t_navigationControoler.tabBarItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:10.0],
                                                                NSForegroundColorAttributeName : [UIColor colorWithRed:255.0 / 255.0 green:153.0 / 255.0 blue:102.0 / 255.0 alpha:1.0]} forState:UIControlStateSelected];
    [t_navigationControoler.tabBarItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:10.0],
                                                                NSForegroundColorAttributeName : [UIColor colorWithRed:153.0 / 255.0 green:153.0 / 255.0 blue:153.0 / 255.0 alpha:1.0]} forState:UIControlStateNormal];
    
    return t_navigationControoler;
}

@end

