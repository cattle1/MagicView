//
//  MAGQQManager.m
//  MagicView
//
//  Created by LL on 2021/10/18.
//

#import "MAGQQManager.h"

#if __has_include("TencentOpenAPI/TencentOAuth.h")

#import "TencentOpenAPI/TencentOAuth.h"

#import "MAGImport.h"

@interface MAGQQManager ()<TencentSessionDelegate>

@property (nonatomic, copy) void(^loginComplete)(BOOL result);

@end

@implementation MAGQQManager

static MAGQQManager *_qqManager;
static TencentOAuth *_tencentOAuth;
+ (void)requestLogin:(void (^)(BOOL result))complete {
    _qqManager = [[MAGQQManager alloc] init];
    _qqManager.loginComplete = complete;
    
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:[self QQAppID] andDelegate:_qqManager];
    NSArray *permissions = @[
        kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
        kOPEN_PERMISSION_GET_USER_INFO,
        kOPEN_PERMISSION_GET_INFO
    ];
    
    [_tencentOAuth authorize:permissions];
    
    [MAGClickAgent event:@"用户点击了QQ登录"];
}

+ (nullable NSString *)QQAppID {
    NSDictionary *infoDictionary = NSBundle.mainBundle.infoDictionary;
    NSArray *URLTypes = infoDictionary[@"CFBundleURLTypes"];
    for (NSDictionary *obj in URLTypes) {
        NSArray *URLSchemes = obj[@"CFBundleURLSchemes"];
        for (NSString *appID in URLSchemes) {
            NSString *prefix = @"tencent";
            if ([appID hasPrefix:prefix]) {
                return [appID substringFromIndex:prefix.length];
            }
        }
    }
    
    return nil;
}


#pragma mark - TencentSessionDelegate
- (void)tencentDidLogin {
    void (^loginComplete)(BOOL) = _qqManager.loginComplete;
    _qqManager = nil;
    
    [MAGUserInfoManager touristLogin:_tencentOAuth.openId];
    !loginComplete ?: loginComplete((_tencentOAuth.openId.length > 0));
    
    _tencentOAuth = nil;
    
    [MAGClickAgent event:@"用户QQ登录成功"];
}

- (void)tencentDidNotLogin:(BOOL)cancelled {
    !_qqManager.loginComplete ?: _qqManager.loginComplete(NO);
    _qqManager = nil;
    _tencentOAuth = nil;
    
    [MAGClickAgent event:@"用户取消了QQ登录"];
}

- (void)tencentDidNotNetWork {
    !_qqManager.loginComplete ?: _qqManager.loginComplete(NO);
    _qqManager = nil;
    _tencentOAuth = nil;
    
    [MAGClickAgent event:@"用户QQ登录失败"];
}

@end

#else

@implementation MAGQQManager

+ (void)requestLogin:(void (^)(BOOL result))complete {
    !complete ?: complete(NO);
}

@end

#endif
