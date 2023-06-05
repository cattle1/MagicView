//
//  MAGAppleManager.m
//  MagicView
//
//  Created by LL on 2021/10/18.
//

#import "MAGAppleManager.h"

#import <AuthenticationServices/AuthenticationServices.h>

#import "MAGImport.h"

@interface MAGAppleManager ()<ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding>

@property (nonatomic, copy) void(^loginComplete)(BOOL result);

@end

@implementation MAGAppleManager

static MAGAppleManager *_appleManager;
+ (void)requestLogin:(void (^)(BOOL result))complete {
    if (@available(iOS 13.0, *)) {
        _appleManager = [[MAGAppleManager alloc] init];
        _appleManager.loginComplete = complete;
        
        ASAuthorizationAppleIDProvider *provider = [[ASAuthorizationAppleIDProvider alloc] init];
        ASAuthorizationAppleIDRequest *request = [provider createRequest];
        request.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];

        ASAuthorizationController *authorizationController = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[request]];
        authorizationController.delegate = _appleManager;
        authorizationController.presentationContextProvider = _appleManager;
        [authorizationController performRequests];
    } else {
        !complete ?: complete(NO);
    }
    
    [MAGClickAgent event:@"用户点击了Apple登录"];
}


#pragma mark - ASAuthorizationControllerPresentationContextProviding
- (ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller API_AVAILABLE(ios(13.0)) {
    return mMainWindow;
}


#pragma mark - ASAuthorizationControllerDelegate
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization API_AVAILABLE(ios(13.0)) {
    NSString *user = nil;
    if ([authorization.credential isKindOfClass:ASAuthorizationAppleIDCredential.class]) {
        ASAuthorizationAppleIDCredential *credential = (ASAuthorizationAppleIDCredential *)authorization.credential;
        user = credential.user;
    } else if ([authorization.credential isKindOfClass:ASPasswordCredential.class]) {
        ASPasswordCredential *credential = (ASPasswordCredential *)authorization.credential;
        user = credential.user;
    }
    
    void (^loginComplete)(BOOL) = _appleManager.loginComplete;
    _appleManager = nil;
    
    [MAGUserInfoManager touristLogin:user];
    !loginComplete ?: loginComplete((user != nil));
    
    [MAGClickAgent event:[NSString stringWithFormat:@"用户Apple登录%@", (user != nil) ? @"成功" : @"失败"]];
}

- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error API_AVAILABLE(ios(13.0)) {
    if (_appleManager.loginComplete) {
        _appleManager.loginComplete(NO);
    }
    
    _appleManager = nil;
    
    [MAGClickAgent event:@"用户Apple登录失败"];
}

@end
