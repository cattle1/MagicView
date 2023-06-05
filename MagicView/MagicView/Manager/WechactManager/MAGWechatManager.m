//
//  MAGWechatManager.m
//  MagicView
//
//  Created by LL on 2021/10/18.
//

#import "MAGWechatManager.h"

#if __has_include("WXApi.h")
#import "WXApi.h"

#import "MAGImport.h"

@implementation MAGWechatManager

static void (^_loginHandler)(BOOL);
+ (void)requestLogin:(void (^)(BOOL result))complete {
    _loginHandler = complete;
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo";
    [WXApi sendReq:req completion:nil];
    
    [MAGClickAgent event:@"用户点击了微信登录"];
}

void MAGWechatLoginResult(BOOL isSuccess) {
    if (isSuccess) {
        [MAGUserInfoManager touristLogin:@"wechact"];
    }
    !_loginHandler ?: _loginHandler(isSuccess);
    _loginHandler = nil;
}

@end


@implementation WXApi (MAGWechact)

+ (void)initialize {
    [self swizzleClassMethod:NSSelectorFromString(@"handleAuthOpenUrl:delegate:") with:@selector(mag_handleAuthOpenUrl:delegate:)];
}

+ (void)mag_handleAuthOpenUrl:(NSURL *)accesstoken delegate:(id)delegate {
    [self mag_handleAuthOpenUrl:accesstoken delegate:delegate];
    
    NSString *wechactAppID = [self mp_wechatAppID];
    // 如果登录失败微信会返回 wechatAppID加://，通过字符串判断是否登录成功
    BOOL result = ![accesstoken.absoluteString isEqualToString:[NSString stringWithFormat:@"%@://", wechactAppID]];
    if (accesstoken == nil) result = NO;
    
    MAGWechatLoginResult(result);
    
    [MAGClickAgent event:[NSString stringWithFormat:@"用户微信登录%@", result ? @"成功" : @"失败"]];
}

+ (nullable NSString *)mp_wechatAppID {
    NSDictionary *infoDictionary = NSBundle.mainBundle.infoDictionary;
    NSArray *URLTypes = infoDictionary[@"CFBundleURLTypes"];
    for (NSDictionary *obj in URLTypes) {
        NSArray *URLSchemes = obj[@"CFBundleURLSchemes"];
        for (NSString *appID in URLSchemes) {
            if ([appID hasPrefix:@"wx"]) {
                return appID;
            }
        }
    }
    
    return nil;
}

@end

#else

@implementation MAGWechatManager

+ (void)requestLogin:(void (^)(BOOL result))complete {
    !complete ?: complete(NO);
}

@end

#endif
