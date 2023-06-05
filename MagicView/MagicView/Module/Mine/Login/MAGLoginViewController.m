//
//  MAGLoginViewController.m
//  MagicView
//
//  Created by LL on 2021/10/16.
//

#import "MAGLoginViewController.h"

#import "MAGLoginViewController1.h"
#import "MAGAppleManager.h"
#import "MAGWechatManager.h"
#import "MAGQQManager.h"

@implementation MAGLoginViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [MAGClickAgent appendDidAppearViewControllerName:@"登录页面"];
    [MAGClickAgent event:@"用户进入登录页面"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [MAGClickAgent event:@"用户离开登录页面"];
}

+ (instancetype)loginViewController {
    return [[MAGLoginViewController1 alloc] init];
}

+ (void)presentLoginViewController:(void (^ _Nullable) (BOOL isSuccess))block {
    MAGLoginViewController *loginViewController = [self loginViewController];
    [mCurrentViewController presentViewController:loginViewController animated:YES completion:nil];
}

- (void)touristLogin {
    MAGProgressHUD *hud = [mTopWindow m_promptShowDarkHUDFromText:@"正在登录"];
    
    [MAGUserInfoManager touristLogin:[NSString m_UUIDString]];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(mRandomFloat(1.0, 2.0) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [hud hideAnimated:YES];
        [mMainWindow m_showSuccessHUDFromText:@"登录成功"];
        [self dismissViewControllerAnimated:YES completion:nil];
    });
    
    [MAGClickAgent event:@"用户点击了游客登录"];
}

- (void)accountLogin {
    NSMutableDictionary *accountDict = [[NSDictionary m_dictionaryWithContentsOfFile:MAGFileManager.accountPath] mutableCopy];
    if (accountDict == nil) {
        accountDict = [NSMutableDictionary dictionary];
    }
    
    NSString *accountString = self.accountTextField.text;
    NSString *passwordString = self.passwordTextField.text;
    
    if ([accountDict containsObjectForKey:accountString]) {
        NSString *localPassword = accountDict[accountString];
        if (![localPassword isEqualToString:passwordString]) {
            [mTopWindow m_showErrorHUDFromText:@"账号或密码错误"];
            [MAGClickAgent event:@"用户使用账号和密码登录失败" attributes:@{@"account" : self.accountTextField.text, @"password" : self.passwordTextField.text}];
            return;
        }
    }
    
    MAGProgressHUD *hud = [mTopWindow m_promptShowDarkHUDFromText:@"正在登录"];
    
    [MAGUserInfoManager touristLogin:accountString];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(mRandomFloat(1.0, 2.0) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [hud hideAnimated:YES];
        [mMainWindow m_showSuccessHUDFromText:@"登录成功"];
        [self dismissViewControllerAnimated:YES completion:nil];
    });
    
    [MAGClickAgent event:@"用户使用账号和密码登录成功" attributes:@{@"account" : self.accountTextField.text, @"password" : self.passwordTextField.text}];
    
    [accountDict setObject:passwordString forKey:accountString];
    [accountDict m_writeToFile:MAGFileManager.accountPath];
    NSLog(@"111");
}

- (void)appleLogin {
    MAGProgressHUD *hud = [mMainWindow m_showDarkHUDFromText:@"正在登录"];
    [MAGAppleManager requestLogin:^(BOOL result) {
        [hud hideAnimated:YES];
        if (result) {
            [mMainWindow m_showSuccessHUDFromText:@"登录成功"];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [mMainWindow m_showErrorHUDFromText:@"登录失败"];
        }
    }];
}

- (void)wechatLogin {
    MAGProgressHUD *hud = [mMainWindow m_showDarkHUDFromText:@"正在登录"];
    [MAGWechatManager requestLogin:^(BOOL result) {
        [hud hideAnimated:YES];
        if (result) {
            [mMainWindow m_showSuccessHUDFromText:@"登录成功"];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [mMainWindow m_showErrorHUDFromText:@"登录失败"];
        }
    }];
}

