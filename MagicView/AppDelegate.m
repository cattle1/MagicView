//
//  AppDelegate.m
//  MagicView
//
//  Created by LL on 2021/7/6.
//

#import "AppDelegate.h"

#import "WXYZ_MainTabbarViewController.h"

#if __has_include("GoogleSignIn/GoogleSignIn.h")
#import "GoogleSignIn/GoogleSignIn.h"
#endif

#if __has_include("FBSDKLoginKit/FBSDKLoginKit.h")
#import "FBSDKLoginKit/FBSDKLoginKit.h"
#endif

#if __has_include("WXApi.h")
#import "WXApi.h"
#endif

#if __has_include("TencentOpenAPI/TencentOAuth.h")
#import "TencentOpenAPI/TencentOAuth.h"
#endif

#if __has_include("BUAdSDK/BUAdSDK.h")
#import "BUAdSDK/BUAdSDK.h"
#endif

typedef NS_ENUM(NSInteger, MAGBundleURLSchemeType) {
    MAGBundleURLSchemeTypeFacebook = 0,
    MAGBundleURLSchemeTypeWechat  = 1,
};

@interface AppDelegate ()
#if __has_include("WXApi.h")
<
WXApiDelegate
>
#endif

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
#if TARGET_IPHONE_SIMULATOR
    [[NSBundle bundleWithPath:@"/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle"] load];
#endif
    
    if (isMagicState) {
        [NSNotificationCenter.defaultCenter postNotificationName:@"MAGSwitchMagicStateNotification" object:nil];
    } else {
        WXYZ_MainTabbarViewController *tabBarController = [[WXYZ_MainTabbarViewController alloc] init];
        self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
        self.window.rootViewController = tabBarController;
        [self.window makeKeyAndVisible];
    }
    
#if __has_include("FBSDKLoginKit/FBSDKLoginKit.h")
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    FBSDKSettings.sharedSettings.appID = [self facebookAppID];
    FBSDKSettings.sharedSettings.autoLogAppEventsEnabled = NO;
#endif
    
#if __has_include("WXApi.h")
    [WXApi registerApp:[self wechatAppID] universalLink:@"https://api-prod.beiwo-manhua.com/app/"];
#endif
    
#if __has_include("BUAdSDK/BUAdSDK.h")
    #ifdef BUA_App_Key
        [BUAdSDKManager setAppID:BUA_App_Key];
        [BUAdSDKManager setIsPaidApp:NO];
    #endif
#endif
    
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
#if __has_include("GoogleSignIn/GoogleSignIn.h")
    if ([[GIDSignIn sharedInstance] handleURL:url]) {
        return [[GIDSignIn sharedInstance] handleURL:url];
    }
#endif

#if __has_include("FBSDKLoginKit/FBSDKLoginKit.h")
    if ([[FBSDKApplicationDelegate sharedInstance] application:app openURL:url options:options]) {
        return [[FBSDKApplicationDelegate sharedInstance] application:app openURL:url options:options];
    }
#endif
    
#if __has_include("WXApi.h")
    if ([WXApi handleOpenURL:url delegate:self]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
#endif
    
#if __has_include("TencentOpenAPI/TencentOAuth.h")
    if ([TencentOAuth HandleOpenURL:url]) {
        return [TencentOAuth HandleOpenURL:url];
    }
#endif
    
    return YES;
}

- (nullable NSString *)facebookAppID {
    return [self bundleURLScheme:MAGBundleURLSchemeTypeFacebook];
}

- (nullable NSString *)wechatAppID {
    return [self bundleURLScheme:MAGBundleURLSchemeTypeWechat];
}

- (nullable NSString *)bundleURLScheme:(MAGBundleURLSchemeType)type {
    NSDictionary *infoDictionary = NSBundle.mainBundle.infoDictionary;
    NSArray *URLTypes = infoDictionary[@"CFBundleURLTypes"];
    for (NSDictionary *obj in URLTypes) {
        NSArray *URLSchemes = obj[@"CFBundleURLSchemes"];
        for (NSString *appID in URLSchemes) {
            switch (type) {
                case MAGBundleURLSchemeTypeFacebook: {
                    NSString *prefix = @"fb";
                    if ([appID hasPrefix:prefix]) {
                        return [appID substringFromIndex:prefix.length];
                    }
                }
                    break;
                case MAGBundleURLSchemeTypeWechat: {
                    if ([appID hasPrefix:@"wx"]) {
                        return appID;
                    }
                }
                    break;
            }
        }
    }
    
    return nil;
}

@end