- (void)qqLogin {
    MAGProgressHUD *hud = [mMainWindow m_showDarkHUDFromText:@"正在登录"];
    [MAGQQManager requestLogin:^(BOOL result) {
        [hud hideAnimated:YES];
        if (result) {
            [mMainWindow m_showSuccessHUDFromText:@"登录成功"];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [mMainWindow m_showErrorHUDFromText:@"登录失败"];
        }
    }];
}


#pragma mark - Override
// 解决在正式版上的弹窗问题
- (void)setModalPresentationStyle:(UIModalPresentationStyle)modalPresentationStyle {
    if (@available(iOS 13.0, *)) {
        [super setModalPresentationStyle:UIModalPresentationAutomatic];
    } else {
        [super setModalPresentationStyle:UIModalPresentationPageSheet];
    }
}


#pragma mark - UITextFieldDelegate
- (void)textFieldEditingChanged {
    self.loginButton.enabled = (self.accountTextField.text.length > 0) && (self.passwordTextField.text.length > 0);
}


#pragma mark - Getter
- (UITextField *)accountTextField {
    __autoreleasing UITextField *accountTextField = nil;
    if (!_accountTextField) {
        accountTextField = [MAGUIFactory textFieldWithBackgroundColor:nil placeholder:nil textColor:mTextColor1 font:mFont16 delegate:self isNumber:NO];
        [accountTextField addTarget:self action:@selector(textFieldEditingChanged) forControlEvents:UIControlEventEditingChanged];
        _accountTextField = accountTextField;
    }
    return _accountTextField;
}

- (UITextField *)passwordTextField {
    __autoreleasing UITextField *passwordTextField = nil;
    if (!_passwordTextField) {
        passwordTextField = [MAGUIFactory textFieldWithBackgroundColor:nil placeholder:nil textColor:mTextColor1 font:mFont16 delegate:self isNumber:NO];
        passwordTextField.secureTextEntry = YES;
        [passwordTextField addTarget:self action:@selector(textFieldEditingChanged) forControlEvents:UIControlEventEditingChanged];
        _passwordTextField = passwordTextField;
    }
    return _passwordTextField;
}

- (UIButton *)loginButton {
    __autoreleasing UIButton *loginButton = nil;
    if (!_loginButton) {
        loginButton = [MAGUIFactory buttonWithType:UIButtonTypeSystem backgroundColor:nil font:mBoldFont15 textColor:UIColor.whiteColor target:self action:@selector(accountLogin)];
        [loginButton addObserverBlockForKeyPath:mKEYPATH(loginButton, enabled) block:^(UIButton * _Nonnull loginButton, id  _Nullable oldVal, id  _Nullable newVal) {
            if ([newVal boolValue]) {
                loginButton.backgroundColor = mHighlightColor1;
            } else {
                loginButton.backgroundColor = mBackgroundColor2;
            }
        }];
        loginButton.enabled = NO;
        _loginButton = loginButton;
    }
    return _loginButton;
}

- (ASAuthorizationAppleIDButton *)appleButton {
    __autoreleasing ASAuthorizationAppleIDButton *appleButton = nil;
    if (!_appleButton) {
        if (LLDarkManager.isDarkMode) {
            appleButton = [ASAuthorizationAppleIDButton buttonWithType:ASAuthorizationAppleIDButtonTypeSignIn style:ASAuthorizationAppleIDButtonStyleWhite];
        } else {
            appleButton = [ASAuthorizationAppleIDButton buttonWithType:ASAuthorizationAppleIDButtonTypeSignIn style:ASAuthorizationAppleIDButtonStyleBlack];
        }
        [appleButton m_addTapGestureRecognizer:@selector(appleLogin) target:self];
        _appleButton = appleButton;
    }
    return _appleButton;
}

@end
